/// <summary>
/// Page YVS General Setup Wizard (ID 80051).
/// </summary>
page 80051 "YVS General Setup Wizard"
{
    ApplicationArea = All;
    Caption = 'General Setup Wizard';
    PageType = CardPart;
    SourceTable = "General Ledger Setup";
    UsageCategory = None;
    SourceTableTemporary = true;
    layout
    {
        area(Content)
        {
            Group(General)
            {
                field("YVS No. of Copy WHT Cert."; Rec."YVS No. of Copy WHT Cert.")
                {
                    ToolTip = 'Specifies the value of the No. of Copy WHT Cert. field.';
                }
                field("YVS WHT Certificate Caption 1"; Rec."YVS WHT Certificate Caption 1")
                {
                    ToolTip = 'Specifies the value of the WHT Certificate Caption 1 field.';
                }
                field("YVS WHT Certificate Caption 2"; Rec."YVS WHT Certificate Caption 2")
                {
                    ToolTip = 'Specifies the value of the WHT Certificate Caption 2 field.';
                }
                field("YVS WHT Certificate Caption 3"; Rec."YVS WHT Certificate Caption 3")
                {
                    ToolTip = 'Specifies the value of the WHT Certificate Caption 3 field.';
                }
                field("YVS WHT Certificate Caption 4"; Rec."YVS WHT Certificate Caption 4")
                {
                    ToolTip = 'Specifies the value of the WHT Certificate Caption 4 field.';
                }
                field("YVS WHT Document Nos."; Rec."YVS WHT Document Nos.")
                {
                    ToolTip = 'Specifies the value of the WHT Document Nos. field.';
                }
                field(PWHTStartDate; PWHTStartDate)
                {
                    Caption = 'Starting No.';
                    ToolTip = 'Specifies the value of the Starting No. field.';
                }
                field(PWHTText; PWHTText)
                {
                    Caption = 'Description';
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("YVS WHT03 Nos."; rec."YVS WHT03 Nos.")
                {
                    ToolTip = 'Specifies the value of the WHT Document Nos. field.';
                }
                field(WHT03StartDate; WHT03StartDate)
                {
                    Caption = 'Starting No.';
                    ToolTip = 'Specifies the value of the Starting No. field.';
                }
                field(WHT03Text; WHT03Text)
                {
                    Caption = 'Description';
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("YVS WHT53 Nos."; rec."YVS WHT53 Nos.")
                {
                    ToolTip = 'Specifies the value of the WHT Document Nos. field.';
                }
                field(WHT53StartDate; WHT53StartDate)
                {
                    Caption = 'Starting No.';
                    ToolTip = 'Specifies the value of the Starting No. field.';
                }
                field(WHT53Text; WHT53Text)
                {
                    Caption = 'Description';
                    ToolTip = 'Specifies the value of the Description field.';
                }

            }
        }
    }
    trigger OnOpenPage()
    var
        LCLWizardSetup: Codeunit "YVS LCL Wizard Setup";
    begin
        LCLWizardSetup."YVS LCLCreateGeneralLedgerSetup"(rec);
        PWHTStartDate := 'PWHT' + format(Today(), 0, '<Year,2><Month,2>') + '-00001';
        PWHTText := 'เลขที่เอกสารในการรันใบภาษีหัก ณ ที่จ่าย';
        WHT03Text := 'เลขที่เอกสารรายงาน WHT03';
        WHT03StartDate := 'WHT03' + format(Today(), 0, '<Year,2><Month,2>') + '-00001';
        WHT53Text := 'เลขที่เอกสารรายงาน WHT53';
        WHT53StartDate := 'WHT53' + format(Today(), 0, '<Year,2><Month,2>') + '-00001';
    end;

    /// <summary>
    /// InserttoRecord.
    /// </summary>
    procedure InserttoRecord()
    var
        ltGeneralLedgerSetup: Record "General Ledger Setup";
    begin
        if rec."YVS WHT03 Nos." <> '' then
            InsertToNoSeries(rec."YVS WHT03 Nos.", WHT03Text, WHT03StartDate);
        if rec."YVS WHT53 Nos." <> '' then
            InsertToNoSeries(rec."YVS WHT53 Nos.", WHT53Text, WHT53StartDate);
        if rec."YVS WHT Document Nos." <> '' then
            InsertToNoSeries(rec."YVS WHT Document Nos.", PWHTText, PWHTStartDate);

        ltGeneralLedgerSetup.GET();
        ltGeneralLedgerSetup."YVS No. of Copy WHT Cert." := rec."YVS No. of Copy WHT Cert.";
        ltGeneralLedgerSetup."YVS WHT Certificate Caption 1" := rec."YVS WHT Certificate Caption 1";
        ltGeneralLedgerSetup."YVS WHT Certificate Caption 2" := rec."YVS WHT Certificate Caption 2";
        ltGeneralLedgerSetup."YVS WHT Certificate Caption 3" := rec."YVS WHT Certificate Caption 3";
        ltGeneralLedgerSetup."YVS WHT Certificate Caption 4" := rec."YVS WHT Certificate Caption 4";
        ltGeneralLedgerSetup."YVS WHT Document Nos." := rec."YVS WHT Document Nos.";
        ltGeneralLedgerSetup."YVS WHT53 Nos." := rec."YVS WHT53 Nos.";
        ltGeneralLedgerSetup."YVS WHT03 Nos." := rec."YVS WHT03 Nos.";
        ltGeneralLedgerSetup.Modify();
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

    var
        PWHTStartDate, WHT03StartDate, WHT53StartDate : code[20];
        PWHTText, WHT03Text, WHT53Text : text[100];
}
