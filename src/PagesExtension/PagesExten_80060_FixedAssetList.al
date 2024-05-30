/// <summary>
/// PageExtension YVS FixedAssetList (ID 80060) extends Record Fixed Asset List.
/// </summary>
pageextension 80060 "YVS FixedAssetList" extends "Fixed Asset List"
{

    actions
    {
        modify("FA Book Value")
        {
            Promoted = true;
            PromotedCategory = Report;
        }
        modify(Register)
        {
            Promoted = true;
            PromotedCategory = Report;
        }
        modify("G/L Analysis")
        {
            Promoted = true;
            PromotedCategory = Report;
        }
        addafter("Projected Value")
        {

            action("Fixed Asset - Book Value 01")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset - Book Value 01';
                Promoted = true;
                PromotedCategory = Report;
                Image = PrintReport;
                RunObject = Report "Fixed Asset - Book Value 01";
                ToolTip = 'Executes the Fixed Asset - Book Value 01 action.';
                Visible = CheckDisableLCL;
            }
            action("Fixed Asset - Book Value 02")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset - Book Value 02';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                RunObject = Report "Fixed Asset - Book Value 02";
                ToolTip = 'Executes the Fixed Asset - Book Value 02 action.';
                Visible = CheckDisableLCL;
            }
            action("Fixed Asset Document Nos.")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset Document Nos.';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                RunObject = Report "Fixed Asset Document Nos.";
                ToolTip = 'Executes the Fixed Asset Document Nos. action.';
                Visible = CheckDisableLCL;
            }
            action("FA Posting Group - Net Change")
            {
                ApplicationArea = All;
                Caption = 'FA Posting Group - Net Change';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintReport;
                RunObject = Report "FA Posting Group - Net Change";
                ToolTip = 'Executes the FA Posting Group - Net Change action.';
                Visible = CheckDisableLCL;
            }
            action("Fixed Asset Journal - Test")
            {
                ApplicationArea = All;
                Caption = 'Fixed Asset Journal - Test';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Visible = CheckDisableLCL;
                Image = PrintReport;
                RunObject = Report "Fixed Asset Journal - Test";
                ToolTip = 'Executes the Fixed Asset Journal - Test action.';
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