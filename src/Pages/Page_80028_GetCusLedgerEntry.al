/// <summary>
/// Page YVS Get Cus. Ledger Entry (ID 80028).
/// </summary>
page 80028 "YVS Get Cus. Ledger Entry"
{

    SourceTable = "Cust. Ledger Entry";
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    Caption = 'Get Cust. Ledger Entry';
    SourceTableTemporary = true;
    PageType = List;
    RefreshOnActivate = true;
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            repeater("GROUP")
            {
                Caption = 'Lines';
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the number of the Customer account that the entry is linked to.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Customer entry''s posting date.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the document type that the vendor entry belongs to.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the vendor entry''s document number.';
                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies a description of the vendor entry.';
                }
                field("Original Amount"; -Rec."Original Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Original Amount field.';
                    Caption = 'Original Amount';
                }
                field("YVS Receipt Amount"; Rec."YVS Receipt Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the YVS Receipt Amount field.';
                    Caption = 'Receipt Amount ';
                }
                field("YVS Remaining Amt."; Rec."YVS Remaining Amt.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Billing Remaining Amt.(LCY) field.';
                    Caption = 'Remaining Amount';
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Remaining Amount", "Original Amount", Amount, "YVS Receipt Amount");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN
            CreateLines();
    end;

    /// <summary>
    /// SetDocument.
    /// </summary>
    /// <param name="BillingRcptHeader">Record "Billing Receipt Header".</param>
    procedure SetDocument(BillingRcptHeader: Record "YVS Billing Receipt Header")
    begin
        BillRcptHeader.GET(BillingRcptHeader."Document Type", BillingRcptHeader."No.");
    end;

    local procedure CreateLines()
    var
        CUstLedger: Record "Cust. Ledger Entry" temporary;
        BillRcptLine: Record "YVS Billing Receipt Line";
        ltPuchaseInvoiceHeader: Record "Purch. Inv. Header";
        ltPurchaseCRHeader: Record "Purch. Cr. Memo Hdr.";
    begin
        CUstLedger.COPY(Rec, true);
        CurrPage.SETSELECTIONFILTER(CUstLedger);
        IF CUstLedger.FindSet() THEN
            REPEAT
                CUstLedger.CalcFields("Original Amt. (LCY)", CUstLedger."Original Amount");
                BillRcptLine.INIT();
                BillRcptLine."Document Type" := DocumentType;
                BillRcptLine."Document No." := DocumentNo;
                BillRcptLine."Line No." := GetLastLine();
                BillRcptLine.INSERT();

                BillRcptLine."Source Ledger Entry No." := CUstLedger."Entry No.";
                BillRcptLine."Source Document Date" := CUstLedger."Document Date";
                BillRcptLine."Source Document No." := CUstLedger."Document No.";
                BillRcptLine."Source Ext. Document No." := CUstLedger."External Document No.";
                BillRcptLine."Source Due Date" := CUstLedger."Due Date";
                BillRcptLine."Source Amount (LCY)" := ABS(CUstLedger."Original Amt. (LCY)");
                BillRcptLine."Source Amount" := ABS(CUstLedger."Original Amount");
                BillRcptLine."Source Description" := CUstLedger.Description;
                BillRcptLine."Source Currency Code" := CUstLedger."Currency Code";
                BillRcptLine."Source Document Type" := BillRcptLine."Source Document Type"::Invoice;
                if CUstLedger."Document Type" = CUstLedger."Document Type"::Invoice then begin
                    BillRcptLine."Amount" := ABS(CUstLedger."YVS Remaining Amt.") * -1;
                    if ltPuchaseInvoiceHeader.GET(CUstLedger."Document No.") then
                        BillRcptLine."Source Ext. Document No." := ltPuchaseInvoiceHeader."Vendor Invoice No.";
                end else begin
                    BillRcptLine."Amount" := ABS(CUstLedger."YVS Remaining Amt.");
                    if ltPurchaseCRHeader.GET(CUstLedger."Document No.") then
                        BillRcptLine."Source Ext. Document No." := ltPurchaseCRHeader."Vendor Cr. Memo No.";

                end;
                BillRcptLine.Modify();
            UNTIL CUstLedger.NEXT() = 0;

    end;


    local procedure GetLastLine(): Integer;
    var
        BillRcptLine: Record "YVS Billing Receipt Line";
    begin
        BillRcptLine.reset();
        BillRcptLine.SetFilter("Document Type", '%1', DocumentType);
        BillRcptLine.SetFilter("Document No.", '%1', DocumentNo);
        if BillRcptLine.FindLast() then
            exit(BillRcptLine."Line No." + 10000);
        exit(10000);
    end;


    /// <summary>
    /// SetTableData.
    /// </summary>
    /// <param name="pVendorNo">code[20].</param>
    /// <param name="pDocumentType">Enum "Document Type".</param>
    /// <param name="pDocumentNo">code[30].</param>
    procedure SetTableData(pVendorNo: code[20]; pDocumentType: Enum "YVS Billing Document Type"; pDocumentNo: code[20])
    var
        CustLedger: Record "Cust. Ledger Entry";
    begin
        DocumentType := pDocumentType;
        DocumentNo := pDocumentNo;
        CustLedger.reset();
        CustLedger.SetRange("Customer No.", pVendorNo);
        CustLedger.SetFilter("Document Type", '%1|%2', CustLedger."Document Type"::Invoice, CustLedger."Document Type"::"Credit Memo");
        CustLedger.setrange(Open, true);
        if CustLedger.FindSet() then
            repeat
                CustLedger.CalcFields("Remaining Amount", "YVS Receipt Amount");

                if pDocumentType = pDocumentType::"Sales Receipt" then
                    if (ABS(CustLedger."Remaining Amount") - abs(CustLedger."YVS Receipt Amount")) > 0 then begin
                        rec.Init();
                        rec.TransferFields(CustLedger);
                        if CustLedger."Document Type" = CustLedger."Document Type"::Invoice then
                            rec."YVS Remaining Amt." := -(ABS(CustLedger."Remaining Amount") - abs(CustLedger."YVS Receipt Amount"))
                        else
                            rec."YVS Remaining Amt." := (ABS(CustLedger."Remaining Amount") - abs(CustLedger."YVS Receipt Amount"));
                        rec.Insert();
                    end;
            until CustLedger.Next() = 0;
    end;



    var
        BillRcptHeader: Record "YVS Billing Receipt Header";
        DocumentNo: code[20];
        DocumentType: Enum "YVS Billing Document Type";
}