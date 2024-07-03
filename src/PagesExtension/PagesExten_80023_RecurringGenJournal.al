/// <summary>
/// PageExtension ReCurringGenJournal (ID 80023) extends Record Recurring General Journal.
/// </summary>
pageextension 80023 "YVS ReCurringGenJournal" extends "Recurring General Journal"
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
    actions
    {
        addafter(Preview)
        {
            action(YVSPreview)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Preview Posting';
                Image = ViewPostedOrder;
                ShortCutKey = 'Ctrl+Alt+F9';
                ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';
                Visible = CheckDisableLCL;
                trigger OnAction()
                var
                    GenJnlPost: Codeunit "Gen. Jnl.-Post";
                    ltGenLine: Record "Gen. Journal Line";
                begin
                    ltGenLine.reset();
                    ltGenLine.SetRange("Journal Template Name", rec."Journal Template Name");
                    ltGenLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    ltGenLine.SetRange("Document No.", rec."Document No.");
                    if ltGenLine.FindFirst() then
                        GenJnlPost.Preview(ltGenLine);
                end;
            }
        }
        modify(Preview)
        {
            Visible = not CheckDisableLCL;
        }
        addafter(Preview_Promoted)
        {
            actionref(YVSPreview_Promoted; YVSPreview) { }
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