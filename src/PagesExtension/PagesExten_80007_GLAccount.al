/// <summary>
/// PageExtension YVS ExtenGLAccount (ID 80007) extends Record G/L Account Card.
/// </summary>
pageextension 80007 "YVS ExtenGLAccount" extends "G/L Account Card"
{
    layout
    {
        addlast(General)
        {
            field("Require Screen Detail"; Rec."Require Screen Detail")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Require Screen Detail field.';
                Visible = CheckDisableLCL;
            }

        }
        modify("Direct Posting")
        {
            Visible = CheckDisableLCL;
        }
        //  moveafter(Name; "Direct Posting")


    }
    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";
}