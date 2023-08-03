/// <summary>
/// Table YVS Caption Report Setup (ID 80013).
/// </summary>
table 80013 "YVS Caption Report Setup"
{
    Caption = 'Caption Report Setup';
    LookupPageId = "YVS Caption Report List";
    DrillDownPageId = "YVS Caption Report List";
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "Name (Thai)"; Text[50])
        {
            Caption = 'Name (Thai)';
            DataClassification = CustomerContent;
        }
        field(3; "Name (Eng)"; Text[50])
        {
            Caption = 'Name (Eng)';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

    }
    fieldgroups
    {
        fieldgroup(DropDown; "Name (Thai)", "Name (Eng)") { }
    }
}
