/// <summary>
/// TableExtension YVS ExtenGen.Journal Batch (ID 80006) extends Record Gen. Journal Batch.
/// </summary>
tableextension 80006 "YVS ExtenGen.Journal Batch" extends "Gen. Journal Batch"
{
    fields
    {
        field(80000; "YVS Document No. Series"; Code[20])
        {
            Caption = 'Document No. Series';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;

        }
    }
}