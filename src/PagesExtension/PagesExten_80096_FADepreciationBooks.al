/// <summary>
/// PageExtension YVS FA Depreciation Books (ID 80096) extends Record FA Depreciation Books.
/// </summary>
pageextension 80096 "YVS FA Depreciation Books" extends "FA Depreciation Books"
{
    layout
    {
        addbefore("No. of Depreciation Years")
        {
            field("YVS No. of Years"; Rec."YVS No. of Years")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the No. of Years field.';
                Visible = CheckDisableLCL;
            }
        }
        modify("No. of Depreciation Years")
        {
            Visible = NOT CheckDisableLCL;
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
