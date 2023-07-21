/// <summary>
/// Codeunit YVS Journal Function (ID 80000).
/// </summary>
codeunit 80000 "YVS Journal Function"
{
    EventSubscriberInstance = StaticAutomatic;





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
        BankAccountLedgerEntry."Bank Account No." := GenJournalLine."YVS Bank Account No.";
        BankAccountLedgerEntry."YVS Bank Branch No." := GenJournalLine."YVS Bank Branch No.";
        BankAccountLedgerEntry."YVS Bank Code" := GenJournalLine."YVS Bank Code";
        BankAccountLedgerEntry."YVS Bank Name" := GenJournalLine."YVS Bank Name";
        BankAccountLedgerEntry."YVS Cheque Name" := GenJournalLine."YVS Cheque Name";
        BankAccountLedgerEntry."YVS Cheque No." := GenJournalLine."YVS Cheque No.";
        BankAccountLedgerEntry."YVS Customer/Vendor No." := GenJournalLine."YVS Customer/Vendor No.";
        BankAccountLedgerEntry."YVS Cheque Date" := GenJournalLine."YVS Cheque Date";
        "YVS OnAfterBankAccountLedgerEntryCopyFromGenJnlLine"(BankAccountLedgerEntry, GenJournalLine);
        //  end;
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
        // with CustLedgerEntry do begin



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

        // end;
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

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterValidateEvent', 'Item No.', TRUE, TRUE)]
    local procedure "AfterValidateItemNo"(var Rec: Record "Item Journal Line")
    var
        Item: Record Item;
        ItemJournalBatch: Record "Item Journal Batch";
        ItemTemplateName: Record "Item Journal Template";
    begin

        if not Item.get(Rec."Item No.") then
            Item.init();
        Rec."YVS Description 2" := Item."Description 2";


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
}
