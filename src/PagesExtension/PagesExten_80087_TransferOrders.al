/// <summary>
/// PageExtension NUD Transfer Orders (ID 80087) extends Record Transfer Orders.
/// </summary>
pageextension 80087 "NUD Transfer Orders" extends "Transfer Orders"
{
    layout
    {
        addlast(Control1)
        {
            field("Completely Shipped"; rec."Completely Shipped")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Completely Shipped field.';
            }
            field("Completely Received"; rec."Completely Received")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Completely Received field.';
            }
        }
    }
}
