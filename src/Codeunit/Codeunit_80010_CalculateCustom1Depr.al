codeunit 80010 "YVS CalculateCustom1Depr"
{

    Permissions = TableData 5601 = r,
                  TableData 5604 = r;

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'A depreciation entry must be posted on %2 = %3 for %1.';
        Text001: Label '%2 is positive on %3 = %4 for %1.';
        Text002: Label '%2 must not be 100 for %1.';
        Text003: Label '%2 is later than %3 for %1.';
        Text004: Label 'You must not specify %2 together with %3 = %4 for %1.';
        FA: Record 5600;
        FALedgEntry: Record 5601;
        DeprBook: Record 5611;
        FADeprBook: Record 5612;
        FAPostingTypeSetup: Record 5604;
        DepreciationCalc: Codeunit "YVS Depreciation Calculation";
        DeprBookCode: Code[10];
        UntilDate: Date;
        Sign: Integer;
        FirstDeprDate: Date;
        DaysInFiscalYear: Integer;
        NumberOfDays: Integer;
        NumberOfDays4: Integer;
        DaysInPeriod: Integer;
        EntryAmounts: array[4] of Decimal;
        DateFromProjection: Date;
        "YVS UseDeprStartingDate": Boolean;
        BookValue: Decimal;
        MinusBookValue: Decimal;
        SalvageValue: Decimal;
        AcquisitionDate: Date;
        DisposalDate: Date;
        DeprMethod: Option StraightLine,DB1,DB2,DB1SL,DB2SL,"User-Defined",Manual,BelowZero;
        DeprStartingDate: Date;
        FirstUserDefinedDeprDate: Date;
        SLPercent: Decimal;
        DBPercent: Decimal;
        FixedAmount: Decimal;
        DeprYears: Decimal;
        DeprTable: Code[10];
        FinalRoundingAmount: Decimal;
        EndingBookValue: Decimal;
        Custom1DeprStartingDate: Date;
        Custom1DeprUntil: Date;
        Custom1AccumPercent: Decimal;
        Custom1PercentThisYear: Decimal;
        Custom1PropertyClass: Option " ","Personal Property","Real Property";
        AcquisitionCost: Decimal;
        Custom1Depr: Decimal;
        ExtraDays: Integer;

    procedure "YVS Calculate"(var DeprAmount: Decimal; var Custom1DeprAmount: Decimal; var NumberOfDays3: Integer; var Custom1NumberOfDays3: Integer; FANo: Code[20]; DeprBookCode2: Code[10]; UntilDate2: Date; EntryAmounts2: array[4] of Decimal; DateFromProjection2: Date; DaysInPeriod2: Integer)
    var
        i: Integer;
    begin
        CLEARALL();
        DeprAmount := 0;
        Custom1DeprAmount := 0;
        NumberOfDays3 := 0;
        Custom1NumberOfDays3 := 0;
        DeprBookCode := DeprBookCode2;
        FALedgEntry.LOCKTABLE();
        FA.GET(FANo);
        DeprBook.GET(DeprBookCode);
        IF NOT FADeprBook.GET(FANo, DeprBookCode) THEN
            EXIT;
        DeprBook.TESTFIELD("Fiscal Year 365 Days", FALSE);
        FOR i := 1 TO 4 DO
            EntryAmounts[i] := EntryAmounts2[i];
        DateFromProjection := DateFromProjection2;
        DaysInPeriod := DaysInPeriod2;
        UntilDate := UntilDate2;
        DeprBook.TESTFIELD("Allow Depr. below Zero", FALSE);
        FADeprBook.TESTFIELD("Fixed Depr. Amount below Zero", 0);
        FADeprBook.TESTFIELD("Depr. below Zero %", 0);
        FADeprBook.TESTFIELD("Use Half-Year Convention", FALSE);
        DeprBook.TESTFIELD(
          "Periodic Depr. Date Calc.", DeprBook."Periodic Depr. Date Calc."::"Last Entry");

        FADeprBook.TESTFIELD("Property Class (Custom 1)");
        FAPostingTypeSetup.GET(
          DeprBookCode, FAPostingTypeSetup."FA Posting Type"::"Custom 1");
        FAPostingTypeSetup.TESTFIELD("Part of Book Value", TRUE);
        FAPostingTypeSetup.TESTFIELD("Part of Depreciable Basis", FALSE);
        FAPostingTypeSetup.TESTFIELD("Include in Depr. Calculation", TRUE);
        FAPostingTypeSetup.TESTFIELD(Sign, FAPostingTypeSetup.Sign::Credit);

        "YVS TransferValues"();
        IF NOT "YVS SkipRecord"() THEN BEGIN
            Sign := 1;
            IF NOT FADeprBook."Use FA Ledger Check" THEN BEGIN
                IF DeprBook."Use FA Ledger Check" THEN
                    FADeprBook.TESTFIELD("Use FA Ledger Check", TRUE);
                Sign :=
                  DepreciationCalc."YVS GetCustom1Sign"(
                    BookValue, AcquisitionCost, Custom1Depr, SalvageValue, MinusBookValue);
                IF Sign = 0 THEN
                    EXIT;
                IF Sign = -1 THEN
                    DepreciationCalc."YVS GetNewCustom1Signs"(
                      BookValue, AcquisitionCost, Custom1Depr, SalvageValue, MinusBookValue);
            END;
            IF BookValue + SalvageValue <= 0 THEN
                EXIT;
            IF (SalvageValue >= 0) AND (BookValue <= EndingBookValue) THEN
                EXIT;
            IF DateFromProjection > 0D THEN
                FirstDeprDate := DateFromProjection
            ELSE BEGIN
                FirstDeprDate := DepreciationCalc."YVS GetFirstDeprDate"(FANo, DeprBookCode, FALSE);
                IF (FirstDeprDate > UntilDate) OR (FirstDeprDate = 0D) THEN
                    EXIT;
                IF (Custom1DeprUntil = 0D) OR (FirstDeprDate <= Custom1DeprUntil) THEN BEGIN
                    "YVS UseDeprStartingDate" := DepreciationCalc."YVS UseDeprStartingDate"(FANo, DeprBookCode);
                    IF "YVS UseDeprStartingDate" THEN
                        FirstDeprDate := DeprStartingDate;
                END;
                IF FirstDeprDate < DeprStartingDate THEN
                    FirstDeprDate := DeprStartingDate;
                IF FirstDeprDate > UntilDate THEN
                    EXIT;
            END;
            IF "YVS UseDeprStartingDate" THEN
                ExtraDays := DepreciationCalc."YVS DeprDays"(
          Custom1DeprStartingDate, DeprStartingDate, FALSE, FALSE) - 1;
            IF (Custom1DeprUntil > 0D) AND (FirstDeprDate <= Custom1DeprUntil) AND
               (UntilDate > Custom1DeprUntil)
            THEN
                ERROR(
                  Text000,
                  "YVS FAName"(), FADeprBook.FIELDCAPTION("Depr. Ending Date (Custom 1)"), Custom1DeprUntil);
            NumberOfDays := DepreciationCalc."YVS DeprDays"(FirstDeprDate, UntilDate, FALSE, FALSE);//TPP.LCL

            IF NumberOfDays <= 0 THEN
                EXIT;

            IF DaysInPeriod > 0 THEN BEGIN
                NumberOfDays4 := NumberOfDays;
                NumberOfDays := DaysInPeriod;
                ExtraDays := 0;
            END;

            CalcDeprBasis();

            CASE DeprMethod OF
                DeprMethod::StraightLine:
                    DeprAmount := "YVS CalcSLAmount"();
                DeprMethod::DB1:
                    DeprAmount := "YVS CalcDB1Amount"();
                DeprMethod::DB2:
                    DeprAmount := "YVS CalcDB2Amount"();
                DeprMethod::DB1SL:
                    DeprAmount := "YVS CalcDBSLAmount"();
                DeprMethod::DB2SL,
              DeprMethod::Manual:
                    DeprAmount := 0;
                DeprMethod::"User-Defined":
                    DeprAmount := "YVS CalcCustom1Amount"();
            END;

            Custom1DeprAmount := CalcCustom1DeprAmount();
            DepreciationCalc."YVS AdjustCustom1"(
              DeprBookCode, DeprAmount, Custom1DeprAmount, BookValue, SalvageValue,
              EndingBookValue, FinalRoundingAmount);
            DeprAmount := Sign * DeprAmount;
            Custom1DeprAmount := Sign * Custom1DeprAmount;
            NumberOfDays3 := NumberOfDays;
            Custom1NumberOfDays3 := NumberOfDays + ExtraDays;
        END;
    end;

    local procedure "YVS SkipRecord"(): Boolean
    begin
        EXIT(
          (DisposalDate > 0D) OR
          (AcquisitionDate = 0D) OR
          (DeprMethod = DeprMethod::Manual) OR
          (AcquisitionDate > UntilDate) OR
          FA.Inactive OR
          FA.Blocked);
    end;

    local procedure "YVS CalcSLAmount"(): Decimal
    var
        RemainingLife: Decimal;
    begin
        IF SLPercent > 0 THEN
            EXIT(-CalcDeprBasis() * "YVS CalcSLPercent"() / 100);

        IF FixedAmount > 0 THEN
            EXIT(-FixedAmount * NumberOfDays / DaysInFiscalYear);

        IF DeprYears > 0 THEN BEGIN
            IF (Custom1DeprUntil = 0D) OR (UntilDate > Custom1DeprUntil) THEN BEGIN
                RemainingLife :=
                  (DeprYears * DaysInFiscalYear) -
                  DepreciationCalc."YVS DeprDays"(
                   DeprStartingDate, DepreciationCalc."YVS Yesterday"(FirstDeprDate, FALSE, FALSE), FALSE, FALSE);
                IF RemainingLife < 1 THEN
                    EXIT(-BookValue);

                EXIT(-(BookValue + SalvageValue - MinusBookValue) * NumberOfDays / RemainingLife);
            END;
            EXIT(-AcquisitionCost * NumberOfDays / DeprYears / DaysInFiscalYear);
        END;
        EXIT(0);
    end;

    local procedure "YVS CalcDBSLAmount"(): Decimal
    var
        SLAmount: Decimal;
        DBAmount: Decimal;
    begin
        IF DeprMethod = DeprMethod::DB1SL THEN
            DBAmount := "YVS CalcDB1Amount"()
        ELSE
            DBAmount := "YVS CalcDB2Amount"();
        IF UntilDate <= Custom1DeprUntil THEN
            EXIT(DBAmount);
        SLAmount := "YVS CalcSLAmount"();
        IF SLAmount < DBAmount THEN
            EXIT(SLAmount);

        EXIT(DBAmount)
    end;

    local procedure "YVS CalcDB2Amount"(): Decimal
    begin
        EXIT(
          -(1 - POWER(1 - DBPercent / 100, NumberOfDays / DaysInFiscalYear)) *
          (BookValue - MinusBookValue));
    end;

    local procedure "YVS CalcDB1Amount"(): Decimal
    var
        "YVS DeprInFiscalYear": Decimal;
    begin
        IF DateFromProjection = 0D THEN
            "YVS DeprInFiscalYear" := DepreciationCalc."YVS DeprInFiscalYear"(FA."No.", DeprBookCode, UntilDate)
        ELSE
            "YVS DeprInFiscalYear" := EntryAmounts[3];
        EXIT(
          -(DBPercent / 100) * (NumberOfDays / DaysInFiscalYear) *
          (BookValue - MinusBookValue - Sign * "YVS DeprInFiscalYear"));
    end;

    local procedure "YVS CalcCustom1Amount"(): Decimal
    var
        TableDeprCalc: Codeunit "YVS Table Depr. Calculation";
        Factor: Decimal;
    begin
        Factor := 1;
        IF DaysInPeriod > 0 THEN
            Factor := DaysInPeriod / NumberOfDays4;
        EXIT(
          -TableDeprCalc."YVS GetTablePercent"(
            DeprBook.Code, DeprTable, FirstUserDefinedDeprDate, FirstDeprDate, UntilDate) *
          AcquisitionCost * Factor);
    end;

    local procedure "YVS CalcSLPercent"(): Decimal
    var
        FractionOfFiscalYear: Decimal;
        CalcDeprYears: Decimal;
        YearsOfCustom1Depr: Decimal;
    begin
        FractionOfFiscalYear := NumberOfDays / DaysInFiscalYear;
        IF SLPercent <= 0 THEN
            EXIT(0);
        IF (Custom1PropertyClass = Custom1PropertyClass::"Real Property") OR
           (Custom1DeprUntil = 0D) OR (UntilDate <= Custom1DeprUntil)
        THEN
            EXIT(SLPercent * FractionOfFiscalYear);

        YearsOfCustom1Depr :=
          DepreciationCalc."YVS DeprDays"(
            Custom1DeprStartingDate, Custom1DeprUntil, FALSE, FALSE) / DaysInFiscalYear;//TPP.LCL
        CalcDeprYears := 100 / SLPercent;
        IF (CalcDeprYears - YearsOfCustom1Depr) <= 0.001 THEN
            EXIT(0);
        EXIT(100 * FractionOfFiscalYear / (CalcDeprYears - YearsOfCustom1Depr));
    end;

    local procedure "YVS CalcCustom1DeprPercent"(): Decimal
    var
        MaxPercent: Decimal;
        CurrentPercent: Decimal;
    begin
        IF (Custom1DeprUntil = 0D) OR (UntilDate > Custom1DeprUntil) OR (AcquisitionCost < 0.01) THEN
            EXIT(0);

        MaxPercent := Custom1AccumPercent - (-Custom1Depr * 100 / AcquisitionCost);
        IF MaxPercent < 0 THEN
            EXIT(0);
        CurrentPercent := Custom1PercentThisYear * (NumberOfDays + ExtraDays) / DaysInFiscalYear;
        IF CurrentPercent > MaxPercent THEN
            CurrentPercent := MaxPercent;
        EXIT(CurrentPercent);
    end;

    local procedure CalcCustom1DeprAmount(): Decimal
    begin
        EXIT(-AcquisitionCost * "YVS CalcCustom1DeprPercent"() / 100);
    end;

    local procedure CalcDeprBasis(): Decimal
    var
        FALedgEntry: Record 5601;
    begin
        IF (Custom1DeprUntil = 0D) OR (UntilDate <= Custom1DeprUntil) THEN
            EXIT(AcquisitionCost);
        FALedgEntry.SETCURRENTKEY("FA No.", "Depreciation Book Code", "Part of Book Value", "FA Posting Date");
        FALedgEntry.SETRANGE("FA No.", FA."No.");
        FALedgEntry.SETRANGE("Depreciation Book Code", DeprBookCode);
        FALedgEntry.SETRANGE("Part of Book Value", TRUE);
        FALedgEntry.SETRANGE("FA Posting Date", 0D, Custom1DeprUntil);
        FALedgEntry.CALCSUMS(Amount);
        IF (Sign = -1) AND (FALedgEntry.Amount > 0) THEN
            ERROR(
              Text001,
              "YVS FAName"(), FADeprBook.FIELDCAPTION("Book Value"),
              FADeprBook.FIELDCAPTION("Depr. Ending Date (Custom 1)"), Custom1DeprUntil);
        IF DateFromProjection = 0D THEN
            EXIT(ABS(FALedgEntry.Amount));

        EXIT(EntryAmounts[4]);
    end;

    local procedure "YVS TransferValues"()
    begin
        FADeprBook.TESTFIELD("Depreciation Starting Date");
        IF FADeprBook."Depreciation Method" = FADeprBook."Depreciation Method"::"User-Defined" THEN BEGIN
            FADeprBook.TESTFIELD("Depreciation Table Code");
            FADeprBook.TESTFIELD("First User-Defined Depr. Date");
        END;
        CASE FADeprBook."Depreciation Method" OF
            FADeprBook."Depreciation Method"::"Declining-Balance 1",
          FADeprBook."Depreciation Method"::"Declining-Balance 2":
                IF FADeprBook."Declining-Balance %" >= 100 THEN
                    ERROR(Text002, "YVS FAName"(), FADeprBook.FIELDCAPTION("Declining-Balance %"));
        END;
        IF DateFromProjection = 0D THEN BEGIN
            FADeprBook.CALCFIELDS("Book Value", "Acquisition Cost", "Custom 1", "Salvage Value");
            BookValue := FADeprBook."Book Value";
            Custom1Depr := FADeprBook."Custom 1";
        END ELSE BEGIN
            FADeprBook.CALCFIELDS("Acquisition Cost", "Salvage Value");
            BookValue := EntryAmounts[1];
            Custom1Depr := EntryAmounts[2];
        END;
        MinusBookValue := DepreciationCalc."YVS GetMinusBookValue"(FA."No.", DeprBookCode, 0D, 0D);
        AcquisitionCost := FADeprBook."Acquisition Cost";
        SalvageValue := FADeprBook."Salvage Value";
        DeprMethod := FADeprBook."Depreciation Method".AsInteger();
        DeprStartingDate := FADeprBook."Depreciation Starting Date";
        DeprTable := FADeprBook."Depreciation Table Code";
        FirstUserDefinedDeprDate := FADeprBook."First User-Defined Depr. Date";
        IF (FADeprBook."Depreciation Method" = FADeprBook."Depreciation Method"::"User-Defined") AND
           (FirstUserDefinedDeprDate > DeprStartingDate)
        THEN
            ERROR(
              Text003,
              "YVS FAName"(), FADeprBook.FIELDCAPTION("First User-Defined Depr. Date"), FADeprBook.FIELDCAPTION("Depreciation Starting Date"));
        SLPercent := FADeprBook."Straight-Line %";
        DeprYears := FADeprBook."No. of Depreciation Years";
        DBPercent := FADeprBook."Declining-Balance %";
        IF FADeprBook."Depreciation Ending Date" > 0D THEN BEGIN
            IF FADeprBook."Depreciation Starting Date" > FADeprBook."Depreciation Ending Date" THEN
                ERROR(
                  Text003,
                  "YVS FAName"(), FADeprBook.FIELDCAPTION("Depreciation Starting Date"), FADeprBook.FIELDCAPTION("Depreciation Ending Date"));
            DeprYears :=
              DepreciationCalc."YVS DeprDays"(
                FADeprBook."Depreciation Starting Date", FADeprBook."Depreciation Ending Date", FALSE, FALSE) / 360;
        END;
        FixedAmount := FADeprBook."Fixed Depr. Amount";
        FinalRoundingAmount := FADeprBook."Final Rounding Amount";
        IF FinalRoundingAmount = 0 THEN
            FinalRoundingAmount := DeprBook."Default Final Rounding Amount";
        EndingBookValue := FADeprBook."Ending Book Value";
        IF NOT FADeprBook."Ignore Def. Ending Book Value" AND (EndingBookValue = 0) THEN
            EndingBookValue := DeprBook."Default Ending Book Value";
        AcquisitionDate := FADeprBook."Acquisition Date";
        DisposalDate := FADeprBook."Disposal Date";
        DaysInFiscalYear := DeprBook."No. of Days in Fiscal Year";
        IF DaysInFiscalYear = 0 THEN
            DaysInFiscalYear := 360;
        Custom1DeprStartingDate := FADeprBook."Depr. Starting Date (Custom 1)";
        Custom1DeprUntil := FADeprBook."Depr. Ending Date (Custom 1)";
        Custom1AccumPercent := FADeprBook."Accum. Depr. % (Custom 1)";
        Custom1PercentThisYear := FADeprBook."Depr. This Year % (Custom 1)";
        Custom1PropertyClass := FADeprBook."Property Class (Custom 1)";
        IF Custom1DeprStartingDate = 0D THEN
            Custom1DeprStartingDate := DeprStartingDate;
        IF Custom1DeprStartingDate > DeprStartingDate THEN
            ERROR(
              Text003,
              "YVS FAName"(), FADeprBook.FIELDCAPTION("Depr. Starting Date (Custom 1)"), FADeprBook.FIELDCAPTION("Depreciation Starting Date"));
        IF (Custom1DeprUntil > 0D) AND (Custom1DeprUntil < DeprStartingDate) THEN
            ERROR(
              Text003,
              "YVS FAName"(), FADeprBook.FIELDCAPTION("Depreciation Starting Date"), FADeprBook.FIELDCAPTION("Depr. Ending Date (Custom 1)"));
        IF (DeprMethod = DeprMethod::DB2SL) AND (Custom1DeprUntil > 0D) THEN
            ERROR(
              Text004,
              "YVS FAName"(), FADeprBook.FIELDCAPTION("Depr. Ending Date (Custom 1)"),
              FADeprBook.FIELDCAPTION("Depreciation Method"), FADeprBook."Depreciation Method");
    end;

    local procedure "YVS FAName"(): Text
    var
        ltDepreciationCalc: Codeunit "YVS Depreciation Calculation";
    begin
        EXIT(ltDepreciationCalc."YVS FAName"(FA, DeprBookCode));
    end;
}


