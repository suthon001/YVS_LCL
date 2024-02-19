/// <summary>
/// PageExtension YVS Purch. Receipt Lines (ID 80059) extends Record Purch. Receipt Lines.
/// </summary>
pageextension 80059 "YVS Purch. Receipt Lines" extends "Purch. Receipt Lines"
{
    layout
    {
        modify("Order No.") { Visible = true; }
        moveafter("Document No."; "Order No.")
    }
}
