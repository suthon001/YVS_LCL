/// <summary>
/// PageExtension YVS Purchase Order Subpage (ID 80070) extends Record Purchase Order Subform.
/// </summary>
pageextension 80070 "YVS Purchase Order Subpage" extends "Purchase Order Subform"
{
    layout
    {
        addfirst(Control1)
        {
            field("YVS Ref. PQ No."; rec."YVS Ref. PQ No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Ref. PR No. field.';
                Visible = CheckDisableLCL;
            }
            field("YVS Ref. PQ Line No."; rec."YVS Ref. PQ Line No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Ref. PR Line No. field.';
                Visible = CheckDisableLCL;
            }
        }


        // movefirst(Control1; Type, "No.", Description, "Description 2", "Location Code", "Bin Code", "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group", Quantity, "Unit of Measure Code", "Direct Unit Cost", "Line Discount %", "Line Discount Amount", "Line Amount",
        // "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", ShortcutDimCode3, ShortcutDimCode4, ShortcutDimCode5, ShortcutDimCode6, ShortcutDimCode7, ShortcutDimCode8, "Qty. to Receive", "Quantity Received", "Qty. to Invoice", "Quantity Invoiced")
        addafter("Qty. to Receive")
        {
            field("YVS Qty. to Cancel"; rec."YVS Qty. to Cancel")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Qty. to Cancel field.';
                Visible = CheckDisableLCL;
            }
        }


    }
    actions
    {
        addlast(processing)
        {
            action("Get Purchase Lines")
            {
                Caption = 'Get Purchase Lines';
                Image = GetLines;
                ApplicationArea = all;
                ToolTip = 'Executes the Get Purchase Lines action.';
                Visible = CheckDisableLCL;
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.GET(rec."Document Type", rec."Document No.");
                    PurchaseHeader.TestField(Status, PurchaseHeader.Status::Open);
                    rec.GetPurchaseQuotesLine();
                end;
            }
        }
    }
    trigger OnDeleteRecord(): Boolean
    var
        PQLine: Record "Purchase Line";
    begin
        if CheckDisableLCL then
            if rec."YVS Ref. PQ No." <> '' then
                if PQLine.GET(PQLine."Document Type"::Quote, rec."YVS Ref. PQ No.", rec."YVS Ref. PQ Line No.") then begin
                    PQLine."Outstanding Quantity" := PQLine."Outstanding Quantity" + rec.Quantity;
                    PQLine."Outstanding Qty. (Base)" := PQLine."Outstanding Qty. (Base)" + rec."Quantity (Base)";
                    PQLine."Completely Received" := PQLine."Outstanding Quantity" = 0;
                    PQLine.Modify();
                end else
                    if PQLine.GET(PQLine."Document Type"::"YVS Purchase Request", rec."YVS Ref. PQ No.", rec."YVS Ref. PQ Line No.") then begin
                        PQLine."Outstanding Quantity" := PQLine."Outstanding Quantity" + rec.Quantity;
                        PQLine."Outstanding Qty. (Base)" := PQLine."Outstanding Qty. (Base)" + rec."Quantity (Base)";
                        PQLine."Completely Received" := PQLine."Outstanding Quantity" = 0;
                        PQLine.Modify();
                    end;
    end;

    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";
}