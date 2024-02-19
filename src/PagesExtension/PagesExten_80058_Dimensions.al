/// <summary>
/// PageExtension YVS Dimensions (ID 80058) extends Record Dimensions.
/// </summary>
pageextension 80058 "YVS Dimensions" extends Dimensions
{
    layout
    {
        addafter(Description)
        {
            field("Thai Description"; rec."Thai Description")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Thai Description field.';
            }
        }
    }
}
