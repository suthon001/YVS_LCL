/// <summary>
/// PageExtension PostedInvoiceCard (ID 80040) extends Record Posted Purchase Invoice.
/// </summary>
pageextension 80040 "YVS PostedInvoiceCard" extends "Posted Purchase Invoice"
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

        modify(Corrective)
        {
            Visible = false;
        }
        modify(Cancelled)
        {
            Visible = false;
        }
        modify("No. Printed")
        {
            Visible = false;
        }
        modify("Order Address Code")
        {
            Visible = false;
        }
        addafter("No.")
        {
            field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the identifier of the vendor that you bought the items from.';
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
                ToolTip = 'Executes the AP Voucher action.';
                Visible = CheckDisableLCL;
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