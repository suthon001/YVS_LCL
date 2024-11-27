/// <summary>
/// PageExtension YVS GenjournalTemplate (ID 80084) extends Record General Journal Templates.
/// </summary>
pageextension 80084 "YVS GenjournalTemplate" extends "General Journal Templates"
{
    layout
    {
        addafter(Description)
        {
            field("YVS Description Thai"; rec."YVS Description Thai")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Description Thai field.';
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