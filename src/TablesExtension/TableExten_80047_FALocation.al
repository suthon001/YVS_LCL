/// <summary>
/// TableExtension FALocation (ID 80047) extends Record FA Location.
/// </summary>
tableextension 80047 "YVS FALocation" extends "FA Location"
{
    fields
    {
        field(80000; "YVS Location Detail"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Location Detail';
        }
    }
}