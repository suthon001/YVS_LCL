/// <summary>
/// PageExtension GLAccountLists (ID 80091) extends Record G/L Account List.
/// </summary>
pageextension 80091 "YVS GLAccountLists" extends "G/L Account List"
{
    layout
    {
        addafter(Name)
        {
            field("YVS Search Name"; rec."Search Name")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.';
                Visible = CheckDisableLCL;
            }
        }
    }
    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        FuncenterYVS: Codeunit "YVS Function Center";
        CheckDisableLCL: Boolean;
}