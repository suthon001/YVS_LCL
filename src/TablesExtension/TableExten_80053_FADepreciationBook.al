/// <summary>
/// TableExtension YVS FA Depreciation Book (ID 80053) extends Record FA Depreciation Book.
/// </summary>
tableextension 80053 "YVS FA Depreciation Book" extends "FA Depreciation Book"
{
    fields
    {
        field(80000; "YVS No. of Years"; Decimal)
        {
            Caption = 'No. of Years';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if ("YVS No. of Years" <> xRec."YVS No. of Years") and ("YVS No. of Years" = 0) then
                    Validate("Depreciation Ending Date", 0D)
                else
                    Validate("Depreciation Ending Date", "YVS CalcEndingDate2"());
            end;
        }

        modify("Depreciation Starting Date")
        {
            trigger OnAfterValidate()
            var
                FuncenterYVS: Codeunit "YVS Function Center";
            begin
                if not FuncenterYVS.CheckDisableLCL() then
                    exit;
                "YVS CalcDeprPeriod"();
                IF "Depreciation Starting Date" <> xRec."Depreciation Starting Date" THEN
                    IF "YVS No. of Years" <> 0 THEN
                        VALIDATE("Depreciation Ending Date", "YVS CalcEndingDate2"());

            end;
        }
        modify("No. of Depreciation Years")
        {
            trigger OnAfterValidate()
            var
                FuncenterYVS: Codeunit "YVS Function Center";
            begin
                if not FuncenterYVS.CheckDisableLCL() then
                    exit;
                rec.Validate("YVS No. of Years", rec."No. of Depreciation Years");
            end;
        }
        Modify("Depreciation Book Code")
        {
            trigger OnBeforeValidate()
            var
                FuncenterYVS: Codeunit "YVS Function Center";
            begin
                if not FuncenterYVS.CheckDisableLCL() then
                    exit;
                if rec."Depreciation Book Code" <> '' then
                    if rec."Depreciation Starting Date" = 0D then
                        rec."Depreciation Starting Date" := WorkDate();
            end;
        }
    }
    /// <summary>
    /// YVS CalcDeprPeriod.
    /// </summary>
    procedure "YVS CalcDeprPeriod"()
    var
        DeprBook2: Record "Depreciation Book";
        DepreciationCalc: Codeunit "YVS Depreciation Calculation";
        Text002: Label '%1 is later than %2.';
    begin
        IF "Depreciation Starting Date" = 0D THEN BEGIN
            "Depreciation Ending Date" := 0D;
            "No. of Depreciation Years" := 0;
            "No. of Depreciation Months" := 0;
        END;
        IF ("Depreciation Starting Date" = 0D) OR ("Depreciation Ending Date" = 0D) THEN BEGIN
            "No. of Depreciation Years" := 0;
            "No. of Depreciation Months" := 0;
        END ELSE BEGIN
            IF "Depreciation Starting Date" > "Depreciation Ending Date" THEN
                ERROR(
                  Text002,
                  FIELDCAPTION("Depreciation Starting Date"), FIELDCAPTION("Depreciation Ending Date"));
            DeprBook2.GET("Depreciation Book Code");
            IF DeprBook2."Fiscal Year 365 Days" THEN BEGIN
                "No. of Depreciation Months" := 0;
                "No. of Depreciation Years" := 0;
            END;
            IF (NOT DeprBook2."Fiscal Year 365 Days") OR (NOT DeprBook2."YVS Fiscal Year 366 Days") THEN BEGIN//TPP.LCL
                "No. of Depreciation Months" :=
                  DepreciationCalc."YVS DeprDays"("Depreciation Starting Date", "Depreciation Ending Date", FALSE, FALSE) / 30;//TPP.LCL
                "No. of Depreciation Months" := ROUND("No. of Depreciation Months", 0.00000001);
                "No. of Depreciation Years" := ROUND("No. of Depreciation Months" / 12, 0.00000001);
            END;
            "Straight-Line %" := 0;
            "Fixed Depr. Amount" := 0;
        END;

    end;

    local procedure "YVS CalcEndingDate2"(): Date
    var
        EndingDate: Date;
        FaDateCalc: Codeunit "YVS FA Date Calculation";
        DepreciationCalc: Codeunit "YVS Depreciation Calculation";
    begin
        IF "YVS No. of Years" = 0 THEN
            EXIT(0D);
        EndingDate := FADateCalc."YVS CalculateDate"(
            "Depreciation Starting Date", ROUND("YVS No. of Years" * 360, 1), FALSE, FALSE);
        EndingDate := DepreciationCalc."YVS Yesterday"(EndingDate, FALSE, FALSE);
        IF EndingDate < "Depreciation Starting Date" THEN
            EndingDate := "Depreciation Starting Date";
        EXIT(EndingDate);
    end;
}
