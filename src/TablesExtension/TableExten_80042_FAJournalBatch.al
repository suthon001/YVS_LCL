/// <summary>
/// TableExtension YVS FAJournalBatch (ID 80042) extends Record FA Journal Batch.
/// </summary>
tableextension 80042 "YVS FAJournalBatch" extends "FA Journal Batch"
{
    fields
    {
        field(80000; "YVS Document No. Series"; code[20])
        {
            Caption = 'Document No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
}