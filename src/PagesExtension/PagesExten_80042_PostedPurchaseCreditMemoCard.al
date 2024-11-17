/// <summary>
/// PageExtension PostedPurchCreditMemoCard (ID 80042) extends Record Posted Purchase Credit Memo.
/// </summary>
pageextension 80042 "YVS PostedPurchCreditMemoCard" extends "Posted Purchase Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
                Caption = 'Gen. Bus. Posting Group';
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
                Visible = CheckDisableLCL;
            }

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
        modify(Cancelled)
        {
            Visible = not CheckDisableLCL;
        }
        modify("No. Printed")
        {
            Visible = not CheckDisableLCL;
        }
        modify(Corrective)
        {
            Visible = not CheckDisableLCL;
        }
        modify("Order Address Code")
        {
            Visible = not CheckDisableLCL;
        }
        addafter("No.")
        {
            field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the name of the vendor who delivered the items.';
                Visible = CheckDisableLCL;
            }
        }
        addafter("Buy-from Contact")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Posting Description field.';
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