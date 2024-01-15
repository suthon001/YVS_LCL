/// <summary>
/// PageExtension YVS Item Card (ID 80056) extends Record Item Card.
/// </summary>
pageextension 80056 "YVS Item Card" extends "Item Card"
{
    layout
    {
        addafter("Base Unit of Measure")
        {
            field("YVS WHT Product Posting Group"; rec."YVS WHT Product Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the WHT Product Posting Group field.';
            }
        }
    }
}
