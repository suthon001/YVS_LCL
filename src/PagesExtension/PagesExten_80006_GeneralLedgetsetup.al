/// <summary>
/// PageExtension ExtenGeneralSetup (ID 80006) extends Record General Ledger Setup.
/// </summary>
pageextension 80006 "YVS ExtenGeneralSetup" extends "General Ledger Setup"
{
    layout
    {
        addafter(General)
        {
            group("WHT Information")
            {
                Caption = 'WHT Information';

                field("No. of Copy WHT Cert."; Rec."YVS No. of Copy WHT Cert.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. of Copy WHT Cert. field.';
                }
                field("WHT Pre-Document Nos."; Rec."YVS WHT Document Nos.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Document Nos. field.';
                }
                field("WHT03 Nos."; rec."YVS WHT03 Nos.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT03 Nos. field.';
                }
                field("WHT53 Nos."; rec."YVS WHT53 Nos.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT53 Nos. field.';
                }
                field("WHT Certificate 1"; Rec."YVS WHT Certificate Caption 1")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Certificate Caption 1 field.';
                }
                field("WHT Certificate 2"; Rec."YVS WHT Certificate Caption 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Certificate Caption 2 field.';
                }
                field("WHT Certificate 3"; Rec."YVS WHT Certificate Caption 3")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Certificate Caption 3 field.';
                }
                field("WHT Certificate 4"; Rec."YVS WHT Certificate Caption 4")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Certificate Caption 4 field.';
                }

            }

        }
    }
}