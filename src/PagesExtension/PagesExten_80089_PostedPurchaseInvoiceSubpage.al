/// <summary>
/// PageExtension YVS Posted Purch. Invoice Sub (ID 80089) extends Record Posted Purch. Invoice Subform.
/// </summary>
pageextension 80089 "YVS Posted Purch. Invoice Sub" extends "Posted Purch. Invoice Subform"
{
    layout
    {



        addafter("Description 2")
        {
            field("YVS Location Code"; rec."Location Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
        }

        //  moveafter("Location Code"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group")
        addafter("VAT Prod. Posting Group")
        {
            field("YVS WHT Business Posting Group"; Rec."YVS WHT Business Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
            field("YVS WHT Product Posting Group"; rec."YVS WHT Product Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
        }
        addlast(Control1)
        {
            field("YVS Tax Invoice Date"; Rec."YVS Tax Invoice Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
            field("YVS Tax Invoice No."; Rec."YVS Tax Invoice No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("YVS Tax Vendor No."; Rec."YVS Tax Vendor No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
            field("YVS Tax Invoice Name"; Rec."YVS Tax Invoice Name")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
            field("YVS Tax Invoice Base"; Rec."YVS Tax Invoice Base")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }

            field("YVS Head Office"; Rec."YVS Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
            field("YVS VAT Branch Code"; Rec."YVS VAT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
            field("YVS Vat Registration No."; Rec."YVS Vat Registration No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
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