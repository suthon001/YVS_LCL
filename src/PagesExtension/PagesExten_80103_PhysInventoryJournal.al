/// <summary>
/// PageExtension YVS Phys. Inventory Journal (ID 80103) extends Record Phys. Inventory Journal.
/// </summary>
pageextension 80103 "YVS Phys. Inventory Journal" extends "Phys. Inventory Journal"
{
    actions
    {
        addafter(Print)
        {
            action(YVSPhysInventoryList)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    ItemJournalBatch: Record "Item Journal Batch";
                begin
                    ItemJournalBatch.SetRange("Journal Template Name", Rec."Journal Template Name");
                    ItemJournalBatch.SetRange(Name, Rec."Journal Batch Name");
                    REPORT.RunModal(REPORT::"YVS Phys. Inventory List", true, false, ItemJournalBatch);
                end;
            }
        }
        addafter(Print_Promoted)
        {
            actionref(YVSPhysInventoryList_Promoted; YVSPhysInventoryList)
            {
            }
        }
        modify(Print)
        {
            Visible = false;
        }
    }
}
