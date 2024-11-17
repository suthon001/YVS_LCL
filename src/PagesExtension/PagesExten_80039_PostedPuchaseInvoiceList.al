/// <summary>
/// PageExtension PostedInvoiceList (ID 80039) extends Record Posted Purchase Invoices.
/// </summary>
pageextension 80039 "YVS PostedInvoiceList" extends "Posted Purchase Invoices"
{
    layout
    {

        modify("No. Printed")
        {
            Visible = not CheckDisableLCL;
        }
        modify(Cancelled)
        {
            Visible = not CheckDisableLCL;
        }
        modify(Closed)
        {
            Visible = not CheckDisableLCL;
        }
        modify("Pay-to Vendor No.")
        {
            Visible = CheckDisableLCL;
        }
        modify("Pay-to Name")
        {
            Visible = CheckDisableLCL;
        }
        modify(Corrective)
        {
            Visible = not CheckDisableLCL;
        }
        modify("Posting Date")
        {
            Visible = CheckDisableLCL;
        }
        modify("Document Date")
        {
            Visible = CheckDisableLCL;
        }
        modify("Payment Method Code")
        {
            Visible = CheckDisableLCL;
        }
        modify("Payment Terms Code")
        {
            Visible = CheckDisableLCL;
        }
        // moveafter("No."; "Posting Date", "Document Date", "Due Date", "Vendor Invoice No.", "Buy-from Vendor No.", "Pay-to Vendor No.", "Buy-from Vendor Name", "Pay-to Name",
        //  "Currency Code", "Location Code", "Payment Method Code", "Payment Terms Code", Amount, "Amount Including VAT", "Remaining Amount")
        addafter("Remaining Amount")
        {
            field("Head Office"; Rec."YVS Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Head Office field.';
                Visible = CheckDisableLCL;
            }
            field("VAT Branch Code"; Rec."YVS VAT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the VAT Branch Code field.';
                Visible = CheckDisableLCL;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
                Visible = CheckDisableLCL;
            }
        }
        addafter("Due Date")
        {
            field("YVS Purchase Order No."; rec."YVS Purchase Order No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Purchase Order No. field.';
                Visible = CheckDisableLCL;
            }
        }
    }
    actions
    {
        modify(Navigate)
        {
            Promoted = true;
            PromotedCategory = Category8;
        }

        addlast(Reporting)
        {
            action("AP Voucher")
            {
                Caption = 'AP Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                Visible = CheckDisableLCL;
                ToolTip = 'Executes the AP Voucher action.';
                trigger OnAction()
                var
                    APVoucher: Report "YVS AP Voucher (Post)";
                    PurchaseHeader: Record "Purch. Inv. Header";
                begin
                    PurchaseHeader.reset();
                    PurchaseHeader.Copy(Rec);
                    APVoucher."SetGLEntry"(PurchaseHeader);
                    APVoucher.RunModal();
                end;
            }
        }

    }
    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";
}