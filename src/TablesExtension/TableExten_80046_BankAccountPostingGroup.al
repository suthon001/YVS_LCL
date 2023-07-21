/// <summary>
/// TableExtension YVS BankAccPostingGroup (ID 80046) extends Record Bank Account Posting Group.
/// </summary>
tableextension 80046 "YVS BankAccPostingGroup" extends "Bank Account Posting Group"
{
    fields
    {
        field(80000; "YVS Description"; text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
}