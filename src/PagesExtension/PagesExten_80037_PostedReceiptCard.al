/// <summary>
/// PageExtension YVS PostedReceiptCard (ID 80037) extends Record Posted Purchase Receipt.
/// </summary>
pageextension 80037 "YVS PostedReceiptCard" extends "Posted Purchase Receipt"
{

    layout
    {
        // modify("Order Address Code")
        // {
        //     Visible = false;
        // }
        // modify("No. Printed")
        // {
        //     Visible = false;
        // }
        // modify("Promised Receipt Date")
        // {
        //     Visible = false;
        // }
        addafter("Vendor Order No.")
        {
            field("YVS Vendor Invoice No."; rec."YVS Vendor Invoice No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Vendor Invoice No. field.';
                Visible = CheckDisableLCL;
            }
        }

    }
    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";
}