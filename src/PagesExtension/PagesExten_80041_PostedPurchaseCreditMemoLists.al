/// <summary>
/// PageExtension YVS ExtenPostPurchCreditLists (ID 80041) extends Record Posted Purchase Credit Memos.
/// </summary>
pageextension 80041 "YVS ExtenPostPurchCreditLists" extends "Posted Purchase Credit Memos"
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
        modify(Paid)
        {
            Visible = not CheckDisableLCL;
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
        modify("Pay-to Vendor No.")
        {
            Visible = CheckDisableLCL;
        }
        modify("Pay-to Name")
        {
            Visible = CheckDisableLCL;
        }


        //   moveafter("No."; "Posting Date", "Document Date", "Due Date", "Buy-from Vendor No.", "Pay-to Vendor No.", "Buy-from Vendor Name", "Pay-to Name",
        //  "Currency Code", "Location Code", Amount, "Amount Including VAT", "Remaining Amount")

    }
    actions
    {
        modify("&Navigate")
        {
            Promoted = true;
            PromotedCategory = Category5;
        }
        addlast(Reporting)
        {
            action("AP CN Voucher")
            {
                Caption = 'AP CN Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                Visible = CheckDisableLCL;
                ToolTip = 'Executes the AP Voucher action.';
                trigger OnAction()
                var
                    APVoucher: Report "YVS AP CN Voucher (Post)";
                    PurchaseHeader: Record "Purch. Cr. Memo Hdr.";
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