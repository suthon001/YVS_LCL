/// <summary>
/// PageExtension YVS Vat Bus Posting Groups (ID 80083) extends Record VAT Business Posting Groups.
/// </summary>
pageextension 80083 "YVS Vat Bus Posting Groups" extends "VAT Business Posting Groups"
{

    layout
    {
        addafter(Description)
        {
            field("Company Name"; Rec."YVS Company Name (Thai)")
            {
                ApplicationArea = all;
                Caption = 'Company Name (Thai)';
                ToolTip = 'Specifies the value of the Company Name (Thai) field.';
                Visible = CheckDisableLCL;
            }
            field("Company Name 2"; Rec."YVS Company Name 2 (Thai)")
            {
                ApplicationArea = all;
                Caption = 'Company Name 2 (Thai)';
                ToolTip = 'Specifies the value of the Company Name 2 (Thai) field.';
                Visible = CheckDisableLCL;
            }
            field("Company Address"; Rec."YVS Company Address (Thai)")
            {
                ApplicationArea = all;
                Caption = 'Company Address (Thai)';
                ToolTip = 'Specifies the value of the Company Address (Thai) field.';
                Visible = CheckDisableLCL;
            }
            field("Company Address 2"; Rec."YVS Company Address 2 (Thai)")
            {
                ApplicationArea = all;
                Caption = 'Company Address 2 (Thai)';
                ToolTip = 'Specifies the value of the Company Address 2 (Thai) field.';
                Visible = CheckDisableLCL;
            }
            field("City (Thai)"; Rec."YVS City (Thai)")
            {
                ApplicationArea = all;
                Caption = 'City (Thai)';
                ToolTip = 'Specifies the value of the City (Thai) field.';
                Visible = CheckDisableLCL;
            }
            field("Company Name (Eng)"; Rec."YVS Company Name (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Company Name (Eng)';
                ToolTip = 'Specifies the value of the Company Name (Eng) field.';
                Visible = CheckDisableLCL;
            }
            field("Company Name 2 (Eng)"; Rec."YVS Company Name 2 (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Company Name 2 (Eng)';
                ToolTip = 'Specifies the value of the Company Name 2 (Eng) field.';
                Visible = CheckDisableLCL;
            }
            field("Company Address (Eng)"; Rec."YVS Company Address (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Company Address (Eng)';
                ToolTip = 'Specifies the value of the Company Address (Eng) field.';
                Visible = CheckDisableLCL;
            }
            field("Company Address 2 (Eng)"; Rec."YVS Company Address 2 (Eng)")
            {
                ApplicationArea = all;
                Caption = 'Company Address 2 (Eng)';
                ToolTip = 'Specifies the value of the Company Address 2 (Eng) field.';
                Visible = CheckDisableLCL;
            }
            field("City (Eng)"; Rec."YVS City (Eng)")
            {
                ApplicationArea = all;
                Caption = 'City (Eng)';
                ToolTip = 'Specifies the value of the City (Eng) field.';
                Visible = CheckDisableLCL;
            }
            field("Post code"; Rec."YVS Post code")
            {
                ApplicationArea = all;
                Caption = 'Post code';
                ToolTip = 'Specifies the value of the Post code field.';
                Visible = CheckDisableLCL;
            }
            field("Phone No."; Rec."YVS Phone No.")
            {
                ApplicationArea = all;
                Caption = 'Phone No.';
                ToolTip = 'Specifies the value of the Phone No. field.';
                Visible = CheckDisableLCL;
            }
            field("Fax No."; Rec."YVS Fax No.")
            {
                ApplicationArea = all;
                Caption = 'Fax No.';
                ToolTip = 'Specifies the value of the Fax No. field.';
                Visible = CheckDisableLCL;
            }
            field("Email"; Rec."YVS Email")
            {
                ApplicationArea = all;
                Caption = 'E-mail';
                ToolTip = 'Specifies the value of the E-mail field.';
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
            field("VAT Registration No."; Rec."YVS VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
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