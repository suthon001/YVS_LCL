/// <summary>
/// PageExtension YVS BankAccountLists (ID 80088) extends Record Bank Account List.
/// </summary>
pageextension 80088 "YVS BankAccountLists" extends "Bank Account List"
{
    layout
    {
        addafter("Bank Account No.")
        {
            field("YVS Bank Branch No."; rec."Bank Branch No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies a number of the bank branch.';
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