/// <summary>
/// PageExtension YVS Purchase Return Order Sub. (ID 80104) extends Record Purchase Return Order Subform.
/// </summary>
pageextension 80104 "YVS Purchase Return Order Sub." extends "Purchase Return Order Subform"
{
    layout
    {
        modify("Bin Code")
        {
            Visible = CheckDisableLCL;
        }
        // moveafter("Location Code"; "Bin Code")
    }
    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";
}
