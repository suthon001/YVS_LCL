/// <summary>
/// PageExtension YVS Depreciation Book Card (ID 80097) extends Record Depreciation Book Card.
/// </summary>
pageextension 80097 "YVS Depreciation Book Card" extends "Depreciation Book Card"
{
    layout
    {
        addafter("Fiscal Year 365 Days")
        {
            field("YVS Fiscal Year 366 Days"; Rec."YVS Fiscal Year 366 Days")
            {
                Caption = 'Fiscal Year 366 Days';
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Fiscal Year 366 Days field.';
                Visible = CheckDisableLCL;
            }
            field("YVS No. of Days in Fiscal Year"; Rec."No. of Days in Fiscal Year")
            {
                ApplicationArea = all;
                Caption = 'No. of Days in Fiscal Year';
                ToolTip = 'Specifies the value of the No. of Days in Fiscal Year field.';
                Visible = CheckDisableLCL;
            }
        }
    }
    actions
    {
        addfirst(processing)
        {
            action(ClearNoOfYear)
            {
                ApplicationArea = all;
                Caption = 'Clear No. Of Days in Fisical year';
                Image = ClearLog;
                ToolTip = 'Executes the Clear No. Of Days in Fisical year action.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = CheckDisableLCL;
                trigger OnAction()
                begin
                    rec."No. of Days in Fiscal Year" := 0;
                    rec.Modify();
                end;
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
