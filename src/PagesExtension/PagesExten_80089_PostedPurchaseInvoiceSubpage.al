/// <summary>
/// PageExtension YVS Posted Purch. Invoice Sub (ID 80089) extends Record Posted Purch. Invoice Subform.
/// </summary>
pageextension 80089 "YVS Posted Purch. Invoice Sub" extends "Posted Purch. Invoice Subform"
{
    layout
    {

        modify("Description 2")
        {
            Visible = true;
        }
        moveafter(Description; "Description 2")

        addafter("Description 2")
        {
            field("Location Code"; rec."Location Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
        moveafter("Location Code"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group")
        addafter("VAT Prod. Posting Group")
        {
            field("WHT Business Posting Group"; Rec."YVS WHT Business Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("WHT Product Posting Group"; rec."YVS WHT Product Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
        }
        addlast(Control1)
        {
            field("Tax Invoice Date"; Rec."YVS Tax Invoice Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("Tax Invoice No."; Rec."YVS Tax Invoice No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("Tax Vendor No."; Rec."YVS Tax Vendor No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("Tax Invoice Name"; Rec."YVS Tax Invoice Name")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("Tax Invoice Base"; Rec."YVS Tax Invoice Base")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }

            field("Head Office"; Rec."YVS Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("VAT Branch Code"; Rec."YVS VAT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("Vat Registration No."; Rec."YVS Vat Registration No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
        }

        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }
    }

}