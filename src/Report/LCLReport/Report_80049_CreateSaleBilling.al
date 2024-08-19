/// <summary>
/// Report YVS Create Sale Billing (ID 81004).
/// </summary>
report 81004 "YVS Create Sale Billing"
{
    Caption = 'Create Sale Billing';
    ProcessingOnly = true;
    UsageCategory = None;
    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Customer Posting Group", "Payment Terms Code";
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No.");
                RequestFilterFields = "Due Date";
                DataItemTableView = sorting("Entry No.") where(Open = const(true), "Document Type" = filter(invoice | "Credit Memo"));
                CalcFields = "Remaining Amount", "YVS Billing Amount", "Original Amt. (LCY)", "Original Amount";
                trigger OnAfterGetRecord()
                var
                    SalesInvoiceLine: Record "Sales Invoice Line";
                    SalesCrLine: Record "Sales Cr.Memo Line";
                    ltRemainingAmt: Decimal;

                begin
                    if ABS("Remaining Amount") > ABS("YVS Billing Amount") then begin
                        ltRemainingAmt := 0;
                        SalesBillingLine.Init();
                        SalesBillingLine."Document Type" := SalesBillingLine."Document Type"::"Sales Billing";
                        SalesBillingLine."Document No." := DocumentNo;
                        SalesBillingLine."Line No." := GetLastLine(SalesBillingLine."Document Type", SalesBillingLine."Document No.");
                        SalesBillingLine.Insert();
                        SalesBillingLine."Source Ledger Entry No." := "Entry No.";
                        SalesBillingLine."Source Document Date" := "Document Date";

                        SalesBillingLine."Source Document No." := "Document No.";
                        SalesBillingLine."Source Ext. Document No." := "External Document No.";
                        SalesBillingLine."Source Due Date" := "Due Date";
                        SalesBillingLine."Source Amount (LCY)" := ABS("Original Amt. (LCY)");
                        SalesBillingLine."Source Amount" := ABS("Original Amount");
                        SalesBillingLine."Source Description" := Description;
                        SalesBillingLine."Source Currency Code" := "Currency Code";
                        SalesBillingLine."Source Ext. Document No." := "External Document No.";

                        if "Document Type" = "Document Type"::Invoice then begin
                            SalesBillingLine."Source Document Type" := SalesBillingLine."Source Document Type"::Invoice;

                            ltRemainingAmt := (ABS("Remaining Amount") - abs("YVS Billing Amount"));
                            SalesBillingLine."Amount" := ABS(ltRemainingAmt);

                            SalesInvoiceLine.reset();
                            SalesInvoiceLine.ReadIsolation := ReadIsolation::ReadUncommitted;
                            SalesInvoiceLine.SetRange("Document No.", SalesBillingLine."Source Document No.");
                            SalesInvoiceLine.SetFilter("VAT %", '<>%1', 0);
                            if SalesInvoiceLine.FindFirst() then
                                SalesBillingLine."Vat %" := SalesInvoiceLine."VAT %";
                        end else begin
                            ltRemainingAmt := -(ABS("Remaining Amount") - abs("YVS Billing Amount"));
                            SalesBillingLine."Amount" := -ABS(ltRemainingAmt);
                            SalesBillingLine."Source Document Type" := SalesBillingLine."Source Document Type"::"Credit Memo";
                            SalesCrLine.reset();
                            SalesCrLine.ReadIsolation := ReadIsolation::ReadUncommitted;
                            SalesCrLine.SetRange("Document No.", SalesBillingLine."Source Document No.");
                            SalesCrLine.SetFilter("VAT %", '<>%1', 0);
                            if SalesCrLine.FindFirst() then
                                SalesBillingLine."Vat %" := SalesCrLine."VAT %";
                        end;
                        SalesBillingLine.CalAmtExcludeVat();
                        SalesBillingLine.Modify();
                    end;
                end;
            }
            trigger OnPreDataItem()
            begin
                if SalesBillingDate = 0D then
                    ERROR('Document Date must have a value');
                if NoSeries = '' then
                    ERROR('No Series must have a value');
                FromDocumnetCreated := '';
                ToDocumnetCreated := '';
            end;

            trigger OnAfterGetRecord()

            begin

                if not GuiAllowed() then
                    LockTimeout(false);
                IsCreateBilling := CheckRemainingCustLedger(Customer);
                if IsCreateBilling then begin
                    DocumentNo := NoSeriesMgt.GetNextNo(NoSeries, WorkDate(), true);
                    SaleBillingHeader.Init();
                    SaleBillingHeader."Document Type" := SaleBillingHeader."Document Type"::"Sales Billing";
                    SaleBillingHeader."No." := DocumentNo;
                    SaleBillingHeader."Posting Date" := SalesBillingDate;
                    SaleBillingHeader."Document Date" := SalesBillingDate;
                    SaleBillingHeader."No. Series" := NoSeries;
                    SaleBillingHeader.Insert(true);
                    SaleBillingHeader.Validate("Bill/Pay-to Cust/Vend No.", "No.");
                    SaleBillingHeader.Modify();
                    if FromDocumnetCreated = '' then
                        FromDocumnetCreated := DocumentNo;
                    ToDocumnetCreated := DocumentNo;
                end;
            end;

            trigger OnPostDataItem()
            begin
                if FromDocumnetCreated = '' then
                    Message('Nothing to Create')
                else
                    if FromDocumnetCreated = ToDocumnetCreated then
                        Message(StrSubstNo(OpenNewSalesBillingQst, FromDocumnetCreated))
                    else
                        Message(StrSubstNo(OpenNewSalesBillingMulti, FromDocumnetCreated, ToDocumnetCreated));
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    Caption = 'Option';
                    field(SalesBillingDate; SalesBillingDate)
                    {
                        Caption = 'Sales Billing Date';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Sales Billing Date field.';
                    }
                    field(NoSeries; NoSeries)
                    {
                        Caption = 'No. Series';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the No. Series field.';
                        TableRelation = "No. Series";
                    }
                }
            }
        }
        trigger OnInit()
        var
            SalesSetup: Record "Sales & Receivables Setup";
        begin
            SalesSetup.GET();
            SalesBillingDate := Today();
            NoSeries := SalesSetup."YVS Sales Billing Nos.";
        end;

    }
    local procedure CheckRemainingCustLedger(pCustomer: Record Customer): Boolean
    begin
        CustomerLedger.reset();
        CustomerLedger.CopyFilters("Cust. Ledger Entry");
        CustomerLedger.SetFilter("Document Type", '%1..%2', CustomerLedger."Document Type"::Invoice, CustomerLedger."Document Type"::"Credit Memo");
        CustomerLedger.SetRange("Customer No.", pCustomer."No.");
        CustomerLedger.SetRange(Open, true);
        if CustomerLedger.FindFirst() then
            repeat
                CustomerLedger.CalcFields("Remaining Amount", "YVS Billing Amount");
                if CustomerLedger."Remaining Amount" > CustomerLedger."YVS Billing Amount" then
                    exit(true);
            until CustomerLedger.next() = 0;
        exit(false);
    end;

    local procedure GetLastLine(pDocType: Enum "YVS Billing Document Type"; pDocNo: code[20]): Integer;
    var
        BillRcptLine: Record "YVS Billing Receipt Line";
    begin
        BillRcptLine.reset();
        BillRcptLine.SetFilter("Document Type", '%1', pDocType);
        BillRcptLine.SetFilter("Document No.", '%1', pDocNo);
        if BillRcptLine.FindLast() then
            exit(BillRcptLine."Line No." + 10000);
        exit(10000);
    end;

    var
        SaleBillingHeader: Record "YVS Billing Receipt Header";
        SalesBillingLine: Record "YVS Billing Receipt Line";

        CustomerLedger: Record "Cust. Ledger Entry";
        NoSeriesMgt: Codeunit "No. Series";
        DocumentNo, NoSeries : code[20];
        SalesBillingDate: Date;
        IsCreateBilling: Boolean;

        FromDocumnetCreated, ToDocumnetCreated : Text;
        OpenNewSalesBillingQst: Label 'Create Sale Billing No. %1', Locked = true;
        OpenNewSalesBillingMulti: Label 'Create Sale Billing No. %1 to %2', Locked = true;

}
