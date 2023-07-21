/// <summary>
/// TableExtension YVS ReturnReceiptHeader (ID 80051) extends Record Return Receipt Header.
/// </summary>
tableextension 80051 "YVS ReturnReceiptHeader" extends "Return Receipt Header"
{
    fields
    {
        field(80006; "YVS Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80007; "YVS Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }
}