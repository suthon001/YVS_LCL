/// <summary>
/// PageExtension BankAccountPostingGroup (ID 80022) extends Record Bank Account Posting Groups.
/// </summary>
pageextension 80022 "YVS BankAccountPostingGroup" extends "Bank Account Posting Groups"
{
    layout
    {
        addafter(Code)
        {
            field("Description"; Rec."YVS Description")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Description field.';
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