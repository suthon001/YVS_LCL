/// <summary>
/// PageExtension ExtenCustomer Card (ID 80000) extends Record Customer Card.
/// </summary>
pageextension 80000 "YVS ExtenCustomer Card" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {

            field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
            }
            field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
            }
            field("YVS WHT Business Posting Group"; rec."YVS WHT Business Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the WHT Business Posting Group field.';
                ShowMandatory = true;
                Visible = CheckDisableLCL;
            }
            field("Head Office"; rec."YVS Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Head Office field.';
                Visible = CheckDisableLCL;
            }
            field("VAT Branch Code"; rec."YVS VAT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the VAT Branch Code field.';
                Visible = CheckDisableLCL;
            }
        }
        moveafter("VAT Branch Code"; "VAT Registration No.")
        modify("No.")
        {
            Visible = true;
            Importance = Promoted;
        }
        modify(Control10)
        {
            Visible = NOT CheckDisableLCL;
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