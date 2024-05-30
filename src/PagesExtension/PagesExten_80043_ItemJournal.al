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
            Visible = CheckDisableLCL;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = CheckDisableLCL;
        }
        moveafter("Unit of Measure Code"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group")
        modify("Lot No.")
        {
            Visible = CheckDisableLCL;
        }

    }
    actions
    {
        addafter("&Print")
        {
            action("YVSPrint")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Visible = CheckDisableLCL;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    ItemJnlLine: Record "Item Journal Line";
                begin
                    ItemJnlLine.Copy(Rec);
                    ItemJnlLine.SetRange("Journal Template Name", rec."Journal Template Name");
                    ItemJnlLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    REPORT.RunModal(REPORT::"YVS Inventory Movement", true, true, ItemJnlLine);
                end;
            }
        }
        modify("&Print")
        {
            Visible = not CheckDisableLCL;
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
