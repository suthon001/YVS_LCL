/// <summary>
/// PageExtension YVS FALocation (ID 80061) extends Record FA Locations.
/// </summary>
pageextension 80061 "YVS FALocation" extends "FA Locations"
{
    layout
    {
        addlast(Control1)
        {
            field("YVS Location Detail"; rec."YVS Location Detail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Location Detail field.';
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