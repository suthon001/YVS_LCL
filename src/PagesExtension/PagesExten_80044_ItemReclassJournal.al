/// <summary>
/// PageExtension YVS Item Reclass. Journal (ID 80044) extends Record Item Reclass. Journal.
/// </summary>
pageextension 80044 "YVS Item Reclass. Journal" extends "Item Reclass. Journal"
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
