/// <summary>
/// PageExtension YVS VatEntry (ID 80014) extends Record VAT Entries.
/// </summary>
pageextension 80014 "YVS VatEntry" extends "VAT Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("External Document No."; rec."External Document No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the External Document No. field.';
            }
            field("Tax Invoice Base"; Rec."YVS Tax Invoice Base")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Base';
                ToolTip = 'Specifies the value of the Tax Invoice Base field.';
            }
            field("Tax Invoice Amount"; Rec."YVS Tax Invoice Amount")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Amount';
                ToolTip = 'Specifies the value of the Tax Invoice Amount field.';
            }
            field("Tax Invoice Date"; Rec."YVS Tax Invoice Date")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Date';
                ToolTip = 'Specifies the value of the Tax Invoice Date field.';
            }
            field("Tax Invoice No."; Rec."YVS Tax Invoice No.")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice No.';
                ToolTip = 'Specifies the value of the Tax Invoice No. field.';
            }
            field("Tax Vendor No."; Rec."YVS Tax Vendor No.")
            {
                ApplicationArea = all;
                Caption = 'Tax Vendor No.';
                ToolTip = 'Specifies the value of the Tax Vendor No. field.';
            }
            field("Tax Invoice Name"; Rec."YVS Tax Invoice Name")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Name';
                ToolTip = 'Specifies the value of the Tax Invoice Name field.';
            }
            field("Tax Invoice Address"; Rec."YVS Tax Invoice Address")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Address';
                ToolTip = 'Specifies the value of the Tax Invoice Address field.';
            }
            field("Tax Invoice City"; Rec."YVS Tax Invoice City")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice City';
                ToolTip = 'Specifies the value of the Tax Invoice City field.';
            }
            field("Tax Invoice Post Code"; Rec."YVS Tax Invoice Post Code")
            {
                ApplicationArea = all;
                Caption = 'Tax Invoice Post Code';
                ToolTip = 'Specifies the value of the Tax Invoice Post Code field.';
            }
            field("Head Office"; Rec."YVS Head Office")
            {
                ApplicationArea = all;
                Caption = 'Head Office';
                ToolTip = 'Specifies the value of the Head Office field.';
            }
            field("VAT Branch Code"; Rec."YVS VAT Branch Code")
            {
                ApplicationArea = all;
                Caption = 'VAT Branch Code';
                ToolTip = 'Specifies the value of the VAT Branch Code field.';
            }

        }
        modify("VAT Registration No.")
        {
            Visible = true;
        }
        moveafter("VAT Branch Code"; "VAT Registration No.")
    }
}