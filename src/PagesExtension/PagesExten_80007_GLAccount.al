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
            }

        }
        modify("Direct Posting")
        {
            Visible = true;
        }
        moveafter(Name; "Direct Posting")


    }
}