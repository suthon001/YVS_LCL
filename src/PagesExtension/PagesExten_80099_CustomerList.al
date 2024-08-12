/// <summary>
/// PageExtension YVS Customer List (ID 80099) extends Record Customer List.
/// </summary>
pageextension 80099 "YVS Customer List" extends "Customer List"
{
    layout
    {
        addafter("No.")
        {
            field("YVS No. 2"; rec."YVS No. 2")
            {
                ApplicationArea = all;
                Visible = CheckDisableLCL;
                ToolTip = 'Specifies the value of the No. 2 field.';
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
