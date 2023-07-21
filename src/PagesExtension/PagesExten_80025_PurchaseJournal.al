/// <summary>
/// PageExtension PurchaseJournal (ID 80025) extends Record Purchase Journal.
/// </summary>
pageextension 80025 "YVS PurchaseJournal" extends "Purchase Journal"
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
        addafter(Description)
        {
            field("Journal Description"; Rec."YVS Journal Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Journal Description field.';
            }
        }
    }
}