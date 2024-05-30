/// <summary>
/// PageExtension ExtenItem Journal Batches (ID 80003) extends Record Item Journal Batches.
/// </summary>
pageextension 80003 "YVS ExtenItem Journal Batches" extends "Item Journal Batches"
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