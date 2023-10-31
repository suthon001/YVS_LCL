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
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        moveafter("Unit of Measure Code"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group")
        modify("Lot No.")
        {
            Visible = true;
        }

    }

}
