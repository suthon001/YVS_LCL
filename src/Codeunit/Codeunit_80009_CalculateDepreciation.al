codeunit 80009 "YVS Calculate Depreciation"
{

    trigger OnRun()
    begin
    end;

    var
        DeprBook: Record 5611;
        FADeprBook: Record 5612;
        CalculateNormalDepr: Codeunit "YVS Calculate Normal Dep";
        CalculateCustom1Depr: Codeunit "YVS CalculateCustom1Depr";


    procedure "YVS Calculate"(var DeprAmount: Decimal; var Custom1Amount: Decimal; var NumberOfDays: Integer; var Custom1NumberOfDays: Integer; FANo: Code[20]; DeprBookCode: Code[10]; UntilDate: Date; EntryAmounts: array[4] of Decimal; DateFromProjection: Date; DaysInPeriod: Integer)
    begin
        DeprAmount := 0;
        Custom1Amount := 0;
        NumberOfDays := 0;
        Custom1NumberOfDays := 0;

        IF NOT DeprBook.GET(DeprBookCode) THEN
            EXIT;

        IF NOT FADeprBook.GET(FANo, DeprBookCode) THEN
            EXIT;

        "YVS CheckDeprDaysInFiscalYear"(DateFromProjection = 0D, UntilDate);

        IF DeprBook."Use Custom 1 Depreciation" AND
           (FADeprBook."Depr. Ending Date (Custom 1)" > 0D)
        THEN
            CalculateCustom1Depr."YVS Calculate"(
              DeprAmount, Custom1Amount, NumberOfDays,
              Custom1NumberOfDays, FANo, DeprBookCode, UntilDate,
              EntryAmounts, DateFromProjection, DaysInPeriod)
        ELSE
            CalculateNormalDepr."YVS Calculate"(
              DeprAmount, NumberOfDays, FANo, DeprBookCode, UntilDate,
              EntryAmounts, DateFromProjection, DaysInPeriod);
    end;

    local procedure "YVS CheckDeprDaysInFiscalYear"(CheckDeprDays: Boolean; UntilDate: Date)
    var
        DepreciationCalc: Codeunit "YVS Depreciation Calculation";
        FADateCalc: Codeunit "YVS FA Date Calculation";
        FiscalYearBegin: Date;
        NoOfDeprDays: Integer;
    begin

        IF DeprBook."Allow more than 360/365 Days" OR NOT CheckDeprDays THEN
            EXIT;
        IF (FADeprBook."Depreciation Method" = FADeprBook."Depreciation Method"::"Declining-Balance 1") OR
           (FADeprBook."Depreciation Method" = FADeprBook."Depreciation Method"::"DB1/SL")
        THEN
            FiscalYearBegin := FADateCalc."YVS GetFiscalYear"(DeprBook.Code, UntilDate);
        IF DeprBook."YVS Fiscal Year 366 Days" THEN
            NoOfDeprDays := 366
        ELSE
            IF DeprBook."Fiscal Year 365 Days" THEN
                NoOfDeprDays := 365
            ELSE
                NoOfDeprDays := 360;

        IF DepreciationCalc."YVS DeprDays"(
             FiscalYearBegin, UntilDate, DeprBook."Fiscal Year 365 Days", DeprBook."YVS Fiscal Year 366 Days") > NoOfDeprDays
        THEN
            DeprBook.TESTFIELD("Allow more than 360/365 Days");
    end;
}

