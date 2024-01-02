/// <summary>
/// TableExtension YVS FA Subclass (ID 80060) extends Record FA Subclass.
/// </summary>
tableextension 80060 "YVS FA Subclass" extends "FA Subclass"
{
    fields
    {
        field(80000; "YVS No. of Depreciation Years"; Integer)
        {
            Caption = 'No. of Depreciation Years';
            DataClassification = CustomerContent;
        }
    }
}
