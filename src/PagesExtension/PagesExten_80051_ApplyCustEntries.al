/// <summary>
/// PageExtension YVS ApplyCustEntries (ID 80051) extends Record Apply Customer Entries.
/// </summary>
pageextension 80051 "YVS ApplyCustEntries" extends "Apply Customer Entries"
{
    layout
    {
        modify("External Document No.")
        {
            Visible = CheckDisableLCL;
        }
        //  moveafter("Document No."; "External Document No.")

    }
    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";
}