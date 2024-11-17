/// <summary>
/// PageExtension ItemLedgerEntry (ID 80053) extends Record Item Ledger Entries.
/// </summary>
pageextension 80053 "YVS ItemLedgerEntry" extends "Item Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Vendor/Customer Name"; Rec."YVS Vendor/Customer Name")
            {
                ApplicationArea = all;
                Editable = false;
                ToolTip = 'Specifies the value of the Vendor/Customer Name field.';
                Visible = CheckDisableLCL;
            }
            field("External Document No."; rec."External Document No.")
            {
                ApplicationArea = all;
                Editable = false;
                ToolTip = 'Specifies the value of the External Document No. field.';
                Visible = CheckDisableLCL;

            }
            field("YVS Document Invoice No."; rec."YVS Document Invoice No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Invoice No. field.';
                Visible = CheckDisableLCL;
            }
        }
        modify("Cost Amount (Expected)")
        {
            Visible = CheckDisableLCL;
        }
        modify("Sales Amount (Expected)")
        {
            Visible = CheckDisableLCL;
        }
        moveafter("Sales Amount (Actual)"; "Sales Amount (Expected)")
        moveafter("Cost Amount (Actual)"; "Cost Amount (Expected)")
        modify("Lot No.") { Visible = CheckDisableLCL; }
        modify("Serial No.") { Visible = CheckDisableLCL; }
        moveafter("Lot No."; "Serial No.")

    }
    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";
}