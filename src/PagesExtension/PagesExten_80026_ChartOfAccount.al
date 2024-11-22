/// <summary>
/// PageExtension ChartOfAccount (ID 80026) extends Record Chart of Accounts.
/// </summary>
pageextension 80026 "YVS ChartOfAccount" extends "Chart of Accounts"
{
    layout
    {
        addafter(Name)
        {
            field("Search Name"; rec."Search Name")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.';
                Visible = CheckDisableLCL;
            }
        }

        // moveafter(Name; "Direct Posting")
        addafter("Direct Posting")
        {
            field(Blocked; rec.Blocked)
            {
                ApplicationArea = all;
                ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.';
                Visible = CheckDisableLCL;
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