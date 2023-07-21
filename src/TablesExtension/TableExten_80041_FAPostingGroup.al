/// <summary>
/// TableExtension YVS FAPostingGroup (ID 80041) extends Record FA Posting Group.
/// </summary>
tableextension 80041 "YVS FAPostingGroup" extends "FA Posting Group"
{
    fields
    {
        field(80000; "YVS Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
}