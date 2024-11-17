/// <summary>
/// PageExtension BankAccountCard (ID 80090) extends Record Bank Account Card.
/// </summary>
pageextension 80090 "YVS BankAccountCard" extends "Bank Account Card"
{
    layout
    {
        modify("Bank Branch No.")
        {
            Visible = CheckDisableLCL;
        }
        movebefore("Bank Account No."; "Bank Branch No.")
    }
    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";
}