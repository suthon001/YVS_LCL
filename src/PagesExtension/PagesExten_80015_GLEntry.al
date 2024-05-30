/// <summary>
/// PageExtension GLEntry (ID 80015) extends Record General Ledger Entries.
/// </summary>
pageextension 80015 "YVS GLEntry" extends "General Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Journal Description"; Rec."YVS Journal Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }

        }
        modify("External Document No.")
        {
            Visible = NOT CheckDisableLCL;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = NOT CheckDisableLCL;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = NOT CheckDisableLCL;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = NOT CheckDisableLCL;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = NOT CheckDisableLCL;
        }
        moveafter("Journal Description"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group")
    }
    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";
}