/// <summary>
/// PageExtension GenjournalBatch (ID 80085) extends Record General Journal Batches.
/// </summary>
pageextension 80085 "YVS GenjournalBatch" extends "General Journal Batches"
{
    layout
    {
        addafter("No. Series")
        {
            field("Document No. Series"; rec."YVS Document No. Series")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Document No. Series field.';
                Visible = CheckDisableLCL;
            }
        }
        modify("No. Series")
        {
            Visible = not CheckDisableLCL;
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