/// <summary>
/// PageExtension YVS Detailed Vendor Ledg.Entry (ID 80047) extends Record Detailed Vendor Ledg. Entries.
/// </summary>
pageextension 80047 "YVS Detailed Vendor Ledg.Entry" extends "Detailed Vendor Ledg. Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("YVS Invoice Entry No."; rec."YVS Invoice Entry No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Invoice Entry Entry No. field.';
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
