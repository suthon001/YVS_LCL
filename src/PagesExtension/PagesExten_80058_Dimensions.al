/// <summary>
/// PageExtension YVS Dimensions (ID 80058) extends Record Dimensions.
/// </summary>
pageextension 80058 "YVS Dimensions" extends Dimensions
{
    layout
    {
        addafter(Description)
        {
            field("YVS Thai Description"; rec."Thai Description")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Thai Description field.';
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
