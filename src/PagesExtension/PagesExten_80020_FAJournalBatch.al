/// <summary>
/// PageExtension YVS JounralBatch (ID 80020) extends Record FA Journal Batches.
/// </summary>
pageextension 80020 "YVS JounralBatch" extends "FA Journal Batches"
{
    layout
    {
        addafter("No. Series")
        {
            field("Document No. Series"; Rec."YVS Document No. Series")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Document No. Series field.';
            }
        }
        modify("No. Series")
        {
            Visible = false;
        }

    }
}