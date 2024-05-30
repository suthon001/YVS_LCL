/// <summary>
/// PageExtension Product Posting Groups (ID 80082) extends Record VAT Product Posting Groups.
/// </summary>
pageextension 80082 "YVS Product Posting Groups" extends "VAT Product Posting Groups"
{
    layout
    {
        addafter(Description)
        {
            field("Direct VAT"; Rec."YVS Direct VAT")
            {
                ApplicationArea = all;
                Caption = 'Direct VAT';
                ToolTip = 'Specifies the value of the Direct VAT field.';
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