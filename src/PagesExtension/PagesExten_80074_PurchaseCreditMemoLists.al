/// <summary>
/// PageExtension YVS Purchase Credit MemosLists (ID 80074) extends Record Purchase Credit Memos.
/// </summary>
pageextension 80074 "YVS Purchase Credit MemosLists" extends "Purchase Credit Memos"
{

    layout
    {

        modify(Status)
        {
            Visible = CheckDisableLCL;
        }
        modify("Posting Date")
        {
            Visible = CheckDisableLCL;
        }
        modify("Vendor Authorization No.")
        {
            Visible = not CheckDisableLCL;
        }
        modify("Vendor Cr. Memo No.")
        {
            Visible = not CheckDisableLCL;
        }
        modify("Assigned User ID")
        {
            Visible = not CheckDisableLCL;
        }
        modify("Location Code")
        {
            Visible = not CheckDisableLCL;
        }
        modify("Currency Code")
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
        modify("Document Date")
        {
            Visible = CheckDisableLCL;
        }
        // moveafter("No."; Status, "Posting Date", "Document Date", "Buy-from Vendor No.", "Buy-from Vendor Name", "Pay-to Vendor No.", "Pay-to Name",
        //   Amount, "Due Date", "Currency Code")
        addafter("Pay-to Name")
        {

            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = all;
                Caption = 'Posting Description"';
                ToolTip = 'Specifies additional posting information for the document. After you post the document, the description can add detail to vendor and customer ledger entries.';
                Visible = CheckDisableLCL;
            }

        }

        addafter(Amount)
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = all;
                Caption = 'Amount Including VAT';
                ToolTip = 'Specifies the total of the amounts, including VAT, on all the lines on the document.';
                Visible = CheckDisableLCL;
            }
        }
        addafter("Currency Code")
        {
            field("Head Office"; Rec."YVS Head Office")
            {
                ApplicationArea = all;
                Caption = 'Head Office';
                ToolTip = 'Specifies the value of the Head Office field.';
                Visible = CheckDisableLCL;
            }
            field("VAT Branch Code"; Rec."YVS VAT Branch Code")
            {
                ApplicationArea = all;
                Caption = 'VAT Branch Code';
                ToolTip = 'Specifies the value of the VAT Branch Code field.';
                Visible = CheckDisableLCL;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
                Visible = CheckDisableLCL;
            }
        }
    }
    actions
    {
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
                ToolTip = 'Executes the AP CN Voucher action.';
                Visible = CheckDisableLCL;
                trigger OnAction()
                var
                    APCNVoucher: Report "YVS AP CN Voucher";
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset();
                    PurchaseHeader.Copy(Rec);
                    APCNVoucher."SetGLEntry"(PurchaseHeader);
                    APCNVoucher.RunModal();
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