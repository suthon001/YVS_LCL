/// <summary>
/// Codeunit YVS Journal Function (ID 80000).
/// </summary>
codeunit 80000 "YVS Journal Function"
{
    EventSubscriberInstance = StaticAutomatic;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnProcessLinesOnAfterPostGenJnlLines', '', true, true)]
    /// <summary> 
    /// Description for InsertPostedGenLine.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    local procedure "OnProcessLinesOnAfterPostGenJnlLines"(var GenJournalLine: Record "Gen. Journal Line"; PreviewMode: Boolean)
    var
        WHTHeader: Record "YVS WHT Header";
        WHTLines: Record "YVS WHT Line";
        BillingHeader: Record "YVS Billing Receipt Header";
        GenJnlLine2, GenJnlLine3 : Record "Gen. Journal Line";
        WHTAppEntry: Record "YVS WHT Applied Entry";
        GenJournalTemplate: Record "Gen. Journal Template";
        LastLineNo: Integer;
    begin
        if not PreviewMode then begin
            if not GenJournalTemplate.GET(GenJournalLine."Journal Template Name") then
                GenJournalLine.Init();
            GenJnlLine2.reset();
            GenJnlLine2.Copy(GenJournalLine);
            GenJnlLine2.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
            GenJnlLine2.SetFilter("Account No.", '<>%1', '');
            GenJnlLine2.SetFilter("YVS WHT Document No.", '<>%1', '');
            if GenJnlLine2.FindSet() then
                repeat

                    WHTHeader.reset();
                    WHTHeader.setrange("WHT No.", GenJnlLine2."YVS WHT Document No.");
                    if WHTHeader.FindFirst() then begin
                        WHTHeader."Posted" := true;
                        WHTHeader.Modify();

                        LastLineNo := 0;
                        OnBeforInsertWHTAPPLYGL();
                        WHTLines.reset();
                        WHTLines.SetRange("WHT No.", WHTHeader."WHT No.");
                        WHTLines.SetFilter("WHT Product Posting Group", '<>%1', '');
                        if WHTLines.FindSet() then
                            repeat
                                LastLineNo := LastLineNo + 10000;
                                WHTAppEntry.init();
                                WHTAppEntry."Document No." := GenJnlLine2."Document No.";
                                WHTAppEntry."Document Line No." := WHTLines."WHT Line No.";
                                WHTAppEntry."Entry Type" := WHTAppEntry."Entry Type"::Applied;
                                WHTAppEntry."Line No." := LastLineNo;
                                WHTAppEntry."WHT Bus. Posting Group" := WHTLines."WHT Business Posting Group";
                                WHTAppEntry."WHT Prod. Posting Group" := WHTLines."WHT Product Posting Group";
                                WHTAppEntry.Description := copystr(WHTLines.Description, 1, 100);
                                WHTAppEntry."WHT %" := WHTLines."WHT %";
                                WHTAppEntry."WHT Base" := WHTLines."WHT Base";
                                WHTAppEntry."WHT Amount" := WHTLines."WHT Amount";
                                WHTAppEntry."WHT Name" := COPYSTR(WHTHeader."WHT Name", 1, 100);
                                WHTAppEntry."WHT Name 2" := WHTHeader."WHT Name 2";
                                WHTAppEntry."WHT Address" := WHTHeader."WHT Address";
                                WHTAppEntry."WHT Address 2" := WHTHeader."WHT Address 2";
                                WHTAppEntry."WHT City" := COPYSTR(WHTHeader."WHT City", 1, 30);
                                WHTAppEntry."VAT Registration No." := WHTHeader."VAT Registration No.";
                                WHTAppEntry."WHT Option" := WHTHeader."WHT Option";
                                WHTAppEntry."VAT Branch Code" := WHTHeader."VAT Branch Code";
                                WHTAppEntry."Head Office" := WHTHeader."Head Office";
                                WHTAppEntry."WHT Post Code" := WHTHeader."Wht Post Code";
                                if GenJournalTemplate.Type = GenJournalTemplate.Type::Payments then
                                    WHTAppEntry."WHT Document Type" := WHTAppEntry."WHT Document Type"::Payment;
                                if GenJournalTemplate.Type = GenJournalTemplate.Type::"Cash Receipts" then
                                    WHTAppEntry."WHT Document Type" := WHTAppEntry."WHT Document Type"::"Cash Receipt";
                                WHTAppEntry.Insert(true);
                            until WHTLines.Next() = 0;
                    end;
                until GenJnlLine2.Next() = 0;
            GenJnlLine3.reset();
            GenJnlLine3.Copy(GenJournalLine);
            GenJnlLine3.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
            GenJnlLine3.SetFilter("Account No.", '<>%1', '');
            GenJnlLine3.SetFilter("YVS Ref. Billing & Receipt No.", '<>%1', '');
            if GenJnlLine3.FindSet() then
                repeat
                    BillingHeader.reset();
                    BillingHeader.SetRange("No.", GenJnlLine3."YVS Ref. Billing & Receipt No.");
                    if BillingHeader.FindFirst() then begin
                        BillingHeader."Status" := BillingHeader."Status"::Posted;
                        BillingHeader."Journal Document No." := GenJnlLine3."Document No.";
                        BillingHeader.Modify();
                    end;
                until GenJnlLine3.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeaderPrepmt', '', true, true)]
    local procedure "YVS CopyHeaderFromPropmtInvoiceBuff"(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin

        GenJournalLine."YVS Head Office" := SalesHeader."YVS Head Office";
        GenJournalLine."YVS VAT Branch Code" := SalesHeader."YVS VAT Branch Code";
        GenJournalLine."YVS Tax Invoice No." := SalesHeader."No.";
        GenJournalLine."VAT Registration No." := SalesHeader."VAT Registration No.";
        GenJournalLine."Document Date" := SalesHeader."Document Date";
        GenJournalLine."YVS Tax Invoice Date" := SalesHeader."Posting Date";
        GenJournalLine."YVS Tax Invoice Name" := SalesHeader."Sell-to Customer Name";
        GenJournalLine."YVS Tax Invoice Name 2" := SalesHeader."Sell-to Customer Name 2";

    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPrepmtInvBuffer', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromPrepmtInvBuffer(PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        if PrepmtInvLineBuffer."YVS Tax Invoice No." <> '' then
            GenJournalLine."YVS Tax Invoice No." := PrepmtInvLineBuffer."YVS Tax Invoice No.";
        GenJournalLine."VAT Registration No." := PrepmtInvLineBuffer."YVS Vat Registration No.";
        GenJournalLine."YVS Tax Invoice Name" := PrepmtInvLineBuffer."YVS Tax Invoice Name";
        GenJournalLine."YVS Tax Invoice Name 2" := PrepmtInvLineBuffer."YVS Tax Invoice Name 2";
        GenJournalLine."YVS VAT Branch Code" := PrepmtInvLineBuffer."YVS VAT Branch Code";
        GenJournalLine."YVS Head Office" := PrepmtInvLineBuffer."YVS Head Office";
        GenJournalLine."YVS Tax Invoice Base" := PrepmtInvLineBuffer."YVS Tax Invoice Base";
        GenJournalLine."YVS Tax Invoice Amount" := PrepmtInvLineBuffer."YVS Tax Invoice Amount";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Prepayment Inv. Line Buffer", 'OnAfterCopyFromSalesLine', '', false, false)]
    local procedure OnAfterCopyFromSalesLine(SalesLine: Record "Sales Line"; var PrepaymentInvLineBuffer: Record "Prepayment Inv. Line Buffer")
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
        PrepaymentInvLineBuffer."YVS Tax Invoice No." := SalesHeader."Prepayment No.";
        PrepaymentInvLineBuffer."YVS Tax Invoice Name" := SalesHeader."Sell-to Customer Name";
        PrepaymentInvLineBuffer."YVS Tax Invoice Name 2" := SalesHeader."Sell-to Customer Name 2";
        PrepaymentInvLineBuffer."YVS Vat Registration No." := SalesHeader."VAT Registration No.";
        PrepaymentInvLineBuffer."YVS VAT Branch Code" := SalesHeader."YVS VAT Branch Code";
        PrepaymentInvLineBuffer."YVS Head Office" := SalesHeader."YVS Head Office";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Prepayment Inv. Line Buffer", 'OnAfterCopyFromPurchLine', '', false, false)]
    local procedure OnAfterCopyFromPurchLine(PurchaseLine: Record "Purchase Line"; var PrepaymentInvLineBuffer: Record "Prepayment Inv. Line Buffer")
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");
        PrepaymentInvLineBuffer."YVS Tax Invoice No." := PurchHeader."Prepayment No.";
        PrepaymentInvLineBuffer."YVS Tax Invoice Name" := PurchHeader."Buy-from Vendor Name";
        PrepaymentInvLineBuffer."YVS Tax Invoice Name 2" := PurchHeader."Buy-from Vendor Name 2";
        PrepaymentInvLineBuffer."YVS Vat Registration No." := PurchHeader."VAT Registration No.";
        PrepaymentInvLineBuffer."YVS VAT Branch Code" := PurchHeader."YVS VAT Branch Code";
        PrepaymentInvLineBuffer."YVS Head Office" := PurchHeader."YVS Head Office";
        PrepaymentInvLineBuffer."YVS Tax Invoice Base" := PurchaseLine.Amount;
        PrepaymentInvLineBuffer."YVS Tax Invoice Amount" := PurchaseLine."Amount Including VAT" - PurchaseLine.Amount;
        if PurchaseLine."YVS Tax Invoice No." <> '' then begin
            PrepaymentInvLineBuffer."YVS Tax Invoice No." := PurchaseLine."YVS Tax Invoice No.";
            PrepaymentInvLineBuffer."YVS Tax Invoice Name" := PurchaseLine."YVS Tax Invoice Name";
            PrepaymentInvLineBuffer."YVS Tax Invoice Name 2" := PurchaseLine."YVS Tax Invoice Name 2";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertPostUnrealVATEntry', '', true, true)]
    /// <summary> 
    /// Description for PostUnrealVatEntry.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="VATEntry">Parameter of type Record "VAT Entry".</param>
    local procedure "PostUnrealVatEntry"(GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry")
    begin
        VATEntry."YVS Tax Invoice Base" := VATEntry.Base;
        VATEntry."YVS Tax Invoice Amount" := VATEntry.Amount;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnAfterCopyToGenJnlLine', '', true, true)]
    /// <summary> 
    /// Description for CopyHeaderFromInvoiceBuff.
    /// </summary>
    local procedure "CopyHeaderFromInvoiceBuff"(InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; var GenJnlLine: Record "Gen. Journal Line")
    begin

        GenJnlLine."YVS Tax Invoice No." := InvoicePostingBuffer."YVS Tax Invoice No.";
        GenJnlLine."YVS Tax Invoice Date" := InvoicePostingBuffer."YVS Tax Invoice Date";
        GenJnlLine."YVS Tax Invoice Base" := InvoicePostingBuffer."YVS Tax Invoice Base";
        GenJnlLine."YVS Tax Invoice Amount" := InvoicePostingBuffer."YVS Tax Invoice Amount";
        GenJnlLine."YVS Tax Vendor No." := InvoicePostingBuffer."YVS Tax Vendor No.";
        GenJnlLine."YVS Tax Invoice Name" := InvoicePostingBuffer."YVS Tax Invoice Name";
        GenJnlLine."YVS Tax Invoice Name 2" := InvoicePostingBuffer."YVS Tax Invoice Name 2";
        GenJnlLine."YVS Tax Invoice Address" := InvoicePostingBuffer."YVS Address";
        GenJnlLine."YVS Tax Invoice Address 2" := InvoicePostingBuffer."YVS Address 2";
        GenJnlLine."YVS Head Office" := InvoicePostingBuffer."YVS Head Office";
        GenJnlLine."YVS VAT Branch Code" := InvoicePostingBuffer."YVS VAT Branch Code";
        GenJnlLine."VAT Registration No." := InvoicePostingBuffer."YVS VAT Registration No.";
        GenJnlLine."YVS Description Line" := InvoicePostingBuffer."YVS Description Line";
        GenJnlLine."YVS Tax Invoice Address" := InvoicePostingBuffer."YVS Address";
        GenJnlLine."YVS Tax Invoice City" := InvoicePostingBuffer."YVS City";
        GenJnlLine."YVS Tax Invoice Post Code" := InvoicePostingBuffer."YVS Post Code";
        GenJnlLine."YVS Document Line No." := InvoicePostingBuffer."YVS Document Line No.";
        "YVS AfterCopyInvoicePostingBufferToGL"(GenJnlLine, InvoicePostingBuffer);


    end;


    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterCopyToGenJnlLine', '', true, true)]
    /// <summary> 
    /// Description for CopyHeaderFromInvoiceBuff.
    /// </summary>
    local procedure OnAfterCopyToGenJnlLine(InvoicePostBuffer: Record "Invoice Post. Buffer" temporary; var GenJnlLine: Record "Gen. Journal Line")
    begin
        // with GenJournalLine do begin
        GenJnlLine."YVS Tax Invoice No." := InvoicePostBuffer."YVS Tax Invoice No.";
        GenJnlLine."YVS Tax Invoice Date" := InvoicePostBuffer."YVS Tax Invoice Date";
        GenJnlLine."YVS Tax Invoice Base" := InvoicePostBuffer."YVS Tax Invoice Base";
        GenJnlLine."YVS Tax Invoice Amount" := InvoicePostBuffer."YVS Tax Invoice Amount";
        GenJnlLine."YVS Tax Vendor No." := InvoicePostBuffer."YVS Tax Vendor No.";
        GenJnlLine."YVS Tax Invoice Name" := InvoicePostBuffer."YVS Tax Invoice Name";
        GenJnlLine."YVS Tax Invoice Name 2" := InvoicePostBuffer."YVS Tax Invoice Name 2";
        GenJnlLine."YVS Tax Invoice Address" := InvoicePostBuffer."YVS Address";
        GenJnlLine."YVS Tax Invoice Address 2" := InvoicePostBuffer."YVS Address 2";
        GenJnlLine."YVS Head Office" := InvoicePostBuffer."YVS Head Office";
        GenJnlLine."YVS VAT Branch Code" := InvoicePostBuffer."YVS VAT Branch Code";
        GenJnlLine."VAT Registration No." := InvoicePostBuffer."YVS VAT Registration No.";
        GenJnlLine."YVS Description Line" := InvoicePostBuffer."YVS Description Line";
        GenJnlLine."YVS Tax Invoice Address" := InvoicePostBuffer."YVS Address";
        GenJnlLine."YVS Tax Invoice City" := InvoicePostBuffer."YVS City";
        GenJnlLine."YVS Tax Invoice Post Code" := InvoicePostBuffer."YVS Post Code";
        GenJnlLine."YVS Document Line No." := InvoicePostBuffer."YVS Document Line No.";
        "YVS AfterCopyInvoicePostBufferToGL"(GenJnlLine, InvoicePostBuffer);
        // end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Entry", 'OnAfterCopyFromGenJnlLine', '', true, true)]
    /// <summary> 
    /// Description for CopyVatFromGenLine.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="VATEntry">Parameter of type Record "VAT Entry".</param>
    local procedure "CopyVatFromGenLine"(GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry")
    var
        VATProPostingGroup: Record "VAT Product Posting Group";
    begin

        VATEntry."YVS Head Office" := GenJournalLine."YVS Head Office";
        VATEntry."YVS VAT Branch Code" := GenJournalLine."YVS VAT Branch Code";
        VATEntry."YVS Tax Invoice No." := GenJournalLine."YVS Tax Invoice No.";
        VATEntry."YVS Tax Invoice Name" := GenJournalLine."YVS Tax Invoice Name";
        VATEntry."YVS Tax Invoice Name 2" := GenJournalLine."YVS Tax Invoice Name 2";
        VATEntry."YVS Tax Vendor No." := GenJournalLine."YVS Tax Vendor No.";
        VATEntry."YVS Tax Invoice Base" := GenJournalLine."YVS Tax Invoice Base";
        VATEntry."YVS Tax Invoice Date" := GenJournalLine."YVS Tax Invoice Date";
        VATEntry."YVS Tax Invoice Amount" := GenJournalLine."YVS Tax Invoice Amount";
        VATEntry."VAT Registration No." := GenJournalLine."VAT Registration No.";
        VATEntry."YVS Tax Invoice Address" := GenJournalLine."YVS Tax Invoice Address";
        VATEntry."YVS Tax Invoice Address 2" := GenJournalLine."YVS Tax Invoice Address 2";
        VATEntry."YVS Tax Invoice City" := GenJournalLine."YVS Tax Invoice City";
        VATEntry."YVS Tax Invoice Post Code" := GenJournalLine."YVS Tax Invoice Post Code";
        VATEntry."External Document No." := GenJournalLine."External Document No.";
        if GenJournalLine."YVS Document Line No." <> 0 then
            VATEntry."YVS Document Line No." := GenJournalLine."YVS Document Line No."
        else
            VATEntry."YVS Document Line No." := GenJournalLine."Line No.";

        if NOT VATProPostingGroup.get(VATEntry."VAT Prod. Posting Group") then
            VATProPostingGroup.init();
        IF VATProPostingGroup."YVS Direct VAT" then begin
            VATEntry.Base := VATEntry."YVS Tax Invoice Base";
            VATEntry.Amount := VATEntry."YVS Tax Invoice Amount";
        end ELSE BEGIN
            VATEntry."YVS Tax Invoice Base" := VATEntry.Base;
            VATEntry."YVS Tax Invoice Amount" := VATEntry.Amount;
        END;
        "YVS AfterCopyGenLineToVatEntry"(VATEntry, GenJournalLine);
    end;




    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', true, true)]
    /// <summary> 
    /// Description for CopyHeaderFromPurchaseHeader.
    /// </summary>
    /// <param name="PurchaseHeader">Parameter of type Record "Purchase Header".</param>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    local procedure "CopyHeaderFromPurchaseHeader"(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    var
        VendCust: Record "YVS Customer & Vendor Branch";
    begin

        GenJournalLine."YVS Description Line" := PurchaseHeader."Posting Description";
        GenJournalLine."YVS Head Office" := PurchaseHeader."YVS Head Office";
        GenJournalLine."YVS VAT Branch Code" := PurchaseHeader."YVS VAT Branch Code";
        if VendCust.Get(VendCust."Source Type"::Vendor, PurchaseHeader."Buy-from Vendor No.", PurchaseHeader."YVS Head Office", PurchaseHeader."YVS VAT Branch Code") then
            if VendCust."Title Name" <> VendCust."Title Name"::" " then
                GenJournalLine."YVS Tax Invoice Name" := format(VendCust."Title Name") + ' ' + VendCust."Name"
            else
                GenJournalLine."YVS Tax Invoice Name" := VendCust."Name";

        if GenJournalLine."YVS Tax Invoice Name" = '' then
            GenJournalLine."YVS Tax Invoice Name" := PurchaseHeader."Pay-to Name";
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo" then
            if PurchaseHeader."Vendor Cr. Memo No." <> '' then
                GenJournalLine."YVS Tax Invoice No." := PurchaseHeader."Vendor Cr. Memo No.";
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then
            if PurchaseHeader."Vendor Cr. Memo No." <> '' then
                GenJournalLine."YVS Tax Invoice No." := PurchaseHeader."Vendor Invoice No.";

        "YVS AfterCopyPuchaseHeaderToGenLine"(GenJournalLine, PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeader', '', true, true)]
    /// <summary> 
    /// Description for CopyHeaderFromSalesHeader.
    /// </summary>
    /// <param name="SalesHeader">Parameter of type Record "Sales Header".</param>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    local procedure "CopyHeaderFromSalesHeader"(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin

        GenJournalLine."YVS Description Line" := SalesHeader."Posting Description";
        GenJournalLine."YVS Head Office" := SalesHeader."YVS Head Office";
        GenJournalLine."YVS VAT Branch Code" := SalesHeader."YVS VAT Branch Code";
        "YVS AfterCopySalesHeaderToGenLine"(GenJournalLine, SalesHeader);

    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Entry", 'OnAfterInsertEvent', '', true, true)]
    /// <summary> 
    /// Description for OnAfterInsertVat.
    /// </summary>
    /// <param name="Rec">Parameter of type Record "VAT Entry".</param>
    /// <param name="RunTrigger">Parameter of type Boolean.</param>
    local procedure "OnAfterInsertVat"(var Rec: Record "VAT Entry"; RunTrigger: Boolean)
    var
        VATEntryReport: Record "YVS VAT Transections";
    begin
        if rec.IsTemporary then
            exit;

        VATEntryReport.INIT();
        VATEntryReport.TRANSFERFIELDS(Rec);
        if VATEntryReport.Insert() then;

    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    /// <summary> 
    /// Description for AfterCopyGLEntryFromGenJnlLine.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="GLEntry">Parameter of type Record "G/L Entry".</param>
    local procedure "AfterCopyGLEntryFromGenJnlLine"(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
        GLEntry."YVS Journal Description" := GenJournalLine."YVS Journal Description";
        if GenJournalLine."YVS Document Line No." <> 0 then
            GLEntry."YVS Document Line No." := GenJournalLine."YVS Document Line No."
        else
            GLEntry."YVS Document Line No." := GenJournalLine."Line No.";

        "YVS AfterCopyGenJournalLineToGLEntry"(GLEntry, GenJournalLine);

    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterSetupNewLine', '', true, true)]
    /// <summary> 
    /// Description for OnsetUpNewLine.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="LastGenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    local procedure "OnsetUpNewLine"(var GenJournalLine: Record "Gen. Journal Line"; LastGenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."Document No." := LastGenJournalLine."Document No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", 'OnAfterCopyFromGenJnlLine', '', true, true)]
    /// <summary> 
    /// Description for AfterCopyFromGen.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="BankAccountLedgerEntry">Parameter of type Record "Bank Account Ledger Entry".</param>
    local procedure "AfterCopyFromGen"(GenJournalLine: Record "Gen. Journal Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
        //   with BankAccountLedgerEntry do begin
        BankAccountLedgerEntry."YVS Bank Branch No." := GenJournalLine."YVS Bank Branch No.";
        BankAccountLedgerEntry."YVS Bank Code" := GenJournalLine."YVS Bank Code";
        BankAccountLedgerEntry."YVS Bank Name" := GenJournalLine."YVS Bank Name";
        BankAccountLedgerEntry."YVS Cheque Name" := GenJournalLine."YVS Pay Name";
        BankAccountLedgerEntry."YVS Cheque No." := GenJournalLine."YVS Cheque No.";
        BankAccountLedgerEntry."YVS Customer/Vendor No." := GenJournalLine."YVS Customer/Vendor No.";
        BankAccountLedgerEntry."YVS Cheque Date" := GenJournalLine."YVS Cheque Date";
        "YVS OnAfterBankAccountLedgerEntryCopyFromGenJnlLine"(BankAccountLedgerEntry, GenJournalLine);
        //  end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostBankAccOnAfterBankAccLedgEntryInsert', '', false, false)]
    local procedure OnPostBankAccOnAfterBankAccLedgEntryInsert(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; BankAccount: Record "Bank Account")
    var
        CheckLedgEntry: Record "Check Ledger Entry";
        NextCheckEntryNo: Integer;
        DocNoMustBeEnteredErr: Label 'Document No. must be entered when Bank Payment Type is %1.', Comment = '%1 - option value';
        CheckAlreadyExistsErr: Label 'Check %1 already exists for this Bank Account.', Comment = '%1 - document no.';
    begin
        if ((GenJournalLine.Amount < 0) and (GenJournalLine."Bank Payment Type" = "Bank Payment Type"::" ") and (GenJournalLine."YVS Cheque No." <> ''))
     then begin
            if GenJournalLine."Document No." = '' then
                Error(DocNoMustBeEnteredErr, GenJournalLine."Bank Payment Type");
            CheckLedgEntry.Reset();
            CheckLedgEntry.LockTable();
            if CheckLedgEntry.FindLast() then
                NextCheckEntryNo := CheckLedgEntry."Entry No." + 1
            else
                NextCheckEntryNo := 1;


            CheckLedgEntry.SetRange("Bank Account No.", GenJournalLine."Account No.");
            CheckLedgEntry.SetFilter(
              "Entry Status", '%1|%2|%3',
              CheckLedgEntry."Entry Status"::Printed,
              CheckLedgEntry."Entry Status"::Posted,
              CheckLedgEntry."Entry Status"::"Financially Voided");
            CheckLedgEntry.SetRange("Check No.", GenJournalLine."Document No.");
            if not CheckLedgEntry.IsEmpty() then
                Error(CheckAlreadyExistsErr, GenJournalLine."Document No.");

            CheckLedgEntry.Init();
            CheckLedgEntry.CopyFromBankAccLedgEntry(BankAccountLedgerEntry);
            CheckLedgEntry."Entry No." := NextCheckEntryNo;

            CheckLedgEntry."Bank Payment Type" := CheckLedgEntry."Bank Payment Type"::"Manual Check";
            if BankAccount."Currency Code" <> '' then
                CheckLedgEntry.Amount := -GenJournalLine.Amount
            else
                CheckLedgEntry.Amount := -GenJournalLine."Amount (LCY)";
            CheckLedgEntry.Insert(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Check Ledger Entry", 'OnAfterCopyFromBankAccLedgEntry', '', TRUE, TRUE)]
    /// <summary> 
    /// Description for CopyFromBankLedger.
    /// </summary>
    /// <param name="BankAccountLedgerEntry">Parameter of type Record "Bank Account Ledger Entry".</param>
    /// <param name="CheckLedgerEntry">Parameter of type Record "Check Ledger Entry".</param>
    local procedure "CopyFromBankLedger"(BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var CheckLedgerEntry: Record "Check Ledger Entry")
    begin
        // with CheckLedgerEntry do begin
        CheckLedgerEntry."Check No." := COPYSTR(BankAccountLedgerEntry."External Document No.", 1, 20);
        CheckLedgerEntry."Check Date" := BankAccountLedgerEntry."Document Date";
        CheckLedgerEntry."External Document No." := BankAccountLedgerEntry."Document No.";
        CheckLedgerEntry."Bank Account No." := BankAccountLedgerEntry."Bank Account No.";
        CheckLedgerEntry."YVS Bank Branch No." := BankAccountLedgerEntry."YVS Bank Branch No.";
        CheckLedgerEntry."YVS Bank Code" := BankAccountLedgerEntry."YVS Bank Code";
        CheckLedgerEntry."YVS Bank Name" := BankAccountLedgerEntry."YVS Bank Name";
        CheckLedgerEntry."YVS Cheque Name" := BankAccountLedgerEntry."YVS Cheque Name";
        CheckLedgerEntry."YVS Cheque No." := BankAccountLedgerEntry."YVS Cheque No.";
        CheckLedgerEntry."YVS Customer/Vendor No." := BankAccountLedgerEntry."YVS Customer/Vendor No.";
        CheckLedgerEntry."YVS Cheque Date" := BankAccountLedgerEntry."YVS Cheque Date";
        "YVS OnAfterCheckLedgerEntryCopyFromBankLedger"(CheckLedgerEntry, BankAccountLedgerEntry);
        // end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', true, true)]
    /// <summary> 
    /// Description for AfterCopyVendorFromGen.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="VendorLedgerEntry">Parameter of type Record "Vendor Ledger Entry".</param>
    local procedure "AfterCopyVendorFromGen"(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        GenLine: Record "Gen. Journal Line";
    begin
        // with VendorLedgerEntry do begin
        GenLine.reset();
        GenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLine.SetRange("Document No.", GenJournalLine."Document No.");
        GenLine.SetFilter("YVS Cheque No.", '<>%1', '');
        if GenLine.FindFirst() then begin
            VendorLedgerEntry."YVS Bank Name" := GenLine."YVS Bank Name";
            VendorLedgerEntry."YVS Bank Account No." := GenLine."YVS Bank Account No.";
            VendorLedgerEntry."YVS Bank Branch No." := GenLine."YVS Bank Branch No.";
            VendorLedgerEntry."YVS Bank Code" := GenLine."YVS Bank Code";
            VendorLedgerEntry."YVS Cheque Date" := GenLine."YVS Cheque Date";
            VendorLedgerEntry."YVS Cheque No." := GenLine."YVS Cheque No.";
            VendorLedgerEntry."YVS Customer/Vendor No." := GenLine."YVS Customer/Vendor No.";
        end;
        //  end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', true, true)]
    /// <summary> 
    /// Description for AfterCopyCustFromGen.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="CustLedgerEntry">Parameter of type Record "Cust. Ledger Entry".</param>
    local procedure "AfterCopyCustFromGen"(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        GenLine: Record "Gen. Journal Line";
    begin



        GenLine.reset();
        GenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLine.SetRange("Document No.", GenJournalLine."Document No.");
        GenLine.SetFilter("YVS Cheque No.", '<>%1', '');
        if GenLine.FindFirst() then begin
            CustLedgerEntry."Bank Account No." := GenLine."YVS Bank Account No.";
            CustLedgerEntry."YVS Bank Branch No." := GenLine."YVS Bank Branch No.";
            CustLedgerEntry."YVS Bank Code" := GenLine."YVS Bank Code";
            CustLedgerEntry."YVS Cheque Date" := GenLine."YVS Cheque Date";
            CustLedgerEntry."YVS Cheque No." := GenLine."YVS Cheque No.";
            CustLedgerEntry."YVS Customer/Vendor No." := GenLine."YVS Customer/Vendor No.";
        end;


    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    /// <summary> 
    /// Description for OnAfterCopyCustLedgerEntryFromGenJnlLine.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="CustLedgerEntry">Parameter of type Record "Cust. Ledger Entry".</param>
    local procedure "OnAfterCopyCustLedgerEntryFromGenJnlLine"(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgerEntry."YVS Head Office" := GenJournalLine."YVS Head Office";
        CustLedgerEntry."YVS VAT Branch Code" := GenJournalLine."YVS VAT Branch Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    /// <summary> 
    /// Description for OnAfterCopyVendLedgerEntryFromGenJnlLine.
    /// </summary>
    /// <param name="GenJournalLine">Parameter of type Record "Gen. Journal Line".</param>
    /// <param name="VendorLedgerEntry">Parameter of type Record "Vendor Ledger Entry".</param>
    local procedure "OnAfterCopyVendLedgerEntryFromGenJnlLine"(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        VendorLedgerEntry."YVS Head Office" := GenJournalLine."YVS Head Office";
        VendorLedgerEntry."YVS VAT Branch Code" := GenJournalLine."YVS VAT Branch Code";
    end;




    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterSetupNewLine', '', True, true)]
    local procedure "AfterSetupNewLine"(var ItemJournalLine: Record "Item Journal Line"; var LastItemJournalLine: Record "Item Journal Line")
    begin
        ItemJournalLine."YVS Document No. Series" := LastItemJournalLine."YVS Document No. Series";
    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', true, true)]
    /// <summary> 
    /// Description for AfterInitItemLedgEntry.
    /// </summary>
    /// <param name="ItemJournalLine">Parameter of type Record "Item Journal Line".</param>
    /// <param name="NewItemLedgEntry">Parameter of type Record "Item Ledger Entry".</param>
    local procedure "AfterInitItemLedgEntry"(ItemJournalLine: Record "Item Journal Line"; var NewItemLedgEntry: Record "Item Ledger Entry")
    begin

        NewItemLedgEntry."YVS Gen. Bus. Posting Group" := ItemJournalLine."Gen. Bus. Posting Group";
        NewItemLedgEntry."YVS Vat Bus. Posting Group" := ItemJournalLine."YVS Vat Bus. Posting Group";
        NewItemLedgEntry."YVS Vendor/Customer Name" := ItemJournalLine."YVS Vendor/Customer Name";
        NewItemLedgEntry."YVS Bin Code" := ItemJournalLine."Bin Code";
        "YVS OnCopyItemLedgerFromItemJournal"(NewItemLedgEntry, ItemJournalLine);

    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesHeader', '', true, true)]
    /// <summary> 
    /// Description for AfterCopyItemJnlLineFromSalesHeader.
    /// </summary>
    /// <param name="SalesHeader">Parameter of type Record "Sales Header".</param>
    /// <param name="ItemJnlLine">Parameter of type Record "Item Journal Line".</param>
    local procedure "AfterCopyItemJnlLineFromSalesHeader"(SalesHeader: Record "Sales Header"; var ItemJnlLine: Record "Item Journal Line")
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            ItemJnlLine."Invoice No." := SalesHeader."No.";
        ItemJnlLine."YVS Vendor/Customer Name" := SalesHeader."Sell-to Customer Name";

    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchHeader', '', true, true)]
    /// <summary> 
    /// Description for AfterCopyItemJnlLineFromPurchHeader.
    /// </summary>
    /// <param name="PurchHeader">Parameter of type Record "Purchase Header".</param>
    /// <param name="ItemJnlLine">Parameter of type Record "Item Journal Line".</param>
    local procedure "AfterCopyItemJnlLineFromPurchHeader"(PurchHeader: Record "Purchase Header"; var ItemJnlLine: Record "Item Journal Line")
    begin
        if PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice then
            ItemJnlLine."Invoice No." := PurchHeader."No.";
        ItemJnlLine."YVS Vendor/Customer Name" := PurchHeader."Buy-from Vendor Name";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesLine', '', TRUE, TRUE)]
    /// <summary> 
    /// Description for OnCopyFromSalesLine.
    /// </summary>
    /// <param name="ItemJnlLine">Parameter of type Record "Item Journal Line".</param>
    /// <param name="SalesLine">Parameter of type Record "Sales Line".</param>
    local procedure "OnCopyFromSalesLine"(var ItemJnlLine: Record "Item Journal Line"; SalesLine: Record "Sales Line")
    begin
        ItemJnlLine."YVS Vat Bus. Posting Group" := SalesLine."VAT Bus. Posting Group";
        ItemJnlLine."Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
        ItemJnlLine."Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
        ItemJnlLine."Bin Code" := SalesLine."Bin Code";
        ItemJnlLine.Description := SalesLine.Description;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchLine', '', TRUE, TRUE)]
    /// <summary> 
    /// Description for OnCopyFromPurchLine.
    /// </summary>
    /// <param name="ItemJnlLine">Parameter of type Record "Item Journal Line".</param>
    /// <param name="PurchLine">Parameter of type Record "Purchase Line".</param>
    local procedure "OnCopyFromPurchLine"(var ItemJnlLine: Record "Item Journal Line"; PurchLine: Record "Purchase Line")
    begin
        ItemJnlLine."YVS Vat Bus. Posting Group" := PurchLine."VAT Bus. Posting Group";
        ItemJnlLine."Gen. Prod. Posting Group" := PurchLine."Gen. Prod. Posting Group";
        ItemJnlLine."Gen. Bus. Posting Group" := PurchLine."Gen. Bus. Posting Group";
        ItemJnlLine."Bin Code" := PurchLine."Bin Code";
        ItemJnlLine.Description := PurchLine.Description;
    end;

    [IntegrationEvent(false, false)]
    local procedure "YVS AfterCopyInvoicePostingBufferToGL"(var GenJournalLine: Record "Gen. Journal Line"; InvoicePostingBuffer: Record "Invoice Posting Buffer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure "YVS AfterCopyInvoicePostBufferToGL"(var GenJournalLine: Record "Gen. Journal Line"; InvoicePostBuffer: Record "Invoice Post. Buffer")
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure "YVS AfterCopyGenLineToVatEntry"(var VatEntry: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure "YVS AfterCopyPuchaseHeaderToGenLine"(var GenJournalLine: Record "Gen. Journal Line"; PurchaseHeader: Record "Purchase Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure "YVS AfterCopySalesHeaderToGenLine"(var GenJournalLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure "YVS AfterCopyGenJournalLineToGLEntry"(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure "YVS OnAfterBankAccountLedgerEntryCopyFromGenJnlLine"(var BankAccountLedger: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure "YVS OnAfterCheckLedgerEntryCopyFromBankLedger"(var CheckLedgerEntry: record "Check Ledger Entry"; BankAccountLedger: Record "Bank Account Ledger Entry")
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure "YVS OnCopyItemLedgerFromItemJournal"(var ItemLedgerEntry: record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnBeforInsertWHTAPPLYGL()
    begin
    end;

}
