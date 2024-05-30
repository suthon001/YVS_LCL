/// <summary>
/// PageExtension YVS ApplyCustEntries (ID 80051) extends Record Apply Customer Entries.
/// </summary>
pageextension 80051 "YVS ApplyCustEntries" extends "Apply Customer Entries"
{
    layout
    {
        modify("External Document No.")
        {
            Visible = true;
        }
        moveafter("Document No."; "External Document No.")

    }
}