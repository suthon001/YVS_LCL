/// <summary>
/// PageExtension YVS Purchase Credit Memo Card (ID 80075) extends Record Purchase Credit Memo.
/// </summary>
pageextension 80075 "YVS Purchase Credit Memo Card" extends "Purchase Credit Memo"
{

    layout
    {
        addbefore(Status)
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
            field("Return Shipment No. Series"; Rec."Return Shipment No. Series")
            {
                ApplicationArea = all;
                Caption = 'Return Shipment No. Series';
                ToolTip = 'Specifies the value of the Return Shipment No. Series field.';
                Visible = CheckDisableLCL;
            }
        }
        modify("No.")
        {
            Visible = CheckDisableLCL;
        }
        modify("Buy-from Vendor No.")
        {
            Visible = CheckDisableLCL;
            Importance = Promoted;
        }
        modify("Vendor Authorization No.")
        {
            Visible = not CheckDisableLCL;
        }
        modify("Campaign No.")
        {
            Visible = not CheckDisableLCL;
        }
        modify("Expected Receipt Date")
        {
            Visible = not CheckDisableLCL;
        }
        //   moveafter("Vendor Cr. Memo No."; "Purchaser Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        //   movebefore("Vendor Cr. Memo No."; "Posting Description")

    }
    actions
    {
        addlast(Reporting)
        {
            action("APCNVoucher")
            {
                Caption = 'AP CN Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                Visible = CheckDisableLCL;
                ToolTip = 'Executes the AP CN Voucher action.';
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