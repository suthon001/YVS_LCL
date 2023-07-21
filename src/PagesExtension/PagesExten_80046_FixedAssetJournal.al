/// <summary>
/// PageExtension YVS FixedJournalLIne (ID 80046) extends Record Fixed Asset Journal.
/// </summary>
pageextension 80046 "YVS FixedJournalLIne" extends "Fixed Asset Journal"
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