/// <summary>
/// PageExtension YVS Item Reclass. Journal (ID 80044) extends Record Item Reclass. Journal.
/// </summary>
pageextension 80044 "YVS Item Reclass. Journal" extends "Item Reclass. Journal"
{
    layout
    {
        modify("Document No.")
        {
            Visible = NOT CheckDisableLCL;
        }
        addafter("Document No.")
        {
            field("YVS Document No."; rec."Document No.")
            {
                ApplicationArea = all;
                Visible = CheckDisableLCL;
                ToolTip = 'Specifies the value of the Document No. field.';
                trigger OnAssistEdit()
                begin
                    if Rec."AssistEdit"(xRec) then
                        CurrPage.Update();
                end;
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
