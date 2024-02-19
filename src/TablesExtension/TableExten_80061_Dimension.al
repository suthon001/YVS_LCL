/// <summary>
/// TableExtension YVS Dimension (ID 80061) extends Record Dimension.
/// </summary>
tableextension 80061 "YVS Dimension" extends Dimension
{
    fields
    {
        field(80000; "Thai Description"; Text[100])
        {
            Caption = 'Thai Description';
            DataClassification = CustomerContent;
        }
    }
}
