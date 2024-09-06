/// <summary>
/// Page YVS WHT Posting Setup Wizard (ID 80054).
/// </summary>
page 80054 "YVS WHT Posting Setup Wizard"
{
    ApplicationArea = All;
    Caption = 'WHT Posting Setup Wizard';
    PageType = ListPart;
    SourceTable = "YVS WHT Posting Setup";
    UsageCategory = None;
    SourceTableTemporary = true;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("WHT Bus. Posting Group"; Rec."WHT Bus. Posting Group")
                {
                    ToolTip = 'Specifies the value of the WHT Bus. Posting Group field.';
                }
                field("WHT Prod. Posting Group"; Rec."WHT Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the WHT Prod. Posting Group field.';
                }
                field("WHT %"; Rec."WHT %")
                {
                    ToolTip = 'Specifies the value of the WHT % field.';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        LCLWizardSetup: Codeunit "YVS LCL Wizard Setup";
    begin
        LCLWizardSetup."YVS LCLCreateWHTPostingSetup"(rec);
    end;

    /// <summary>
    /// InserttoRecord.
    /// </summary>
    procedure InserttoRecord()
    var
        WHTProdPostingSetup: Record "YVS WHT Posting Setup";
    begin
        Rec.reset();
        if Rec.FindSet() then
            repeat
                if not WHTProdPostingSetup.GET(rec."WHT Bus. Posting Group", rec."WHT Prod. Posting Group") then begin
                    WHTProdPostingSetup.Init();
                    WHTProdPostingSetup.TransferFields(rec);
                    WHTProdPostingSetup.Insert();
                end else begin
                    WHTProdPostingSetup.TransferFields(rec, false);
                    WHTProdPostingSetup.Modify();
                end;
            until rec.Next() = 0;
    end;
}
