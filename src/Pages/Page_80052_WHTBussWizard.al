/// <summary>
/// Page YVS WHT Buss Wizard (ID 80052).
/// </summary>
page 80052 "YVS WHT Buss Wizard"
{
    ApplicationArea = All;
    Caption = 'WHT Buss Wizard';
    PageType = ListPart;
    SourceTable = "YVS WHT Business Posting Group";
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
                field("WHT Type"; Rec."WHT Type")
                {
                    ToolTip = 'Specifies the value of the WHT Type field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("WHT Certificate Option"; Rec."WHT Certificate Option")
                {
                    ToolTip = 'Specifies the value of the WHT Certificate Option field.';
                }
                field("WHT Certificate No. Series"; Rec."WHT Certificate No. Series")
                {
                    ToolTip = 'Specifies the value of the WHT Certificate No. Series field.';
                }
                field("WHT Account No."; Rec."WHT Account No.")
                {
                    ToolTip = 'Specifies the value of the WHT Account No. field.';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Name 2"; Rec."Name 2")
                {
                    ToolTip = 'Specifies the value of the Name 2 field.';
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ToolTip = 'Specifies the value of the Address 2 field.';
                }
                field("Head Office"; Rec."Head Office")
                {
                    ToolTip = 'Specifies the value of the Head Office field.';
                }
                field("VAT Branch Code"; Rec."VAT Branch Code")
                {
                    ToolTip = 'Specifies the value of the VAT Branch Code field.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        LCLWizardSetup: Codeunit "YVS LCL Wizard Setup";
    begin
        LCLWizardSetup."YVS LCLCreateWHTBusPostingGroup"(rec);
    end;

    /// <summary>
    /// InserttoRecord.
    /// </summary>
    procedure InserttoRecord()
    var
        WHTBusinessPostingGroup: Record "YVS WHT Business Posting Group";
    begin
        Rec.reset();
        if Rec.FindSet() then
            repeat
                if rec."WHT Certificate No. Series" <> '' then
                    if rec."WHT Type" = rec."WHT Type"::PND3 then
                        InsertToNoSeries(rec."WHT Certificate No. Series", 'เลขที่เอกสารรับรองหัก ณ ที่จ่าย 03 (WHT03)', 'WHT03' + format(Today(), 0, '<Year,2><Month,2>') + '-00001')
                    else
                        if rec."WHT Type" = rec."WHT Type"::PND53 then
                            InsertToNoSeries(rec."WHT Certificate No. Series", 'เลขที่เอกสารรับรองหัก ณ ที่จ่าย 53 (WHT53)', 'WHT53' + format(Today(), 0, '<Year,2><Month,2>') + '-00001');
                if not WHTBusinessPostingGroup.GET(rec.Code) then begin
                    WHTBusinessPostingGroup.Init();
                    WHTBusinessPostingGroup.TransferFields(rec);
                    WHTBusinessPostingGroup.Insert();
                end else begin
                    WHTBusinessPostingGroup.TransferFields(rec, false);
                    WHTBusinessPostingGroup.Modify();
                end;
            until rec.Next() = 0;
    end;

    local procedure InsertToNoSeries(pCode: code[20]; pDesc: Text[100]; pStartDate: Code[20])
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if not NoSeries.GET(pCode) then begin
            NoSeries.Init();
            NoSeries.Code := pCode;
            NoSeries.Description := pDesc;
            NoSeries."Default Nos." := true;
            NoSeries.Insert();
            if pStartDate <> '' then begin
                NoSeriesLine.Init();
                NoSeriesLine."Series Code" := pCode;
                NoSeriesLine."Line No." := 10000;
                NoSeriesLine."Starting Date" := CalcDate('<-CM>', Today());
                NoSeriesLine.Insert();
                NoSeriesLine.Validate("Starting No.", pStartDate);
                NoSeriesLine."Increment-by No." := 1;
                NoSeriesLine.Open := true;
                NoSeriesLine.Modify();
            end;
        end;
    end;
}
