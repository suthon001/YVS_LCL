/// <summary>
/// Page Tax Move Month (ID 80021).
/// </summary>
page 80021 "YVS Tax Move Month"
{
    SourceTable = "YVS Tax & WHT Header";
    InsertAllowed = false;
    ModifyAllowed = false;
    DelayedInsert = false;
    PageType = List;
    Caption = 'Move Month';
    SourceTableTemporary = true;
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            repeater("General")
            {
                Caption = 'General';
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Year-Month"; Rec."Year-Month")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Year-Month field.';
                }
                field("Month Name"; Rec."Month Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Month Name field.';
                }
                field("Year No."; Rec."Year No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Year No field.';
                }
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::LookupOK then
            MoveLine();
    end;

    /// <summary> 
    /// Description for MoveLine.
    /// </summary>
    local procedure MoveLine()
    var
        TaxReportLine: Record "YVS Tax & WHT Line";
    begin
        if not confirm(StrSubstNo('Do you want move to %1', rec."Document No.")) then
            exit;
        if TaxLine.FindFirst() then
            repeat
                TaxReportLine.Init();
                TaxReportLine.TransferFields(TaxLine, false);
                TaxReportLine."Tax Type" := TaxLine."Tax Type";
                TaxReportLine."Document No." := Rec."Document No.";
                TaxReportLine."Entry No." := TaxReportLine."GetLastLineNo"();
                TaxReportLine.Insert();

                TaxLine.Delete();

            until TaxLine.next() = 0;


    end;

    /// <summary> 
    /// Description for SetData.
    /// </summary>
    /// <param name="EntryType">Parameter of type Option Purchase,Sale,WHT.</param>
    /// <param name="EndOfWork">Parameter of type Date.</param>
    /// <param name="OldTaxLine">Parameter of type Record "YVS Tax WHT Line".</param>
    procedure "SetData"(EntryType: Enum "YVS Tax Type"; EndOfWork: Date; var OldTaxLine: Record "YVS Tax & WHT Line")
    var
        TaxHeader: Record "YVS Tax & WHT Header";

    begin

        TaxLine.Copy(OldTaxLine);

        TaxHeader.reset();
        TaxHeader.SetRange("Tax Type", EntryType);
        TaxHeader.SetFilter("End date of Month", '<>%1', EndOfWork);
        if TaxHeader.FindFirst() then
            repeat
                Rec.Init();
                Rec.TransferFields(TaxHeader);
                Rec.Insert();
            until TaxHeader.Next() = 0;
        Rec.reset();
        Rec.SetCurrentKey("Tax Type", "Document No.");
    end;

    var

        TaxLine: Record "YVS Tax & WHT Line";
}