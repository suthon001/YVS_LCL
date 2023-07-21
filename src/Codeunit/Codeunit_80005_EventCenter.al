/// <summary>
/// Codeunit YVS EventFunction (ID 80005).
/// </summary>
codeunit 80005 "YVS EventFunction"
{
    Permissions = TableData "G/L Entry" = rimd;
    [EventSubscriber(ObjectType::Table, Database::"FA Depreciation Book", 'OnBeforeValidateNoOfDepreYears', '', false, false)]
    local procedure OnBeforeValidateNoOfDepreYears(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"FA Depreciation Book", 'OnBeforeModifyFADeprBook', '', false, false)]
    local procedure OnBeforeModifyFADeprBook(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Payment Journal", 'OnAfterValidateEvent', 'AppliesToDocNo', false, false)]
    local procedure AppliesToDocNo(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line")
    begin

        if rec."Applies-to Doc. No." <> xRec."Applies-to Doc. No." then
            if (rec."Applies-to Doc. No." <> '') and (rec."Account Type" = rec."Account Type"::Vendor) then
                InsertWHTCertificate(Rec, rec."Applies-to Doc. No.");


    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Apply", 'OnApplyVendorLedgerEntryOnBeforeModify', '', false, false)]
    local procedure OnApplyVendorLedgerEntryOnBeforeModify(var GenJournalLine: Record "Gen. Journal Line")
    var
        VendLdgEntry: Record "Vendor Ledger Entry";
        InvoiceNo: Text;
    begin
        if GenJournalLine."Document No." <> '' then begin

            VendLdgEntry.reset();
            VendLdgEntry.SetRange("Vendor No.", GenJournalLine."Account No.");
            VendLdgEntry.SetRange("Applies-to ID", GenJournalLine."Document No.");
            if VendLdgEntry.FindSet() then begin
                repeat
                    if StrPos(InvoiceNO, VendLdgEntry."Document No.") = 0 then begin
                        if InvoiceNO <> '' then
                            InvoiceNO := InvoiceNO + '|';
                        InvoiceNO := InvoiceNO + VendLdgEntry."Document No.";
                    end;
                until VendLdgEntry.Next() = 0;
                InsertWHTCertificate(GenJournalLine, InvoiceNo);
            end;
        end;
    end;

    /// <summary>
    /// InsertWHTCertificate.
    /// </summary>
    /// <param name="rec">VAR Record "Gen. Journal Line".</param>
    /// <param name="pInvoiceNo">text.</param>
    procedure InsertWHTCertificate(var rec: Record "Gen. Journal Line"; pInvoiceNo: text)
    var
        GeneralSetup: Record "General Ledger Setup";
        ltGenJournalLine: Record "Gen. Journal Line";
        WHTHeader: Record "YVS WHT Header";
        NosMgt: Codeunit NoSeriesManagement;
        Vendor: Record Vendor;
        WHTBusiness: Record "YVS WHT Business Posting Group";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ltWHTAppliedEntry: Record "YVS WHT Applied Entry";
        ltWHTEntry: Record "YVS WHT Line";
        ltLineNo: Integer;

    begin


        ltWHTAppliedEntry.reset();
        ltWHTAppliedEntry.SetFilter("Document No.", pInvoiceNo);
        if ltWHTAppliedEntry.FindFirst() then begin
            GeneralSetup.GET();
            GeneralSetup.TESTFIELD("YVS WHT Document Nos.");
            IF Rec."YVS WHT Document No." = '' THEN BEGIN
                WHTHeader.reset();
                WHTHeader.setrange("Gen. Journal Template Code", Rec."Journal Template Name");
                WHTHeader.setrange("Gen. Journal Batch Code", Rec."Journal Batch Name");
                WHTHeader.setrange("Gen. Journal Document No.", Rec."Document No.");
                if WHTHeader.FindFirst() then begin
                    if ltGenJournalLine.GET(WHTHeader."Gen. Journal Template Code", WHTHeader."Gen. Journal Batch Code", WHTHeader."Gen. Journal Line No.") then
                        ltGenJournalLine.Delete(true);
                    WHTHeader.DeleteAll();
                end;

                Vendor.GET(rec."Account No.");
                WHTBusiness.GET(ltWHTAppliedEntry."WHT Bus. Posting Group");
                WHTBusiness.TestField("WHT Certificate No. Series");
                WHTBusiness.TESTfield("WHT Account No.");


                WHTHeader.INIT();
                WHTHeader."WHT No." := NosMgt.GetNextNo(GeneralSetup."YVS WHT Document Nos.", Rec."Posting Date", TRUE);
                WHTHeader."No. Series" := GeneralSetup."YVS WHT Document Nos.";
                WHTHeader."Gen. Journal Template Code" := Rec."Journal Template Name";
                WHTHeader."Gen. Journal Batch Code" := Rec."Journal Batch Name";
                WHTHeader."Gen. Journal Document No." := Rec."Document No.";
                WHTHeader."WHT Date" := Rec."Document Date";
                WHTHeader."WHT Source Type" := WHTHeader."WHT Source Type"::Vendor;
                WHTHeader.validate("WHT Source No.", Vendor."No.");
                WHTHeader.INSERT();

                WHTHeader."WHT Type" := WHTBusiness."WHT Type";
                WHTheader."WHT Certificate No." := NoSeriesMgt.GetNextNo(WHTBusiness."WHT Certificate No. Series", WorkDate(), true);
                WHTHeader."WHT Option" := ltWHTAppliedEntry."WHT Option";
                if ltWHTAppliedEntry."WHT Bus. Posting Group" <> '' then
                    WHTHeader."WHT Business Posting Group" := ltWHTAppliedEntry."WHT Bus. Posting Group";
                OnbeforModifyWHTHeader(ltWHTAppliedEntry, WHTHeader, rec);
                WHTHeader.Modify();


                ltWHTEntry.reset();
                ltWHTEntry.SetRange("WHT No.", WHTHeader."WHT No.");
                ltWHTEntry.DeleteAll();

                ltWHTAppliedEntry.reset();
                ltWHTAppliedEntry.SetFilter("Document No.", pInvoiceNo);
                if ltWHTAppliedEntry.FindSet() then begin
                    repeat
                        ltWHTEntry.reset();
                        ltWHTEntry.SetRange("WHT No.", WHTHeader."WHT No.");
                        ltWHTEntry.SetRange("WHT Business Posting Group", ltWHTAppliedEntry."WHT Bus. Posting Group");
                        ltWHTEntry.SetRange("WHT Product Posting Group", ltWHTAppliedEntry."WHT Prod. Posting Group");
                        if not ltWHTEntry.FindFirst() then begin
                            ltLineNo := ltLineNo + 10000;
                            ltWHTEntry.init();
                            ltWHTEntry."WHT No." := WHTHeader."WHT No.";
                            ltWHTEntry."WHT Line No." := ltLineNo;
                            ltWHTEntry."WHT Certificate No." := WHTHeader."WHT Certificate No.";
                            ltWHTEntry."WHT Date" := WHTHeader."WHT Date";
                            ltWHTEntry.validate("WHT Business Posting Group", ltWHTAppliedEntry."WHT Bus. Posting Group");
                            ltWHTEntry.validate("WHT Product Posting Group", ltWHTAppliedEntry."WHT Prod. Posting Group");
                            ltWHTEntry."WHT Base" := ltWHTAppliedEntry."WHT Base";
                            ltWHTEntry."WHT %" := ltWHTAppliedEntry."WHT %";
                            ltWHTEntry."WHT Amount" := ltWHTAppliedEntry."WHT Amount";
                            ltWHTEntry."WHT Name" := ltWHTAppliedEntry."WHT Name";
                            ltWHTEntry."WHT Post Code" := ltWHTAppliedEntry."WHT Post Code";
                            OnbeforInsertWHTLine(ltWHTAppliedEntry, WHTHeader, rec, ltWHTEntry);
                            ltWHTEntry.Insert();
                        end else begin
                            ltWHTEntry."WHT Amount" := ltWHTEntry."WHT Amount" + ltWHTAppliedEntry."WHT Amount";
                            ltWHTEntry."WHT Base" := ltWHTEntry."WHT Base" + ltWHTAppliedEntry."WHT Base";
                            ltWHTEntry.Modify();
                        end;
                    until ltWHTAppliedEntry.Next() = 0;
                    CreateWHTCertificate(WHTHeader, rec);
                end;

            end;
        end;
    end;

    /// <summary>
    /// CreateWHTCertificate.
    /// </summary>
    /// <param name="rec">VAR WHTHeader "YVS WHT Header".</param>
    /// <param name="pGenJournalLine">Record "Gen. Journal Line".</param>
    procedure CreateWHTCertificate(var WHTHeader: Record "YVS WHT Header"; pGenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
        CurrLine: Integer;
        LastLine: Integer;
        WHTSetup: Record "YVS WHT Business Posting Group";
        WHTEntry: Record "YVS WHT Line";
        SumAmt: Decimal;
    begin
        if WHTHeader."WHT Certificate No." <> '' then begin
            WHTHeader.TESTfield("WHT Business Posting Group");

            Clear(CurrLine);

            GenJnlLine.RESET();
            GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
            GenJnlLine.SETRANGE("Journal Template Name", pGenJournalLine."Journal Template Name");
            GenJnlLine.SETRANGE("Journal Batch Name", pGenJournalLine."Journal Batch Name");
            GenJnlLine.SETRANGE("Document No.", pGenJournalLine."Document No.");
            GenJnlLine.setrange("Account Type", GenJnlLine."Account Type"::Vendor);
            IF GenJnlLine.FindLast() THEN
                CurrLine := GenJnlLine."Line No.";



            WHTSetup.GET(WHTHeader."WHT Business Posting Group");
            WHTSetup.TESTfield("WHT Account No.");

            GenJnlLine.RESET();
            GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
            GenJnlLine.SETRANGE("Journal Template Name", pGenJournalLine."Journal Template Name");
            GenJnlLine.SETRANGE("Journal Batch Name", pGenJournalLine."Journal Batch Name");
            GenJnlLine.SETRANGE("Document No.", pGenJournalLine."Document No.");
            GenJnlLine.SETFILTER("Line No.", '>%1', CurrLine);
            IF GenJnlLine.FindFirst() THEN
                LastLine := GenJnlLine."Line No.";
            IF LastLine = 0 THEN
                CurrLine += 10000
            ELSE
                CurrLine := ROUND((CurrLine + LastLine) / 2, 1);
            GenJnlLine.INIT();
            GenJnlLine."Journal Template Name" := WHTHeader."Gen. Journal Template Code";
            GenJnlLine."Journal Batch Name" := WHTHeader."Gen. Journal Batch Code";
            GenJnlLine."Source Code" := pGenJournalLine."Source Code";
            GenJnlLine."Line No." := CurrLine;
            GenJnlLine.INSERT();
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.", WHTSetup."WHT Account No.");
            GenJnlLine."Posting Date" := pGenJournalLine."Posting Date";
            GenJnlLine."Document Date" := WHTHeader."WHT Date";
            GenJnlLine."Document Type" := pGenJournalLine."Document Type";
            GenJnlLine."Document No." := pGenJournalLine."Document No.";
            GenJnlLine."External Document No." := WHTHeader."WHT Certificate No.";
            GenJnlLine."YVS WHT Document No." := WHTHeader."WHT No.";

            WHTEntry.RESET();
            WHTEntry.SETRANGE("WHT No.", WHTHeader."WHT No.");
            WHTEntry.CalcSums("WHT Amount");
            SumAmt := WHTEntry."WHT Amount";
            GenJnlLine.Validate(Amount, -SumAmt);
            OnbeformodifyCreateWHTCertificate(WHTHeader, GenJnlLine);
            GenJnlLine.MODIFY();
            WHTHeader."Gen. Journal Line No." := CurrLine;
            WHTHeader."Gen. Journal Document No." := GenJnlLine."Document No.";
            WHTHeader.MODIFY();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', true, true)]
    local procedure "OnAfterSubstituteReport"(ReportId: Integer; var NewReportId: Integer)
    begin
        if ReportId = 4 then
            NewReportId := 80050;
        if ReportId = 6 then
            NewReportId := 80051;
        if ReportId = 104 then
            NewReportId := 80052;
        if ReportId = 105 then
            NewReportId := 80053;
        if ReportId = 111 then
            NewReportId := 80054;
        if ReportId = 120 then
            NewReportId := 80055;
        if ReportId = 121 then
            NewReportId := 80056;
        if ReportId = 129 then
            NewReportId := 80057;
        if ReportId = 5601 then
            NewReportId := 80058;
        if ReportId = 5605 then
            NewReportId := 80059;
        if ReportId = 322 then
            NewReportId := 80060;
        if ReportId = 321 then
            NewReportId := 80061;
        if ReportId = 329 then
            NewReportId := 80062;
        if ReportId = 304 then
            NewReportId := 80063;
        if ReportId = REPORT::"Customer - List" then
            NewReportId := 80064;
        if ReportId = REPORT::"Customer - Order Detail" then
            NewReportId := 80065;
        if ReportId = REPORT::"Customer - Order Summary" then
            NewReportId := 80066;
        if ReportId = REPORT::"Customer/Item Sales" then
            NewReportId := 80067;
        if ReportId = REPORT::"Inventory - Customer Sales" then
            NewReportId := 80068;
        if ReportId = REPORT::"Bank Acc. - Detail Trial Bal." then
            NewReportId := 80069;
        if ReportId = REPORT::"Inventory - Vendor Purchases" then
            NewReportId := 80070;
        if ReportId = 1001 then
            NewReportId := 80071;
        if ReportId = 112 then
            NewReportId := 80072;
        if ReportId = 712 then
            NewReportId := 80073;
        if ReportId = 704 then
            NewReportId := 80074;
        if ReportId = 708 then
            NewReportId := 80075;
        if ReportId = report::"Calculate Depreciation" then
            NewReportId := REPORT::"YVS Calculate Depreciation";
        if ReportId = report::"Inventory - List" then
            NewReportId := REPORT::"YVS Inventory - List";


    end;

    /// <summary>
    /// SalesPreviewVourcher.
    /// </summary>
    /// <param name="SalesHeader">Record "Sales Header".</param>
    /// <param name="TemporaryGL">Temporary VAR Record "G/L Entry".</param>
    procedure "SalesPreviewVourcher"(SalesHeader: Record "Sales Header"; var TemporaryGL: Record "G/L Entry" temporary)
    var
        RecRef: RecordRef;
        TempErrorMessage: Record "Error Message" temporary;
    begin
        ErrorMessageMgt.Activate(ErrorMessageHandler);
        BindSubscription(SalesPostYesNo);
        GenJnlPostPreview.SetContext(SalesPostYesNo, SalesHeader);
        IF NOT GenJnlPostPreview.Run() AND GenJnlPostPreview.IsSuccess() THEN begin
            GenJnlPostPreview.GetPreviewHandler(PostingPreviewEventHandler);
            PostingPreviewEventHandler.GetEntries(Database::"G/L Entry", RecRef);
            InsertToTempGL(RecRef, TemporaryGL);
        end;
        if ErrorMessageMgt.GetErrors(TempErrorMessage) then
            ERROR(TempErrorMessage.Message);
    end;

    /// <summary> 
    /// Description for PurchasePreviewVourcher.
    /// </summary>
    /// <param name="PurchaseHeader">Parameter of type Record "Purchase Header".</param>
    /// <param name="TemporaryGL">Parameter of type Record "G/L Entry" temporary.</param>
    procedure "PurchasePreviewVourcher"(PurchaseHeader: Record "Purchase Header"; var TemporaryGL: Record "G/L Entry" temporary)
    var
        RecRef: RecordRef;
        TempErrorMessage: Record "Error Message" temporary;
    begin
        ErrorMessageMgt.Activate(ErrorMessageHandler);
        BindSubscription(PurchasePostYesNo);
        GenJnlPostPreview.SetContext(PurchasePostYesNo, PurchaseHeader);
        IF NOT GenJnlPostPreview.Run() AND GenJnlPostPreview.IsSuccess() THEN begin
            GenJnlPostPreview.GetPreviewHandler(PostingPreviewEventHandler);
            PostingPreviewEventHandler.GetEntries(Database::"G/L Entry", RecRef);
            InsertToTempGL(RecRef, TemporaryGL);

        end;
        if ErrorMessageMgt.GetErrors(TempErrorMessage) then
            ERROR(TempErrorMessage.Message);
    end;

    /// <summary> 
    /// Description for GenLinePreviewVourcher.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="TemporaryGL">Parameter of type Record "G/L Entry" temporary.</param>
    procedure "GenLinePreviewVourcher"(GenJournalLine: Record "Gen. Journal Line"; var TemporaryGL: Record "G/L Entry" temporary)
    var
        RecRef: RecordRef;
        TempErrorMessage: Record "Error Message" temporary;
    begin

        ErrorMessageMgt.Activate(ErrorMessageHandler);
        BindSubscription(GenJnlPost);
        GenJnlPostPreview.SetContext(GenJnlPost, GenJournalLine);
        IF NOT GenJnlPostPreview.Run() AND GenJnlPostPreview.IsSuccess() THEN begin
            GenJnlPostPreview.GetPreviewHandler(PostingPreviewEventHandler);
            PostingPreviewEventHandler.GetEntries(Database::"G/L Entry", RecRef);
            InsertToTempGL(RecRef, TemporaryGL);
        end;
        if ErrorMessageMgt.GetErrors(TempErrorMessage) then
            ERROR(TempErrorMessage.Message);
    end;

    /// <summary> 
    /// Description for InsertToTempGL.
    /// </summary>
    /// <param name="RecRef2">Parameter of type RecordRef.</param>
    /// <param name="TempGLEntry">Parameter of type Record "G/L Entry" temporary.</param>
    local procedure InsertToTempGL(RecRef2: RecordRef; var TempGLEntry: Record "G/L Entry" temporary)
    begin
        if NOT TempGLEntry.IsTemporary then
            Error('GL Entry must be Temporary Table!');
        TempGLEntry.reset();
        TempGLEntry.DeleteAll();
        if RecRef2.FindSet() then
            repeat
                RecRef2.SetTable(TempGLEntry);
                TempGLEntry.Insert();

            until RecRef2.next() = 0;
    end;


    [IntegrationEvent(true, false)]
    procedure OnbeforInsertWHTLine(WhtApplyLine: Record "YVS WHT Applied Entry"; WHTHeader: Record "YVS WHT Header"; GenLine: Record "Gen. Journal Line"; var WHTLine: Record "YVS WHT Line")
    begin

    end;

    [IntegrationEvent(true, false)]
    procedure OnbeforModifyWHTHeader(WhtApplyLine: Record "YVS WHT Applied Entry"; var WHTHeader: Record "YVS WHT Header"; GenLine: Record "Gen. Journal Line")
    begin

    end;

    [IntegrationEvent(true, false)]
    procedure OnbeformodifyCreateWHTCertificate(WHTHeader: Record "YVS WHT Header"; var GenLine: Record "Gen. Journal Line")
    begin

    end;



    var
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        SalesPostYesNo: Codeunit "Sales-Post (Yes/No)";
        PurchasePostYesNo: Codeunit "Purch.-Post (Yes/No)";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        PostingPreviewEventHandler: Codeunit "Posting Preview Event Handler";
        ErrorMessageMgt: Codeunit "Error Message Management";
        ErrorMessageHandler: Codeunit "Error Message Handler";
        BillingReceiptCatLbl: Label 'BILLINGRECEIPT';
        WFMngt: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        SendBillingReceiptReqLbl: Label 'Approval Request for Billing Receipt is requested';
        CancelReqBillingReceiptLbl: Label 'Approval of a Billing Receipt is canceled';
        BillingReceiptConditionTxt: Label '<?xml version = "1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="YVS Billing Receipt Header">%1</DataItem><DataItem name="YVS Billing Receipt Line">%2</DataItem></DataItems></ReportParameters>', Locked = true;

}