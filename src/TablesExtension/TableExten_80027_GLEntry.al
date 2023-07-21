/// <summary>
/// TableExtension YVS GLEntry (ID 80027) extends Record G/L Entry.
/// </summary>
tableextension 80027 "YVS GLEntry" extends "G/L Entry"
{
    fields
    {
        field(80000; "YVS Journal Description"; text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Journal Description';
        }
        field(80001; "YVS Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = SystemMetadata;
        }
    }
}