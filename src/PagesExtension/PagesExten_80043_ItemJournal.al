/// <summary>
/// PageExtension YVS Item Journal (ID 80043) extends Record Item Journal.
/// </summary>
pageextension 80043 "YVS Item Journal" extends "Item Journal"
{
    layout
    {
        modify("Document No.")
        {
            trigger OnAssistEdit()
            begin
                if Rec."AssistEdit"(xRec) then
                    CurrPage.Update();
            end;
        }
    }
}
