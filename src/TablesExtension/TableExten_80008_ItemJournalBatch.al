/// <summary>
/// TableExtension YVS ExtenItem Journal Batch (ID 80008) extends Record Item Journal Batch.
/// </summary>
tableextension 80008 "YVS ExtenItem Journal Batch" extends "Item Journal Batch"
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