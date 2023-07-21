/// <summary>
/// PageExtension YVS Company Information (ID 80081) extends Record Company Information.
/// </summary>
pageextension 80081 "YVS Company Information" extends "Company Information"
{
    layout
    {
        addbefore("VAT Registration No.")
        {
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
        addafter(Name)
        {
            field("Name (Eng)"; Rec."YVS Name (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Name (Eng)';
                ToolTip = 'Specifies the value of the Name (Eng) field.';
            }
            field("Address (Eng)"; Rec."YVS Address (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Address (Eng)';
                ToolTip = 'Specifies the value of the Address (Eng) field.';
            }
            field("Address 2 (Eng)"; Rec."YVS Address 2 (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Address 2 (Eng)';
                ToolTip = 'Specifies the value of the Address 2 (Eng) field.';
            }
        }
    }
}