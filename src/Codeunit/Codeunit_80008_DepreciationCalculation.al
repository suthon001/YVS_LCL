codeunit 80008 "YVS Depreciation Calculation"
{
    Permissions = TableData 5601 = r,
                  TableData 5604 = r,
                  TableData 5625 = r;

    trigger OnRun()
    begin
    end;

    var
        Text000: Label '%1 %2 = %3 in %4 %5 = %6';
        DeprBookCodeErr: Label ' in depreciation book code %1', Comment = '%1=value for code, e.g. COMAPNY';

    procedure "YVS DeprDays"(StartingDate: Date; EndingDate: Date; Year365Days: Boolean; Year366Days: Boolean): Integer
    var
        StartingDay: Integer;
        EndingDay: Integer;
        StartingMonth: Integer;
        EndingMonth: Integer;
        StartingYear: Integer;
        EndingYear: Integer;
    begin
        // Both days are inclusive

        IF EndingDate < StartingDate THEN
            EXIT(0);
        IF (StartingDate = 0D) OR (EndingDate = 0D) THEN
            EXIT(0);



        IF Year365Days OR Year366Days THEN //TPP.LCL
            EXIT("YVS DeprDays365"(StartingDate, EndingDate, Year366Days));//TPP.LCL

        StartingDay := DATE2DMY(StartingDate, 1);
        EndingDay := DATE2DMY(EndingDate, 1);



        StartingMonth := DATE2DMY(StartingDate, 2);
        EndingMonth := DATE2DMY(EndingDate, 2);
        StartingYear := DATE2DMY(StartingDate, 3);
        EndingYear := DATE2DMY(EndingDate, 3);
        IF DATE2DMY(StartingDate, 1) = 31 THEN
            StartingDay := 30;
        IF DATE2DMY(EndingDate + 1, 1) = 1 THEN
            EndingDay := 30;

        EXIT(1 + EndingDay - StartingDay + 30 * (EndingMonth - StartingMonth) +
          360 * (EndingYear - StartingYear));
    end;

    procedure "YVS ToMorrow"(ThisDate: Date; Year365Days: Boolean; Year366Days: Boolean): Date
    begin
        IF Year365Days OR Year366Days THEN //TPP.LCL
            EXIT("YVS ToMorrow365"(ThisDate, Year366Days));//TPP.LCL
        ThisDate := ThisDate + 1;
        IF DATE2DMY(ThisDate, 1) = 31 THEN
            ThisDate := ThisDate + 1;
        EXIT(ThisDate);


    end;

    procedure "YVS Yesterday"(ThisDate: Date; Year365Days: Boolean; Year366Days: Boolean): Date
    begin
        IF Year365Days OR Year366Days THEN
            EXIT("YVS Yesterday365"(ThisDate, Year366Days));
        IF ThisDate = 0D THEN
            EXIT(0D);
        IF DATE2DMY(ThisDate, 1) = 31 THEN
            ThisDate := ThisDate - 1;
        ThisDate := ThisDate - 1;
        EXIT(ThisDate);
    end;

    procedure "YVS SetFAFilter"(var FALedgEntry: Record 5601; FANo: Code[20]; DeprBookCode: Code[10]; FAPostingTypeOrder: Boolean)
    begin

        FALedgEntry.RESET();
        IF FAPostingTypeOrder THEN BEGIN
            FALedgEntry.SETCURRENTKEY(
              "FA No.", "Depreciation Book Code",
              "FA Posting Category", "FA Posting Type", "FA Posting Date");
            FALedgEntry.SETRANGE("FA Posting Category", FALedgEntry."FA Posting Category"::" ");
        END ELSE
            FALedgEntry.SETCURRENTKEY("FA No.", "Depreciation Book Code", "FA Posting Date");
        FALedgEntry.SETRANGE("FA No.", FANo);
        FALedgEntry.SETRANGE("Depreciation Book Code", DeprBookCode);
        FALedgEntry.SETRANGE(Reversed, FALSE);

    end;

    procedure "YVS CalcEntryAmounts"(FANo: Code[20]; DeprBookCode: Code[10]; StartingDate: Date; EndingDate: Date; var EntryAmounts: array[4] of Decimal)
    var
        FALedgEntry: Record 5601;
        I: Integer;
    begin
        IF EndingDate = 0D THEN
            EndingDate := DMY2DATE(31, 12, 9999);

        "YVS SetFAFilter"(FALedgEntry, FANo, DeprBookCode, TRUE);
        FALedgEntry.SETRANGE("FA Posting Date", StartingDate, EndingDate);
        FALedgEntry.SETRANGE("Part of Book Value", TRUE);
        FOR I := 1 TO 4 DO BEGIN
            CASE I OF
                1:
                    FALedgEntry.SETRANGE("FA Posting Type", FALedgEntry."FA Posting Type"::"Write-Down");
                2:
                    FALedgEntry.SETRANGE("FA Posting Type", FALedgEntry."FA Posting Type"::Appreciation);
                3:
                    FALedgEntry.SETRANGE("FA Posting Type", FALedgEntry."FA Posting Type"::"Custom 1");
                4:
                    FALedgEntry.SETRANGE("FA Posting Type", FALedgEntry."FA Posting Type"::"Custom 2");
            END;
            FALedgEntry.CALCSUMS(Amount);
            EntryAmounts[I] := FALedgEntry.Amount;
        END;

    end;

    local procedure "YVS GetLastEntryDates"(FANo: Code[20]; DeprBookCode: Code[10]; var EntryDates: array[4] of Date)
    var
        FALedgEntry: Record 5601;
        i: Integer;
    begin
        CLEAR(EntryDates);

        "YVS SetFAFilter"(FALedgEntry, FANo, DeprBookCode, TRUE);
        FOR i := 1 TO 4 DO BEGIN
            CASE i OF
                1:
                    FALedgEntry.SETRANGE("FA Posting Type", FALedgEntry."FA Posting Type"::"Write-Down");
                2:
                    FALedgEntry.SETRANGE("FA Posting Type", FALedgEntry."FA Posting Type"::Appreciation);
                3:
                    FALedgEntry.SETRANGE("FA Posting Type", FALedgEntry."FA Posting Type"::"Custom 1");
                4:
                    FALedgEntry.SETRANGE("FA Posting Type", FALedgEntry."FA Posting Type"::"Custom 2");
            END;
            IF "YVS GetPartOfCalculation"(0, i - 1, DeprBookCode) THEN
                IF FALedgEntry.FindSet() THEN
                    REPEAT
                        IF FALedgEntry."Part of Book Value" OR FALedgEntry."Part of Depreciable Basis" THEN
                            IF FALedgEntry."FA Posting Date" > EntryDates[i] THEN
                                EntryDates[i] := "YVS CheckEntryDate"(FALedgEntry, i - 1);
                    UNTIL FALedgEntry.NEXT() = 0;
        END;
    end;

    procedure "YVS UseDeprStartingDate"(FANo: Code[20]; DeprBookCode: Code[10]): Boolean
    var
        FALedgEntry: Record 5601;
        EntryDates: array[4] of Date;
        i: Integer;
    begin
        "YVS SetFAFilter"(FALedgEntry, FANo, DeprBookCode, TRUE);
        FALedgEntry.SETRANGE("FA Posting Type", FALedgEntry."FA Posting Type"::Depreciation);
        IF not FALedgEntry.IsEmpty() THEN
            EXIT(FALSE);

        "YVS GetLastEntryDates"(FANo, DeprBookCode, EntryDates);
        FOR i := 1 TO 4 DO
            IF EntryDates[i] > 0D THEN
                EXIT(FALSE);
        EXIT(TRUE);
    end;

    procedure "YVS GetFirstDeprDate"(FANo: Code[20]; DeprBookCode: Code[10]; Year365Days: Boolean): Date
    var
        FALedgEntry: Record 5601;
        EntryDates: array[4] of Date;
        LocalDate: Date;
        i: Integer;
        Year366Days: Boolean;
        DPBook: Record "Depreciation Book";
    begin

        Year366Days := FALSE;
        IF DPBook.GET(DeprBookCode) THEN
            Year366Days := DPBook."YVS Fiscal Year 366 Days";


        "YVS SetFAFilter"(FALedgEntry, FANo, DeprBookCode, TRUE);
        FALedgEntry.SETRANGE("FA Posting Type", FALedgEntry."FA Posting Type"::"Acquisition Cost");
        IF FALedgEntry.FINDLAST() THEN
            IF FALedgEntry."FA Posting Date" > LocalDate THEN
                LocalDate := FALedgEntry."FA Posting Date";
        FALedgEntry.SETRANGE("FA Posting Type", FALedgEntry."FA Posting Type"::"Salvage Value");
        IF FALedgEntry.FINDLAST() THEN
            IF FALedgEntry."FA Posting Date" > LocalDate THEN
                LocalDate := FALedgEntry."FA Posting Date";
        FALedgEntry.SETRANGE("FA Posting Type", FALedgEntry."FA Posting Type"::Depreciation);
        IF FALedgEntry.FINDLAST() THEN
            IF "YVS ToMorrow"(FALedgEntry."FA Posting Date", Year365Days, Year366Days) > LocalDate THEN
                LocalDate := "YVS ToMorrow"(FALedgEntry."FA Posting Date", Year365Days, Year366Days);


        "YVS GetLastEntryDates"(FANo, DeprBookCode, EntryDates);
        FOR i := 1 TO 4 DO
            IF EntryDates[i] > LocalDate THEN
                LocalDate := EntryDates[i];


        EXIT(LocalDate);
    end;

    procedure "YVS GetMinusBookValue"(FANo: Code[20]; DeprBookCode: Code[10]; StartingDate: Date; EndingDate: Date): Decimal
    var
        EntryAmounts: array[4] of Decimal;
        Amount: Decimal;
        i: Integer;
    begin
        "YVS CalcEntryAmounts"(FANo, DeprBookCode, StartingDate, EndingDate, EntryAmounts);
        FOR i := 1 TO 4 DO
            IF NOT "YVS GetPartOfCalculation"(0, i - 1, DeprBookCode) THEN
                Amount := Amount + EntryAmounts[i];
        EXIT(Amount);
    end;

    local procedure "YVS CalcMaxDepr"(BookValue: Decimal; SalvageValue: Decimal; EndingBookValue: Decimal): Decimal
    var
        MaxDepr: Decimal;
    begin
        IF SalvageValue <> 0 THEN
            EndingBookValue := 0;
        MaxDepr := -(BookValue + SalvageValue - EndingBookValue);
        IF MaxDepr > 0 THEN
            MaxDepr := 0;
        EXIT(MaxDepr);
    end;

    procedure "YVS AdjustDepr"(DeprBookCode: Code[10]; var Depreciation: Decimal; BookValue: Decimal; SalvageValue: Decimal; EndingBookValue: Decimal; FinalRoundingAmount: Decimal)
    var
        DeprBook: Record 5611;
        MaxDepr: Decimal;
    begin
        IF FinalRoundingAmount = 0 THEN BEGIN
            DeprBook.GET(DeprBookCode);
            FinalRoundingAmount := DeprBook."Default Final Rounding Amount";
        END;
        Depreciation := "YVS CalcRounding"(DeprBookCode, Depreciation);
        "YVS OnAfterCalcDepreciation"(DeprBookCode, Depreciation, BookValue);
        IF Depreciation >= 0 THEN
            Depreciation := 0
        ELSE BEGIN
            IF SalvageValue <> 0 THEN
                EndingBookValue := 0;
            MaxDepr := BookValue + SalvageValue - EndingBookValue;
            IF MaxDepr + Depreciation < FinalRoundingAmount THEN
                Depreciation := -MaxDepr;
            IF Depreciation > 0 THEN
                Depreciation := 0;
        END;
    end;

    procedure "YVS AdjustCustom1"(DeprBookCode: Code[10]; var DeprAmount: Decimal; var Custom1Amount: Decimal; BookValue: Decimal; SalvageValue: Decimal; EndingBookValue: Decimal; FinalRoundingAmount: Decimal)
    var
        DeprBook: Record 5611;
        MaxDepr: Decimal;
    begin
        IF DeprAmount > 0 THEN
            DeprAmount := 0;
        IF Custom1Amount > 0 THEN
            Custom1Amount := 0;

        DeprAmount := "YVS CalcRounding"(DeprBookCode, DeprAmount);
        Custom1Amount := "YVS CalcRounding"(DeprBookCode, Custom1Amount);

        IF FinalRoundingAmount = 0 THEN BEGIN
            DeprBook.GET(DeprBookCode);
            FinalRoundingAmount := DeprBook."Default Final Rounding Amount";
        END;

        IF Custom1Amount < 0 THEN BEGIN
            MaxDepr := "YVS CalcMaxDepr"(BookValue, SalvageValue, EndingBookValue);
            IF Custom1Amount <= MaxDepr THEN BEGIN
                Custom1Amount := MaxDepr;
                DeprAmount := 0;
            END;
            IF DeprAmount >= 0 THEN
                "YVS AdjustDepr"(
                  DeprBookCode, Custom1Amount, BookValue, SalvageValue, EndingBookValue, FinalRoundingAmount);
            BookValue := BookValue + Custom1Amount;
        END;
        IF DeprAmount < 0 THEN BEGIN
            MaxDepr := "YVS CalcMaxDepr"(BookValue, SalvageValue, EndingBookValue);
            IF DeprAmount <= MaxDepr THEN
                DeprAmount := MaxDepr;
            IF DeprAmount < 0 THEN
                "YVS AdjustDepr"(
                  DeprBookCode, DeprAmount, BookValue, SalvageValue, EndingBookValue, FinalRoundingAmount);
        END;

        IF DeprAmount > 0 THEN
            DeprAmount := 0;
        IF Custom1Amount > 0 THEN
            Custom1Amount := 0;
    end;

    procedure "YVS GetSign"(BookValue: Decimal; DeprBasis: Decimal; SalvageValue: Decimal; MinusBookValue: Decimal): Integer
    begin
        IF (SalvageValue <= 0) AND (DeprBasis >= 0) AND
           (BookValue >= 0) AND (MinusBookValue <= 0)
        THEN
            EXIT(1);
        IF (SalvageValue >= 0) AND (DeprBasis <= 0) AND
           (BookValue <= 0) AND (MinusBookValue >= 0)
        THEN
            EXIT(-1);
        EXIT(0);
    end;

    procedure "YVS GetCustom1Sign"(BookValue: Decimal; AcquisitionCost: Decimal; Custom1: Decimal; SalvageValue: Decimal; MinusBookValue: Decimal): Integer
    begin
        IF (SalvageValue <= 0) AND (AcquisitionCost >= 0) AND
           (BookValue >= 0) AND (Custom1 <= 0) AND (MinusBookValue <= 0)
        THEN
            EXIT(1);
        IF (SalvageValue >= 0) AND (AcquisitionCost <= 0) AND
           (BookValue <= 0) AND (Custom1 >= 0) AND (MinusBookValue >= 0)
        THEN
            EXIT(-1);
        EXIT(0);
    end;

    procedure "YVS GetNewSigns"(var BookValue: Decimal; var DeprBasis: Decimal; var SalvageValue: Decimal; var MinusBookValue: Decimal)
    begin
        BookValue := -BookValue;
        DeprBasis := -DeprBasis;
        SalvageValue := -SalvageValue;
        MinusBookValue := -MinusBookValue;
    end;

    procedure "YVS GetNewCustom1Signs"(var BookValue: Decimal; var AcquisitionCost: Decimal; var Custom1: Decimal; var SalvageValue: Decimal; var MinusBookValue: Decimal)
    begin
        BookValue := -BookValue;
        AcquisitionCost := -AcquisitionCost;
        Custom1 := -Custom1;
        SalvageValue := -SalvageValue;
        MinusBookValue := -MinusBookValue;
    end;

    procedure "YVS CalcRounding"(DeprBookCode: Code[10]; DeprAmount: Decimal): Decimal
    var
        DeprBook: Record 5611;
    begin

        DeprBook.GET(DeprBookCode);
        IF DeprBook."Use Rounding in Periodic Depr." THEN
            EXIT(ROUND(DeprAmount, 1));

        EXIT(ROUND(DeprAmount));

    end;

    procedure "YVS CalculateDeprInPeriod"(FANo: Code[20]; DeprBookCode: Code[10]; EndingDate: Date; CalculatedDepr: Decimal; Sign: Integer; var NewBookValue: Decimal; var DeprBasis: Decimal; var SalvageValue: Decimal; var MinusBookValue: Decimal)
    var
        FALedgEntry: Record 5601;
    begin

        FALedgEntry.SETCURRENTKEY("FA No.", "Depreciation Book Code", "Part of Book Value", "FA Posting Date");
        FALedgEntry.SETRANGE("Depreciation Book Code", DeprBookCode);
        FALedgEntry.SETRANGE("FA No.", FANo);
        FALedgEntry.SETRANGE("FA Posting Date", 0D, EndingDate);
        FALedgEntry.SETRANGE("Part of Book Value", TRUE);
        FALedgEntry.CALCSUMS(Amount);
        NewBookValue := Sign * FALedgEntry.Amount + CalculatedDepr;
        FALedgEntry.SETRANGE("Part of Book Value");
        FALedgEntry.SETCURRENTKEY("FA No.", "Depreciation Book Code", "Part of Depreciable Basis", "FA Posting Date");
        FALedgEntry.SETRANGE("Part of Depreciable Basis", TRUE);
        FALedgEntry.CALCSUMS(Amount);
        DeprBasis := Sign * FALedgEntry.Amount;
        FALedgEntry.SETRANGE("Part of Depreciable Basis");
        FALedgEntry.SETCURRENTKEY(
          "FA No.", "Depreciation Book Code",
          "FA Posting Category", "FA Posting Type", "FA Posting Date");
        FALedgEntry.SETRANGE("FA Posting Category", FALedgEntry."FA Posting Category"::" ");
        FALedgEntry.SETRANGE("FA Posting Type", FALedgEntry."FA Posting Type"::"Salvage Value");
        FALedgEntry.CALCSUMS(Amount);
        SalvageValue := Sign * FALedgEntry.Amount;
        MinusBookValue := Sign * "YVS GetMinusBookValue"(FANo, DeprBookCode, 0D, EndingDate);

    end;

    procedure "YVS GetDeprPeriod"(FANo: Code[20]; DeprBookCode: Code[10]; UntilDate: Date; var StartingDate: Date; var EndingDate: Date; var NumberOfDays: Integer; Year365Days: Boolean)
    var
        FALedgEntry: Record 5601;
        FADeprBook: Record 5612;
        UsedDeprStartingDate: Boolean;
        Year366Days: Boolean;
        DPBook: Record "Depreciation Book";
    begin
        FADeprBook.GET(FANo, DeprBookCode);
        Year366Days := FALSE;
        IF DPBook.GET(DeprBookCode) THEN
            Year366Days := DPBook."YVS Fiscal Year 366 Days";


        // Calculate Starting Date
        IF StartingDate = 0D THEN BEGIN
            "YVS SetFAFilter"(FALedgEntry, FANo, DeprBookCode, TRUE);
            FALedgEntry.SETRANGE("FA Posting Type", FALedgEntry."FA Posting Type"::Depreciation);
            IF FALedgEntry.FindLast() THEN
                StartingDate := "YVS ToMorrow"(FALedgEntry."FA Posting Date", Year365Days, Year366Days)
            ELSE BEGIN
                StartingDate := FADeprBook."Depreciation Starting Date";
                UsedDeprStartingDate := TRUE;
            END;
        END ELSE
            StartingDate := "YVS ToMorrow"(EndingDate, Year365Days, Year366Days);

        // Calculate Ending Date
        EndingDate := 0D;
        "YVS SetFAFilter"(FALedgEntry, FANo, DeprBookCode, FALSE);
        IF NOT UsedDeprStartingDate THEN
            FALedgEntry.SETFILTER("FA Posting Date", '%1..', StartingDate + 1);
        IF FALedgEntry.FindSet() then
            REPEAT
                IF FALedgEntry."Part of Book Value" OR FALedgEntry."Part of Depreciable Basis" THEN BEGIN
                    IF (FALedgEntry."FA Posting Type" = FALedgEntry."FA Posting Type"::"Acquisition Cost") OR
                       (FALedgEntry."FA Posting Type" = FALedgEntry."FA Posting Type"::"Salvage Value")
                    THEN BEGIN
                        IF NOT UsedDeprStartingDate THEN
                            EndingDate := FALedgEntry."FA Posting Date";
                    END ELSE
                        IF GetPartOfDeprCalculation(FALedgEntry) THEN
                            EndingDate := FALedgEntry."FA Posting Date";
                    EndingDate := "YVS Yesterday"(EndingDate, Year365Days, Year366Days);
                    IF EndingDate < StartingDate THEN
                        EndingDate := 0D;
                END;
            UNTIL (FALedgEntry.NEXT() = 0) OR (EndingDate > 0D);

        IF EndingDate = 0D THEN
            EndingDate := UntilDate;
        NumberOfDays := "YVS DeprDays"(StartingDate, EndingDate, Year365Days, Year366Days);
    end;

    procedure "YVS DeprInFiscalYear"(FANo: Code[20]; DeprBookCode: Code[10]; StartingDate: Date): Decimal
    var
        FALedgEntry: Record 5601;
        FADateCalc: Codeunit "YVS FA Date Calculation";
        LocalAmount: Decimal;
        EntryAmounts: array[4] of Decimal;
        FiscalYearBegin: Date;
        i: Integer;
    begin
        FiscalYearBegin := FADateCalc."YVS GetFiscalYear"(DeprBookCode, StartingDate);

        "YVS SetFAFilter"(FALedgEntry, FANo, DeprBookCode, TRUE);
        FALedgEntry.SETFILTER("FA Posting Date", '%1..', FiscalYearBegin);
        FALedgEntry.SETRANGE("FA Posting Type", FALedgEntry."FA Posting Type"::Depreciation);
        FALedgEntry.SETRANGE("Part of Book Value", TRUE);
        FALedgEntry.SETRANGE("Reclassification Entry", FALSE);
        FALedgEntry.CALCSUMS(Amount);
        LocalAmount := FALedgEntry.Amount;
        "YVS CalcEntryAmounts"(FANo, DeprBookCode, FiscalYearBegin, 0D, EntryAmounts);
        FOR i := 1 TO 4 DO
            IF "YVS GetPartOfCalculation"(2, i - 1, DeprBookCode) THEN
                LocalAmount := LocalAmount + EntryAmounts[i];

        EXIT(LocalAmount);
    end;

    procedure "YVS GetPartOfCalculation"(Type: Option IncludeInDeprCalc,IncludeInGainLoss,DepreciationType,ReverseType; PostingType: Option "Write-Down",Appreciation,"Custom 1","Custom 2"; DeprBookCode: Code[10]): Boolean
    var
        FAPostingTypeSetup: Record 5604;
    begin

        CASE PostingType OF
            PostingType::"Write-Down":
                FAPostingTypeSetup.GET(DeprBookCode, FAPostingTypeSetup."FA Posting Type"::"Write-Down");
            PostingType::Appreciation:
                FAPostingTypeSetup.GET(DeprBookCode, FAPostingTypeSetup."FA Posting Type"::Appreciation);
            PostingType::"Custom 1":
                FAPostingTypeSetup.GET(DeprBookCode, FAPostingTypeSetup."FA Posting Type"::"Custom 1");
            PostingType::"Custom 2":
                FAPostingTypeSetup.GET(DeprBookCode, FAPostingTypeSetup."FA Posting Type"::"Custom 2");
        END;

        IF Type = Type::IncludeInDeprCalc THEN
            EXIT(FAPostingTypeSetup."Include in Depr. Calculation");
        IF Type = Type::IncludeInGainLoss THEN
            EXIT(FAPostingTypeSetup."Include in Gain/Loss Calc.");
        IF Type = Type::DepreciationType THEN
            EXIT(FAPostingTypeSetup."Depreciation Type");
        IF Type = Type::ReverseType THEN
            EXIT(FAPostingTypeSetup."Reverse before Disposal");

    end;

    local procedure GetPartOfDeprCalculation(var FALedgEntry: Record 5601): Boolean
    var
        i: Integer;
    begin

        CASE FALedgEntry."FA Posting Type" OF
            FALedgEntry."FA Posting Type"::"Write-Down":
                i := 1;
            FALedgEntry."FA Posting Type"::Appreciation:
                i := 2;
            FALedgEntry."FA Posting Type"::"Custom 1":
                i := 3;
            FALedgEntry."FA Posting Type"::"Custom 2":
                i := 4;
        END;
        IF i = 0 THEN
            EXIT(FALSE);

        EXIT("YVS GetPartOfCalculation"(0, i - 1, FALedgEntry."Depreciation Book Code"));

    end;

    procedure "YVS FAName"(var FA: Record 5600; DeprBookCode: Code[10]): Text
    var
        DeprBook: Record 5611;
    begin
        IF DeprBookCode = '' THEN
            EXIT(STRSUBSTNO('%1 %2 = %3', FA.TABLECAPTION, FA.FIELDCAPTION("No."), FA."No."));

        EXIT(
          STRSUBSTNO(
            Text000,
            FA.TABLECAPTION, FA.FIELDCAPTION("No."), FA."No.",
            DeprBook.TABLECAPTION, DeprBook.FIELDCAPTION(Code), DeprBookCode));
    end;

    procedure FADeprBookName(DeprBookCode: Code[10]): Text[200]
    begin
        IF DeprBookCode = '' THEN
            EXIT('');

        EXIT(STRSUBSTNO(DeprBookCodeErr, DeprBookCode));
    end;

    local procedure "YVS DeprDays365"(StartingDate: Date; EndingDate: Date; Year366: Boolean): Integer
    var
        StartingYear: Integer;
        EndingYear: Integer;
        ActualYear: Integer;
        LeapDate: Date;
        LeapDays: Integer;
    begin
        StartingYear := DATE2DMY(StartingDate, 3);
        EndingYear := DATE2DMY(EndingDate, 3);
        LeapDays := 0;
        IF NOT Year366 THEN
            IF (DATE2DMY(StartingDate, 1) = 29) AND (DATE2DMY(StartingDate, 2) = 2) AND
               (DATE2DMY(EndingDate, 1) = 29) AND (DATE2DMY(EndingDate, 2) = 2)
            THEN
                LeapDays := -1;

        ActualYear := StartingYear;
        WHILE ActualYear <= EndingYear DO BEGIN
            IF NOT Year366 THEN BEGIN
                LeapDate := (DMY2DATE(28, 2, ActualYear) + 1);
                IF DATE2DMY(LeapDate, 1) = 29 THEN
                    IF (LeapDate >= StartingDate) AND (LeapDate <= EndingDate) THEN
                        LeapDays := LeapDays + 1;

            END;
            ActualYear := ActualYear + 1;
        END;

        EXIT((EndingDate - StartingDate) + 1 - LeapDays);
    end;

    local procedure "YVS ToMorrow365"(ThisDate: Date; Year366: Boolean): Date
    begin
        ThisDate := ThisDate + 1;
        IF NOT Year366 THEN
            IF (DATE2DMY(ThisDate, 1) = 29) AND (DATE2DMY(ThisDate, 2) = 2) THEN
                ThisDate := ThisDate + 1;

        EXIT(ThisDate);

    end;

    local procedure "YVS Yesterday365"(ThisDate: Date; Year366: Boolean): Date
    begin
        IF ThisDate = 0D THEN
            EXIT(0D);
        IF NOT Year366 THEN
            IF (DATE2DMY(ThisDate, 1) = 29) AND (DATE2DMY(ThisDate, 2) = 2) THEN
                ThisDate := ThisDate - 1;

        ThisDate := ThisDate - 1;
        EXIT(ThisDate);
    end;

    local procedure "YVS CheckEntryDate"(FALedgerEntry: Record 5601; FAPostingType: Option): Date
    begin

        IF "YVS IsDepreciationTypeEntry"(FALedgerEntry."Depreciation Book Code", FAPostingType) THEN
            EXIT(FALedgerEntry."FA Posting Date" + 1);
        EXIT(FALedgerEntry."FA Posting Date");

    end;

    local procedure "YVS IsDepreciationTypeEntry"(DeprBookCode: Code[10]; FAPostingType: Option): Boolean
    var
        FAPostingTypeSetup: Record 5604;
    begin
        FAPostingTypeSetup.GET(DeprBookCode, FAPostingType);
        EXIT(FAPostingTypeSetup."Depreciation Type");
    end;

    [IntegrationEvent(false, false)]
    local procedure "YVS OnAfterCalcDepreciation"(DeprBookCode: Code[10]; var Depreciation: Decimal; BookValue: Decimal)
    begin
    end;
}


