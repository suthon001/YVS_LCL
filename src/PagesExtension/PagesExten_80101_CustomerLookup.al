/// <summary>
/// PageExtension YVS Customer Lookup (ID 80101) extends Record Customer Lookup.
/// </summary>
pageextension 80101 "YVS Customer Lookup" extends "Customer Lookup"
{
    layout
    {
        addafter("No.")
        {
            field("YVS No. 2"; rec."YVS No. 2")
            {
                ApplicationArea = all;
                Visible = CheckDisableLCL;
                ToolTip = 'Specifies the value of the No. 2 field.';
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

