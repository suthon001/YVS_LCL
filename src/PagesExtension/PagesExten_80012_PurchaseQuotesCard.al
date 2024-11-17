/// <summary>
/// PageExtension Purchase Quote Card (ID 80012) extends Record Purchase Quote.
/// </summary>
pageextension 80012 "YVS Purchase Quote Card" extends "Purchase Quote"
{
    layout
    {
        addbefore(Status)
        {

            field("Head Office"; Rec."YVS Head Office")
            {
                ApplicationArea = all;
                Visible = CheckDisableLCL;
                ToolTip = 'Specifies the value of the Head Office field.';
            }
            field("VAT Branch Code"; Rec."YVS VAT Branch Code")
            {
                ApplicationArea = all;
                Visible = CheckDisableLCL;
                ToolTip = 'Specifies the value of the VAT Branch Code field.';
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Visible = CheckDisableLCL;
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
            }
            field("Purchase Order No."; rec."YVS Purchase Order No.")
            {
                ApplicationArea = all;
                Visible = CheckDisableLCL;
                ToolTip = 'Specifies the value of the Purchase Order No. field.';
            }
            field("YVS Make PO No. Series"; rec."YVS Make PO No. Series")
            {
                ApplicationArea = all;
                Visible = CheckDisableLCL;
                ToolTip = 'Specifies the value of the YVS Make PO No. Series field.';
            }
            field("Completely Received"; rec."Completely Received")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Caption = 'Completely';
            }
        }
        modify("No.")
        {
            Visible = NOT CheckDisableLCL;
            Importance = Promoted;
        }
        modify("Buy-from Vendor No.")
        {
            Visible = NOT CheckDisableLCL;
            Importance = Standard;
        }
        modify("Expected Receipt Date")
        {
            Visible = NOT CheckDisableLCL;
        }
        modify("Location Code")
        {
            Visible = NOT CheckDisableLCL;
        }
        addbefore("Pay-to Name")
        {
            field("Pay-to Vendor No."; rec."Pay-to Vendor No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the number of the vendor that you received the invoice from.';
                Visible = CheckDisableLCL;
            }
        }
        // moveafter("Purchaser Code"; "Currency Code")
        // moveafter("Currency Code"; "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        // moveafter("YVS Make PO No. Series"; "Expected Receipt Date", "Location Code")

    }
    actions
    {
        modify(Print)
        {
            Visible = NOT CheckDisableLCL;
        }
        addlast(Reporting)
        {
            action("Purchase Quote")
            {
                Caption = 'Purchase Quote';
                Image = PrintReport;
                ApplicationArea = all;
                PromotedCategory = Category6;
                Visible = CheckDisableLCL;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Purchase Quote action.';
                trigger OnAction()
                var

                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset();
                    PurchaseHeader.SetRange("Document Type", rec."Document Type");
                    PurchaseHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"YVS PurchaseQuotes", true, true, PurchaseHeader);
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