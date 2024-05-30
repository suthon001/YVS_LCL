/// <summary>
/// PageExtension Purchase Quotes Lists (ID 80011) extends Record Purchase Quotes.
/// </summary>
pageextension 80011 "YVS Purchase Quotes Lists" extends "Purchase Quotes"
{

    layout
    {
        addlast(Control1)
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
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
                Visible = CheckDisableLCL;
            }
            field("Purchase Order No."; rec."YVS Purchase Order No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Purchase Order No. field.';
                Visible = CheckDisableLCL;
            }
        }
        addafter("Buy-from Vendor Name")
        {
            field("Expected Receipt Date"; rec."Expected Receipt Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';

            }
        }
        modify(Status)
        {
            Visible = NOT CheckDisableLCL;
        }
        moveafter("No."; Status)
        addafter(Status)
        {
            field("Completely Received"; rec."Completely Received")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Caption = 'Completely';
            }
        }
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