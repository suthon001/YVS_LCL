/// <summary>
/// PageExtension YVS Requisition Name (ID 80048) extends Record Req. Wksh. Names.
/// </summary>
pageextension 80048 "YVS Requisition Name" extends "Req. Wksh. Names"
{
    layout
    {
        addafter(Description)
        {
            field("Document No. Series"; Rec."YVS Document No. Series")
            {
                ApplicationArea = all;
                Caption = 'Document No. Series';
                ToolTip = 'Specifies the value of the Document No. Series field.';
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