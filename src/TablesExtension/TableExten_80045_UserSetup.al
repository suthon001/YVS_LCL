/// <summary>
/// TableExtension YVS UserSetup (ID 80045) extends Record User Setup.
/// </summary>
tableextension 80045 "YVS UserSetup" extends "User Setup"
{
    fields
    {
        field(80000; "YVS Signature"; MediaSet)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
        }
    }
}