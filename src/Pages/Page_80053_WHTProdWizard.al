/// <summary>
/// Page YVS WHT Prod Wizard (ID 80053).
/// </summary>
page 80053 "YVS WHT Prod Wizard"
{
    ApplicationArea = All;
    Caption = 'WHT Prod Wizard';
    PageType = ListPart;
    SourceTable = "YVS WHT Product Posting Group";
    UsageCategory = None;
    SourceTableTemporary = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Sequence; Rec.Sequence)
                {
                    ToolTip = 'Specifies the value of the Sequence field.';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        LCLWizardSetup: Codeunit "YVS LCL Wizard Setup";
    begin
        LCLWizardSetup."YVS LCLCreateWHTProdPostingGroup"(rec);
    end;

    /// <summary>
    /// InserttoRecord.
    /// </summary>
    procedure InserttoRecord()
    var
        WHTProdPostingGroup: Record "YVS WHT Product Posting Group";
    begin
        Rec.reset();
        if Rec.FindSet() then
            repeat
                if not WHTProdPostingGroup.GET(rec.Code) then begin
                    WHTProdPostingGroup.Init();
                    WHTProdPostingGroup.TransferFields(rec);
                    WHTProdPostingGroup.Insert();
                end else begin
                    WHTProdPostingGroup.TransferFields(rec, false);
                    WHTProdPostingGroup.Modify();
                end;
            until rec.Next() = 0;
    end;
}

