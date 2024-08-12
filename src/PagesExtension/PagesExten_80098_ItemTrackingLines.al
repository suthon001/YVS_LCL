/// 
/// <summary>
/// PageExtension YVS Item Tracking Summary (ID 80098) extends Record Item Tracking Lines.
/// </summary>
pageextension 80098 "YVS Item Tracking Lines" extends "Item Tracking Lines"
{
    layout
    {
        modify("Expiration Date")
        {
            Visible = true;
            Editable = true;
        }
    }
}
