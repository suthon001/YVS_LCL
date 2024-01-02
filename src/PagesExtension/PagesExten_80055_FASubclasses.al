/// <summary>
/// PageExtension YVS FA Subclasses (ID 80055) extends Record FA Subclasses.
/// </summary>
pageextension 80055 "YVS FA Subclasses" extends "FA Subclasses"
{
    layout
    {
        addafter("Default FA Posting Group")
        {
            field("YVS No. of Depreciation Years"; Rec."YVS No. of Depreciation Years")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the No. of Depreciation Years field.';
            }
        }
    }
}
