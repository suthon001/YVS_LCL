/// <summary>
/// PageExtension CustLedgEntry (ID 80052) extends Record Customer Ledger Entries.
/// </summary>
pageextension 80052 "YVS CustLedgEntry" extends "Customer Ledger Entries"
{
    layout
    {
        modify("External Document No.")
        {
            Visible = CheckDisableLCL;
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