/// <summary>
/// TableExtension YVS Requisition Name (ID 80048) extends Record Requisition Wksh. Name.
/// </summary>
tableextension 80048 "YVS Requisition Name" extends "Requisition Wksh. Name"
{
    fields
    {
        field(80000; "YVS Document No. Series"; Code[20])
        {
            Caption = 'Document No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }

    }
}