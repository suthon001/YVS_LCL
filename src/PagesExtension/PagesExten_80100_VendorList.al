/// <summary>
/// PageExtension YVS Vendor List (ID 80100) extends Record Vendor List.
/// </summary>
pageextension 80100 "YVS Vendor List" extends "Vendor List"
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

