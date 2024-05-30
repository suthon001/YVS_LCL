/// <summary>
/// PageExtension UserSetup (ID 80021) extends Record User Setup.
/// </summary>
pageextension 80021 "YVS UserSetup" extends "User Setup"
{
    layout
    {
        addfirst(factboxes)
        {
            part(Signature; "YVS Signature")
            {
                Visible = CheckDisableLCL;
                ApplicationArea = all;
                SubPageLink = "User ID" = field("User ID");
                Caption = 'Signature';
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