/// <summary>
/// Codeunit YVS EventFunction (ID 80005).
/// </summary>
codeunit 80005 "YVS EventFunction"
{
    Permissions = TableData "G/L Entry" = rimd, tabledata "Purch. Rcpt. Line" = imd, tabledata "Return Shipment Line" = imd, tabledata "Sales Shipment Line" = imd;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterAppliesToDocNoOnLookup', '', false, false)]
    local procedure OnAfterAppliesToDocNoOnLookup(CustLedgerEntry: Record "Cust. Ledger Entry"; var SalesHeader: Record "Sales Header")
    var
        SalesInvoice: Record "Sales Invoice Header";
    begin
        if SalesInvoice.GET(CustLedgerEntry."Document No.") then begin
            SalesInvoice.CalcFields(Amount);
            SalesHeader."YVS Ref. Tax Invoice Date" := SalesInvoice."Document Date";
            SalesHeader."YVS Ref. Tax Invoice Amount" := SalesInvoice.Amount;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Enum Assignment Management", 'OnGetPurchApprovalDocumentType', '', false, false)]
    local procedure OnGetPurchApprovalDocumentType(PurchDocumentType: Enum "Purchase Document Type"; var ApprovalDocumentType: Enum "Approval Document Type"; var IsHandled: Boolean)
    begin
        if PurchDocumentType = PurchDocumentType::"YVS Purchase Request" then begin
            ApprovalDocumentType := ApprovalDocumentType::"YVS Purchase Request";
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnBeforeCheckGenPostingType', '', false, false)]
    local procedure OnBeforeCheckGenPostingType(var IsHandled: Boolean; GenJnlLine: Record "Gen. Journal Line"; AccountType: Enum "Gen. Journal Account Type")
    var
    begin
        if CheckDisableLCL() then
            exit;
        if (AccountType = AccountType::Customer) and
           (GenJnlLine."Gen. Posting Type" = GenJnlLine."Gen. Posting Type"::Purchase) or
           (AccountType = AccountType::Vendor) and
           (GenJnlLine."Gen. Posting Type" = GenJnlLine."Gen. Posting Type"::Sale)
        then
            IsHandled := true;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnBeforeCheckAccountNo', '', false, false)]
    local procedure OnBeforeCheckAccountNo(var CheckDone: Boolean; var GenJnlLine: Record "Gen. Journal Line")
    var
        GEnJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        Text003: Label 'must have the same sign as %1';
    begin
        if CheckDisableLCL() then
            exit;
        case GenJnlLine."Account Type" of
            GenJnlLine."Account Type"::Customer, GenJnlLine."Account Type"::Vendor, GenJnlLine."Account Type"::Employee:
                begin
                    GenJnlLine.TestField("Gen. Bus. Posting Group", '', ErrorInfo.Create());
                    GenJnlLine.TestField("Gen. Prod. Posting Group", '', ErrorInfo.Create());
                    GenJnlLine.TestField("VAT Bus. Posting Group", '', ErrorInfo.Create());
                    GenJnlLine.TestField("VAT Prod. Posting Group", '', ErrorInfo.Create());

                    CheckAccountType(GenJnlLine);

                    GEnJnlCheckLine.CheckDocType(GenJnlLine);

                    if not GenJnlLine."System-Created Entry" and
                       (((GenJnlLine.Amount < 0) xor (GenJnlLine."Sales/Purch. (LCY)" < 0)) and (GenJnlLine.Amount <> 0) and (GenJnlLine."Sales/Purch. (LCY)" <> 0))
                    then
                        GenJnlLine.FieldError("Sales/Purch. (LCY)", ErrorInfo.Create(StrSubstNo(Text003, GenJnlLine.FieldCaption(Amount)), true));
                    GenJnlLine.TestField("Job No.", '', ErrorInfo.Create());
                    CheckICPartner(GenJnlLine."Account Type", GenJnlLine."Account No.", GenJnlLine."Document Type", GenJnlLine);
                    CheckDone := true;
                end;
        end;
    end;

    local procedure CheckICPartner(AccountType: Enum "Gen. Journal Account Type"; AccountNo: Code[20]; DocumentType: Enum "Gen. Journal Document Type"; GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        Customer: Record Customer;
        Vendor: Record Vendor;
        ICPartner: Record "IC Partner";
        Employee: Record Employee;
    begin
        if CheckDisableLCL() then
            exit;
        if not GenJnlTemplate.GET(GenJnlLine."Journal Template Name") then
            GenJnlTemplate.Init();

        case AccountType of
            AccountType::Customer:
                if Customer.Get(AccountNo) then begin
                    Customer.CheckBlockedCustOnJnls(Customer, DocumentType, true);
                    if (Customer."IC Partner Code" <> '') and (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) and
                       ICPartner.Get(Customer."IC Partner Code")
                    then
                        ICPartner.CheckICPartnerIndirect(Format(AccountType), AccountNo);
                end;
            AccountType::Vendor:
                if Vendor.Get(AccountNo) then begin
                    Vendor.CheckBlockedVendOnJnls(Vendor, DocumentType, true);
                    if (Vendor."IC Partner Code" <> '') and (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) and
                       ICPartner.Get(Vendor."IC Partner Code")
                    then
                        ICPartner.CheckICPartnerIndirect(Format(AccountType), AccountNo);
                end;
            AccountType::Employee:
                if Employee.Get(AccountNo) then
                    Employee.CheckBlockedEmployeeOnJnls(true)
        end;
    end;

    local procedure CheckAccountType(GenJnlLine: Record "Gen. Journal Line")
    var
        Text010: Label '%1 %2 and %3 %4 is not allowed.';
    begin
        if CheckDisableLCL() then
            exit;
        if ((GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer) and
            (GenJnlLine."Bal. Gen. Posting Type" = GenJnlLine."Bal. Gen. Posting Type"::Purchase)) or
           ((GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) and
            (GenJnlLine."Bal. Gen. Posting Type" = GenJnlLine."Bal. Gen. Posting Type"::Sale))
        then
            Error(
                ErrorInfo.Create(
                    StrSubstNo(
                        Text010,
                        GenJnlLine.FieldCaption("Account Type"), GenJnlLine."Account Type",
                        GenJnlLine.FieldCaption("Bal. Gen. Posting Type"), GenJnlLine."Bal. Gen. Posting Type"),
                    true,
                    GenJnlLine));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeValidateGenPostingType', '', false, false)]
    local procedure OnBeforeValidateGenPostingType(var CheckIfFieldIsEmpty: Boolean)
    begin
        if CheckDisableLCL() then
            exit;
        CheckIfFieldIsEmpty := false;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostFixedAsset', '', false, false)]
    local procedure OnBeforePostFixedAsset(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean; sender: Codeunit "Gen. Jnl.-Post Line")
    begin
        if CheckDisableLCL() then
            exit;
        PostFixedAsset(GenJournalLine, sender);
        IsHandled := true;
    end;

    local procedure PostFixedAsset(GenJnlLine: Record "Gen. Journal Line"; GenJnlPostLine: codeunit "Gen. Jnl.-Post Line")
    var
        GLEntry: Record "G/L Entry";
        GLEntry2: Record "G/L Entry";
        TempFAGLPostBuf: Record "FA G/L Posting Buffer" temporary;
        FAGLPostBuf: Record "FA G/L Posting Buffer";
        VATPostingSetup: Record "VAT Posting Setup";
        GLReg: Record "G/L Register";
        FAAutomaticEntry: Codeunit "FA Automatic Entry";
        FAJnlPostLine: Codeunit "YVS FA Jnl.-Post Line";
        ShortcutDim1Code: Code[20];
        ShortcutDim2Code: Code[20];
        Correction2: Boolean;
        NetDisposalNo: Integer;
        DimensionSetID: Integer;
        VATEntryGLEntryNo: Integer;
    begin
        if CheckDisableLCL() then
            exit;
        GenJnlPostLine.GetGLReg(GLReg);
        GenJnlPostLine.InitGLEntry(GenJnlLine, GLEntry, '', GenJnlLine."Amount (LCY)", GenJnlLine."Source Currency Amount", true, GenJnlLine."System-Created Entry");
        GLEntry."Gen. Posting Type" := GenJnlLine."Gen. Posting Type";
        GLEntry."Bal. Account Type" := GenJnlLine."Bal. Account Type";
        GLEntry."Bal. Account No." := GenJnlLine."Bal. Account No.";
        GenJnlPostLine.InitVAT(GenJnlLine, GLEntry, VATPostingSetup);
        GLEntry2 := GLEntry;
        FAJnlPostLine.GenJnlPostLine(
            GenJnlLine, GLEntry2.Amount, GLEntry2."VAT Amount", GenJnlPostLine.GetNextTransactionNo(), GenJnlPostLine.GetNextEntryNo(), GLReg."No.");
        ShortcutDim1Code := GenJnlLine."Shortcut Dimension 1 Code";
        ShortcutDim2Code := GenJnlLine."Shortcut Dimension 2 Code";
        DimensionSetID := GenJnlLine."Dimension Set ID";
        Correction2 := GenJnlLine.Correction;
        if FAJnlPostLine.FindFirstGLAcc(TempFAGLPostBuf) then
            repeat
                GenJnlLine."Shortcut Dimension 1 Code" := TempFAGLPostBuf."Global Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := TempFAGLPostBuf."Global Dimension 2 Code";
                GenJnlLine."Dimension Set ID" := TempFAGLPostBuf."Dimension Set ID";
                GenJnlLine.Correction := TempFAGLPostBuf.Correction;
                GenJnlPostLine.CheckDimValueForDisposal(GenJnlLine, TempFAGLPostBuf."Account No.");
                if TempFAGLPostBuf."Original General Journal Line" then
                    GenJnlPostLine.InitGLEntry(GenJnlLine, GLEntry, TempFAGLPostBuf."Account No.", TempFAGLPostBuf.Amount, GLEntry2."Additional-Currency Amount", true, true)
                else begin
                    GenJnlPostLine.CheckNonAddCurrCodeOccurred('');
                    GenJnlPostLine.InitGLEntry(GenJnlLine, GLEntry, TempFAGLPostBuf."Account No.", TempFAGLPostBuf.Amount, 0, false, true);
                end;
                GLEntry.CopyPostingGroupsFromGLEntry(GLEntry2);
                GLEntry."VAT Amount" := GLEntry2."VAT Amount";
                GLEntry."Bal. Account Type" := GLEntry2."Bal. Account Type";
                GLEntry."Bal. Account No." := GLEntry2."Bal. Account No.";
                GLEntry."FA Entry Type" := TempFAGLPostBuf."FA Entry Type";
                GLEntry."FA Entry No." := TempFAGLPostBuf."FA Entry No.";
                if TempFAGLPostBuf."Net Disposal" then
                    NetDisposalNo := NetDisposalNo + 1
                else
                    NetDisposalNo := 0;
                if TempFAGLPostBuf."Automatic Entry" and not TempFAGLPostBuf."Net Disposal" then
                    FAAutomaticEntry.AdjustGLEntry(GLEntry);
                if NetDisposalNo > 1 then
                    GLEntry."VAT Amount" := 0;
                if TempFAGLPostBuf."FA Posting Group" <> '' then begin
                    FAGLPostBuf := TempFAGLPostBuf;
                    FAGLPostBuf."Entry No." := GenJnlPostLine.GetNextEntryNo();
                    FAGLPostBuf.Insert();
                end;
                GenJnlPostLine.InsertGLEntry(GenJnlLine, GLEntry, true);
                if (VATEntryGLEntryNo = 0) and (GLEntry."Gen. Posting Type" <> GLEntry."Gen. Posting Type"::" ") then
                    VATEntryGLEntryNo := GLEntry."Entry No.";
            until FAJnlPostLine.GetNextGLAcc(TempFAGLPostBuf) = 0;
        GenJnlLine."Shortcut Dimension 1 Code" := ShortcutDim1Code;
        GenJnlLine."Shortcut Dimension 2 Code" := ShortcutDim2Code;
        GenJnlLine."Dimension Set ID" := DimensionSetID;
        GenJnlLine.Correction := Correction2;
        GenJnlLine."FA G/L Account No." := GLEntry."G/L Account No.";
        GLEntry := GLEntry2;
        if VATEntryGLEntryNo = 0 then
            VATEntryGLEntryNo := GLEntry."Entry No.";
        GenJnlPostLine.SetTempGLEntryBufEntryNo(VATEntryGLEntryNo);
        GenJnlPostLine.PostVAT(GenJnlLine, GLEntry, VATPostingSetup);
        FAJnlPostLine.UpdateRegNo(GLReg."No.");

    end;


    // [EventSubscriber(ObjectType::Table, database::"Sales Shipment Line", 'OnInsertInvLineFromShptLineOnBeforeValidateQuantity', '', false, false)]
    // local procedure OnInsertInvLineFromShptLineOnBeforeValidateQuantity(var IsHandled: Boolean; var SalesLine: Record "Sales Line"; SalesShipmentLine: Record "Sales Shipment Line")
    // var
    //     SalesInvoiceLine: Record "Sales Line";
    //     TotalShipment: Decimal;
    // begin
    //     SalesInvoiceLine.reset();
    //     SalesInvoiceLine.SetFilter("Document No.", '<>%1', SalesLine."Document No.");
    //     SalesInvoiceLine.SetRange("Shipment No.", SalesLine."Shipment No.");
    //     SalesInvoiceLine.SetRange("Shipment Line No.", SalesLine."Shipment Line No.");
    //     SalesInvoiceLine.CalcSums(Quantity);
    //     TotalShipment := SalesInvoiceLine.Quantity;

    //     SalesInvoiceLine.reset();
    //     SalesInvoiceLine.SetRange("Document No.", SalesLine."Document No.");
    //     SalesInvoiceLine.SetFilter("Line No.", '<>%1', SalesLine."Line No.");
    //     SalesInvoiceLine.SetRange("Shipment No.", SalesLine."Shipment No.");
    //     SalesInvoiceLine.SetRange("Shipment Line No.", SalesLine."Shipment Line No.");
    //     SalesInvoiceLine.CalcSums(Quantity);
    //     TotalShipment := TotalShipment + SalesInvoiceLine.Quantity;

    //     SalesInvoiceLine.Validate(Quantity, SalesShipmentLine.Quantity - SalesShipmentLine."Quantity Invoiced" - TotalShipment);

    //     IsHandled := true;

    // end;

    // [EventSubscriber(ObjectType::Table, database::"Purch. Rcpt. Line", 'OnInsertInvLineFromRcptLineOnBeforeValidateQuantity', '', false, false)]
    // local procedure OnInsertInvLineFromRcptLineOnBeforeValidateQuantity(var IsHandled: Boolean; var PurchaseLine: Record "Purchase Line"; PurchRcptLine: Record "Purch. Rcpt. Line")
    // var
    //     PurchaseInvoiceLine: Record "Purchase Line";
    //     TotalReceipt: Decimal;
    // begin
    //     PurchaseInvoiceLine.reset();
    //     PurchaseInvoiceLine.SetFilter("Document No.", '<>%1', PurchaseLine."Document No.");
    //     PurchaseInvoiceLine.SetRange("Receipt No.", PurchaseLine."Receipt No.");
    //     PurchaseInvoiceLine.SetRange("Receipt Line No.", PurchaseLine."Receipt Line No.");
    //     PurchaseInvoiceLine.CalcSums(Quantity);
    //     TotalReceipt := PurchaseInvoiceLine.Quantity;

    //     PurchaseInvoiceLine.reset();
    //     PurchaseInvoiceLine.SetRange("Document No.", PurchaseLine."Document No.");
    //     PurchaseInvoiceLine.SetFilter("Line No.", '<>%1', PurchaseLine."Line No.");
    //     PurchaseInvoiceLine.SetRange("Receipt No.", PurchaseLine."Receipt No.");
    //     PurchaseInvoiceLine.SetRange("Receipt Line No.", PurchaseLine."Receipt Line No.");
    //     PurchaseInvoiceLine.CalcSums(Quantity);
    //     TotalReceipt := TotalReceipt + PurchaseInvoiceLine.Quantity;

    //     PurchaseLine.Validate(Quantity, PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced" - TotalReceipt);

    //     IsHandled := true;

    // end;

    // /// <summary>
    // /// CheckRemainingPurchaseInvoice.
    // /// </summary>
    // /// <param name="pPuchaseLine">Record "Purchase Line".</param>
    // procedure CheckRemainingPurchaseInvoice(pPuchaseLine: Record "Purchase Line")
    // var
    //     PurchaseInvoiceLine: Record "Purchase Line";
    //     PurchaseReceiptLine: Record "Purch. Rcpt. Line";
    //     TotalReceipt, TotalInvoice : Decimal;

    // begin
    //     if pPuchaseLine."Receipt No." <> '' then begin
    //         PurchaseInvoiceLine.reset();
    //         PurchaseInvoiceLine.SetFilter("Document No.", '<>%1', pPuchaseLine."Document No.");
    //         PurchaseInvoiceLine.SetRange("Receipt No.", pPuchaseLine."Receipt No.");
    //         PurchaseInvoiceLine.SetRange("Receipt Line No.", pPuchaseLine."Receipt Line No.");
    //         PurchaseInvoiceLine.CalcSums(Quantity);
    //         TotalReceipt := PurchaseInvoiceLine.Quantity;

    //         PurchaseInvoiceLine.reset();
    //         PurchaseInvoiceLine.SetRange("Document No.", pPuchaseLine."Document No.");
    //         PurchaseInvoiceLine.SetFilter("Line No.", '<>%1', pPuchaseLine."Line No.");
    //         PurchaseInvoiceLine.SetRange("Receipt No.", pPuchaseLine."Receipt No.");
    //         PurchaseInvoiceLine.SetRange("Receipt Line No.", pPuchaseLine."Receipt Line No.");
    //         PurchaseInvoiceLine.CalcSums(Quantity);
    //         TotalReceipt := TotalReceipt + PurchaseInvoiceLine.Quantity;

    //         if PurchaseReceiptLine.GET(pPuchaseLine."Receipt No.", pPuchaseLine."Receipt Line No.") then begin
    //             TotalInvoice := PurchaseReceiptLine.Quantity - PurchaseReceiptLine."Quantity Invoiced";
    //             PurchaseReceiptLine."YVS Get to Invoice" := (TotalReceipt + pPuchaseLine.Quantity) >= TotalInvoice;
    //             PurchaseReceiptLine.Modify();
    //         end;
    //     end;
    // end;

    // /// <summary>
    // /// CheckRemainingSalesInvoice.
    // /// </summary>
    // /// <param name="pSalesLine">Record "Sales Line".</param>
    // procedure CheckRemainingSalesInvoice(pSalesLine: Record "Sales Line")
    // var
    //     SalesInvoiceLine: Record "Sales Line";
    //     SalesShipmentLine: Record "Sales Shipment Line";
    //     TotalShipment, TotalInvoice : Decimal;

    // begin
    //     if pSalesLine."Shipment No." <> '' then begin
    //         SalesInvoiceLine.reset();
    //         SalesInvoiceLine.SetFilter("Document No.", '<>%1', pSalesLine."Document No.");
    //         SalesInvoiceLine.SetRange("Shipment No.", pSalesLine."Shipment No.");
    //         SalesInvoiceLine.SetRange("Shipment Line No.", pSalesLine."Shipment Line No.");
    //         SalesInvoiceLine.CalcSums(Quantity);
    //         TotalShipment := SalesInvoiceLine.Quantity;

    //         SalesInvoiceLine.reset();
    //         SalesInvoiceLine.SetRange("Document No.", pSalesLine."Document No.");
    //         SalesInvoiceLine.SetFilter("Line No.", '<>%1', pSalesLine."Line No.");
    //         SalesInvoiceLine.SetRange("Shipment No.", pSalesLine."Shipment No.");
    //         SalesInvoiceLine.SetRange("Shipment Line No.", pSalesLine."Shipment Line No.");
    //         SalesInvoiceLine.CalcSums(Quantity);
    //         TotalShipment := TotalShipment + SalesInvoiceLine.Quantity;
    //         if SalesShipmentLine.GET(pSalesLine."Shipment No.", pSalesLine."Shipment Line No.") then begin
    //             TotalInvoice := SalesShipmentLine.Quantity - SalesShipmentLine."Quantity Invoiced";
    //             SalesShipmentLine."YVS Get to Invoice" := (TotalShipment + pSalesLine.Quantity) >= TotalInvoice;
    //             SalesShipmentLine.Modify();
    //         end;
    //     end;
    // end;

    [EventSubscriber(ObjectType::Page, Page::"Fixed Asset Card", 'OnBeforeUpdateDepreciationBook', '', false, false)]
    local procedure OnBeforeUpdateDepreciationBook(var IsHandled: Boolean; var FADepreciationBook: Record "FA Depreciation Book"; var FixedAssetNo: Code[20])
    var
        FixedAsset: Record "Fixed Asset";
        ltFASubclass: Record "FA Subclass";
    begin
        if CheckDisableLCL() then
            exit;
        if FixedAsset.Get(FixedAssetNo) then begin
            IsHandled := true;
            if not ltFASubclass.GET(FixedAsset."FA Subclass Code") then
                ltFASubclass.Init();
            if FADepreciationBook."Depreciation Book Code" <> '' then
                if FADepreciationBook."FA No." = '' then begin
                    FADepreciationBook.Validate("FA No.", FixedAssetNo);
                    FADepreciationBook.Insert(true);
                    FADepreciationBook.VALIDATE("Depreciation Starting Date", WORKDATE());
                    if ltFASubclass."YVS No. of Depreciation Years" <> 0 then
                        FADepreciationBook.VALIDATE("YVS No. of Years", ltFASubclass."YVS No. of Depreciation Years");
                    FADepreciationBook.Modify(true);
                end else begin
                    FADepreciationBook.Description := FixedAsset.Description;
                    if FADepreciationBook."Depreciation Starting Date" = 0D then
                        FADepreciationBook.VALIDATE("Depreciation Starting Date", WORKDATE());
                    if ltFASubclass."YVS No. of Depreciation Years" <> 0 then
                        FADepreciationBook.VALIDATE("YVS No. of Years", ltFASubclass."YVS No. of Depreciation Years");
                    FADepreciationBook.Modify(true);
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Get Shipment", 'OnRunAfterFilterSalesShpLine', '', false, false)]
    local procedure OnRunAfterFilterSalesShpLine(var SalesShptLine: Record "Sales Shipment Line")
    begin
        if CheckDisableLCL() then
            exit;
        SalesShptLine.SetRange("YVS Get to Invoice", false);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnAfterInsertInvLineFromShptLine', '', false, false)]
    local procedure OnAfterInsertInvLineFromShptLine(SalesShipmentLine: Record "Sales Shipment Line")
    begin
        if CheckDisableLCL() then
            exit;
        SalesShipmentLine."YVS Get to Invoice" := true;
        SalesShipmentLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", 'OnAfterCreateInvLines', '', false, false)]
    local procedure OnAfterCreateInvLinesPur(var PurchaseHeader: Record "Purchase Header")
    var
        ReceiptHeader: Record "Purch. Rcpt. Header";
        PurchaseLine: Record "Purchase Line";
    begin
        if CheckDisableLCL() then
            exit;
        PurchaseLine.reset();
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetFilter("Receipt No.", '<>%1', '');
        if PurchaseLine.FindFirst() then
            if ReceiptHeader.GET(PurchaseLine."Receipt No.") then begin
                PurchaseHeader."Vendor Invoice No." := ReceiptHeader."YVS Vendor Invoice No.";
                PurchaseHeader.Modify();
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", 'OnAfterPurchRcptLineSetFilters', '', false, false)]
    local procedure OnAfterPurchRcptLineSetFilters(var PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        if CheckDisableLCL() then
            exit;
        PurchRcptLine.SetRange("YVS Get to Invoice", false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnAfterInsertInvLineFromRcptLine', '', false, false)]
    local procedure OnAfterInsertInvLineFromRcptLine(PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        if CheckDisableLCL() then
            exit;
        PurchRcptLine."YVS Get to Invoice" := true;
        PurchRcptLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Return Shipments", 'OnRunOnAfterSetReturnShptLineFilters', '', false, false)]
    local procedure OnRunOnAfterSetReturnShptLineFilters(var ReturnShipmentLine: Record "Return Shipment Line")
    begin
        if CheckDisableLCL() then
            exit;
        ReturnShipmentLine.SetRange("YVS Get to CN", false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Return Shipments", 'OnAfterCreateInvLines', '', false, false)]
    local procedure OnAfterCreateInvLines(PurchaseHeader: Record "Purchase Header")
    var
        ReturnShipment: Record "Return Shipment Header";
        PurchaseLine: Record "Purchase Line";
    begin
        if CheckDisableLCL() then
            exit;
        PurchaseLine.reset();
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetFilter("Return Shipment No.", '<>%1', '');
        if PurchaseLine.FindFirst() then
            if ReturnShipment.GET(PurchaseLine."Return Shipment No.") then begin
                PurchaseHeader."Vendor Cr. Memo No." := ReturnShipment."YVS Vendor Cr. Memo No.";
                PurchaseHeader.Modify();
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Return Shipment Line", 'OnBeforeInsertInvLineFromRetShptLine', '', false, false)]
    local procedure OnBeforeInsertInvLineFromRetShptLine(var ReturnShipmentLine: Record "Return Shipment Line")
    begin
        if CheckDisableLCL() then
            exit;
        ReturnShipmentLine."YVS Get to CN" := true;
        ReturnShipmentLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchRcptHeaderInsert', '', false, false)]
    local procedure OnBeforePurchRcptHeaderInsert(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchaseHeader: Record "Purchase Header")
    begin
        if CheckDisableLCL() then
            exit;
        PurchRcptHeader."YVS Vendor Invoice No." := PurchaseHeader."Vendor Invoice No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeInsertReturnShipmentHeader', '', false, false)]
    local procedure OnBeforeInsertReturnShipmentHeader(var PurchHeader: Record "Purchase Header"; var ReturnShptHeader: Record "Return Shipment Header")
    begin
        if CheckDisableLCL() then
            exit;
        ReturnShptHeader."YVS Vendor Cr. Memo No." := PurchHeader."Vendor Cr. Memo No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeOnRun', '', false, false)]
    local procedure OnBeforeOnRunPurchasePostYesNo(var PurchaseHeader: Record "Purchase Header")
    begin
        if CheckDisableLCL() then
            exit;
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then
            PurchaseHeader.TestField(Status, PurchaseHeader.Status::Released);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Acc. Schedule Overview", 'OnBeforePrint', '', false, false)]
    local procedure OnBeforePrintAccSheduleOverview(var AccScheduleLine: Record "Acc. Schedule Line"; var IsHandled: Boolean; var TempFinancialReport: Record "Financial Report" temporary)
    var
        AccSched: Report "YVS Account Schedule";
        DateFilter2: Text;
        GLBudgetFilter2: Text;
        BusUnitFilter: Text;
        CostBudgetFilter2: Text;
    begin
        if CheckDisableLCL() then
            exit;
        if TempFinancialReport.Name <> '' then
            AccSched.SetFinancialReportName(TempFinancialReport.Name);
        if TempFinancialReport."Financial Report Row Group" <> '' then
            AccSched.SetAccSchedName(TempFinancialReport."Financial Report Row Group");
        if TempFinancialReport."Financial Report Column Group" <> '' then
            AccSched.SetColumnLayoutName(TempFinancialReport."Financial Report Column Group");
        DateFilter2 := AccScheduleLine.GetFilter("Date Filter");
        GLBudgetFilter2 := AccScheduleLine.GetFilter("G/L Budget Filter");
        CostBudgetFilter2 := AccScheduleLine.GetFilter("Cost Budget Filter");
        BusUnitFilter := AccScheduleLine.GetFilter("Business Unit Filter");
        AccSched.SetFilters(DateFilter2, GLBudgetFilter2, CostBudgetFilter2, BusUnitFilter, TempFinancialReport.Dim1Filter, TempFinancialReport.Dim2Filter, TempFinancialReport.Dim3Filter, TempFinancialReport.Dim4Filter, TempFinancialReport.CashFlowFilter);
        AccSched.Run();

        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Test Report-Print", 'OnBeforePrintGenJnlLine', '', false, false)]
    local procedure OnBeforePrintGenJnlLine(var NewGenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        if CheckDisableLCL() then
            exit;
        GenJnlLine.Copy(NewGenJnlLine);
        GenJnlTemplate.Get(GenJnlLine."Journal Template Name");
        if GenJnlTemplate.Type = GenJnlTemplate.Type::Assets then begin
            GenJnlLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
            GenJnlLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
            REPORT.Run(REPORT::"YVS Fixed Asset Journal - Test", true, false, GenJnlLine);
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Financial Report Mgt.", 'OnBeforePrint', '', false, false)]
    local procedure OnBeforePrintFinancial(var FinancialReport: Record "Financial Report"; var IsHandled: Boolean)
    var
        AccountSchedule: Report "YVS Account Schedule";
    begin
        if CheckDisableLCL() then
            exit;
        CLEAR(AccountSchedule);
        AccountSchedule.SetFinancialReportName(FinancialReport.Name);
        AccountSchedule.Run();
        IsHandled := true;
        CLEAR(AccountSchedule);
    end;

    /// <summary>
    /// SelectCaptionReport.
    /// </summary>
    /// <param name="pNameThai">VAR text[50].</param>
    /// <param name="pNameEng">VAR text[50].</param>
    /// <param name="pDocumentType">Enum "Sales Document Type".</param>
    procedure SelectCaptionReport(var pNameThai: text[50]; var pNameEng: text[50]; pDocumentType: Enum "YVS Document Type Report")
    var
        ltSelectCaptionReport: Record "YVS Caption Report Setup";
        ltCaptionReport: Page "YVS Caption Report List";
    begin
        if CheckDisableLCL() then
            exit;
        CLEAR(ltCaptionReport);
        ltSelectCaptionReport.reset();
        ltSelectCaptionReport.SetRange("Document Type", pDocumentType);
        ltCaptionReport.SetTableView(ltSelectCaptionReport);
        ltCaptionReport.LookupMode := true;
        if ltCaptionReport.RunModal() = Action::LookupOK then begin
            ltCaptionReport.GetRecord(ltSelectCaptionReport);
            pNameThai := ltSelectCaptionReport."Name (Thai)";
            pNameEng := ltSelectCaptionReport."Name (Eng)";
        end;
        Clear(ltCaptionReport);
    end;


    [EventSubscriber(ObjectType::Table, Database::"FA Depreciation Book", 'OnBeforeValidateNoOfDepreYears', '', false, false)]
    local procedure OnBeforeValidateNoOfDepreYears(var IsHandled: Boolean)
    begin
        if CheckDisableLCL() then
            exit;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"FA Depreciation Book", 'OnBeforeModifyFADeprBook', '', false, false)]
    local procedure OnBeforeModifyFADeprBook(var IsHandled: Boolean)
    begin
        if CheckDisableLCL() then
            exit;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Payment Journal", 'OnAfterValidateEvent', 'AppliesToDocNo', false, false)]
    local procedure AppliesToDocNo(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line")

    begin
        if CheckDisableLCL() then
            exit;
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
        if CheckDisableLCL() then
            exit;
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
        NosMgt: Codeunit "No. Series";
        Vendor: Record Vendor;
        WHTBusiness: Record "YVS WHT Business Posting Group";
        ltWHTAppliedEntry: Record "YVS WHT Applied Entry";
        ltWHTEntry: Record "YVS WHT Line";
        ltLineNo: Integer;

    begin

        if CheckDisableLCL() then
            exit;
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
                WHTheader."WHT Certificate No." := NosMgt.GetNextNo(WHTBusiness."WHT Certificate No. Series", WorkDate(), true);
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
    /// <param name="WHTHeader">VAR Record "YVS WHT Header".</param>
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
        if CheckDisableLCL() then
            exit;
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
            GenJnlLine."YVS Create By" := COPYSTR(UserId(), 1, 50);
            GenJnlLine."YVS Create DateTime" := CurrentDateTime();
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
        if CheckDisableLCL() then
            exit;
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
        if ReportId = Report::"Account Schedule" then
            NewReportId := report::"YVS Account Schedule";
        if ReportId = Report::"Fixed Asset - Acquisition List" then
            NewReportId := report::"YVS Fixed Asset - Acquisition";
        if ReportId = Report::"Purchase - Receipt" then
            NewReportId := report::"YVS Purchase Receipt";
        if ReportId = Report::"Purchase - Return Shipment" then
            NewReportId := report::"YVS Purchase - Return Shipment";
        if ReportId = Report::"Phys. Inventory List" then
            NewReportId := report::"YVS Phys. Inventory List";
        if ReportId = Report::"Assembly Order" then
            NewReportId := report::"YVS Assembly Order";
        if ReportId = Report::"Posted Assembly Order" then
            NewReportId := report::"YVS Posted Assembly Order";
        if ReportId = Report::"Return Order" then
            NewReportId := report::"YVS Return Order";
        if ReportId = Report::"Sales - Shipment" then
            NewReportId := report::"YVS Sales - Shipment";
        if ReportId = Report::"Pick Instruction" then
            NewReportId := report::"YVS Pick Instruction";
        if ReportId = Report::"Bank Account Statement" then
            NewReportId := report::"YVS Bank Account Statement";
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
        if CheckDisableLCL() then
            exit;
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
        if CheckDisableLCL() then
            exit;
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
    /// <param name="pTempVatEntry">Temporary VAR Record "VAT Entry".</param>
    procedure "GenLinePreviewVourcher"(GenJournalLine: Record "Gen. Journal Line"; var TemporaryGL: Record "G/L Entry" temporary; var pTempVatEntry: Record "VAT Entry" temporary)
    var
        ltGenLine: Record "Gen. Journal Line";
        RecRef, RecRefVat : RecordRef;
        TempErrorMessage: Record "Error Message" temporary;
    begin
        if CheckDisableLCL() then
            exit;
        ltGenLine.Reset();
        ltGenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        ltGenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        ltGenLine.SetRange("Document No.", GenJournalLine."Document No.");
        ltGenLine.FindFirst();
        ErrorMessageMgt.Activate(ErrorMessageHandler);
        BindSubscription(GenJnlPost);
        GenJnlPostPreview.SetContext(GenJnlPost, ltGenLine);
        IF NOT GenJnlPostPreview.Run() AND GenJnlPostPreview.IsSuccess() THEN begin
            GenJnlPostPreview.GetPreviewHandler(PostingPreviewEventHandler);
            PostingPreviewEventHandler.GetEntries(Database::"G/L Entry", RecRef);
            PostingPreviewEventHandler.GetEntries(Database::"VAT Entry", RecRefVat);
            InsertToTempGL(RecRef, TemporaryGL);
            InsertToTempVAT(RecRefVat, pTempVatEntry);

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
        if CheckDisableLCL() then
            exit;
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

    local procedure InsertToTempVAT(RecRef2: RecordRef; var pTempVATEntry: Record "VAT Entry" temporary)
    begin
        if CheckDisableLCL() then
            exit;
        if RecRef2.FindSet() then
            repeat
                RecRef2.SetTable(pTempVATEntry);
                pTempVATEntry.Insert();
            until RecRef2.next() = 0;
    end;


    /// <summary>
    /// RunWorkflowOnSendBillingReceiptHeaderApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnSendBillingReceiptApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendBillingReceiptApproval'))
    end;



    /// <summary>
    /// RunWorkflowOnSendBillingReceiptApproval.
    /// </summary>
    /// <param name="BillingReceiptHeader">VAR Record "YVS Billing Receipt Header".</param>
    [EventSubscriber(ObjectType::Table, database::"YVS Billing Receipt Header", 'OnSendBillingReceiptforApproval', '', false, false)]
    local procedure RunWorkflowOnSendBillingReceiptApproval(var BillingReceiptHeader: Record "YVS Billing Receipt Header")
    begin
        WFMngt.HandleEvent(RunWorkflowOnSendBillingReceiptApprovalCode(), BillingReceiptHeader);
    end;

    /// <summary>
    /// RunWorkflowOnCancelBillingReceiptApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnCancelBillingReceiptApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelBillingReceiptApproval'));
    end;

    [EventSubscriber(ObjectType::Table, database::"YVS Billing Receipt Header", 'OnCancelBillingReceiptforApproval', '', false, false)]
    local procedure OnCancelBillingReceiptforApproval(var BillingReceiptHeader: Record "YVS Billing Receipt Header")
    begin
        WFMngt.HandleEvent(RunWorkflowOnCancelBillingReceiptApprovalCode(), BillingReceiptHeader);
    end;




    /// <summary>
    /// RunWorkflowOnApproveBillingReceiptApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnApproveBillingReceiptApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApproveBillingReceiptApproval'))
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnApproveBillingReceiptApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        if ApprovalEntry."Table ID" = Database::"YVS Billing Receipt Header" then
            WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveBillingReceiptApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

    end;




    /// <summary>
    /// RunWorkflowOnRejectBillingReceiptApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnRejectBillingReceiptApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectBillingReceiptApproval'))
    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnRejectApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        if ApprovalEntry."Table ID" = Database::"YVS Billing Receipt Header" then
            WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnRejectBillingReceiptApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

    end;

    /// <summary>
    /// RunWorkflowOnDelegateBillingReceiptApprovalCode.
    /// </summary>
    /// <returns>Return value of type Code[128].</returns>
    procedure RunWorkflowOnDelegateBillingReceiptApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegateBillingReceiptApproval'))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnDelegateApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnDelegateApproval(var ApprovalEntry: Record "Approval Entry")
    begin
        if ApprovalEntry."Table ID" = Database::"YVS Billing Receipt Header" then
            WFMngt.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegateBillingReceiptApprovalCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure "OnSetStatusToPendingApproval"(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean);
    var
        BillingReceipts: Record "YVS Billing Receipt Header";
    begin
        case RecRef.Number of
            DATABASE::"YVS Billing Receipt Header":
                begin
                    RecRef.SetTable(BillingReceipts);
                    BillingReceipts.Status := BillingReceipts.Status::"Pending Approval";
                    BillingReceipts.Modify();
                    IsHandled := true;
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure "OnReleaseDocument"(RecRef: RecordRef; var Handled: Boolean);
    var
        BillingReceipts: Record "YVS Billing Receipt Header";

    begin
        case RecRef.Number of
            DATABASE::"YVS Billing Receipt Header":
                begin
                    RecRef.SetTable(BillingReceipts);
                    BillingReceipts.Status := BillingReceipts.Status::Released;
                    BillingReceipts.Modify();
                    Handled := true;
                end;
        end;

    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean);
    var
        BillingReceipts: Record "YVS Billing Receipt Header";

    begin
        case RecRef.Number of
            DATABASE::"YVS Billing Receipt Header":
                begin
                    RecRef.SetTable(BillingReceipts);
                    BillingReceipts.Status := BillingReceipts.Status::Open;
                    BillingReceipts.Modify();
                    Handled := true;
                END;
        end;
    END;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure "AddBillingReceiptEventToLibrary"()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendBillingReceiptApprovalCode(), Database::"YVS Billing Receipt Header", SendBillingReceiptReqLbl, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelBillingReceiptApprovalCode(), Database::"YVS Billing Receipt Header", CancelReqBillingReceiptLbl, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]

    local procedure "OnPopulateApprovalEntryArgument"(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance");
    var
        BillingReceipt: Record "YVS Billing Receipt Header";
    begin
        case RecRef.Number OF
            DATABASE::"YVS Billing Receipt Header":
                begin
                    RecRef.SetTable(BillingReceipt);
                    BillingReceipt.CalcFields(Amount);
                    if BillingReceipt."Document Type" = BillingReceipt."Document Type"::"Sales Receipt" then begin
                        ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"YVS Sales Receipt";
                        ApprovalEntryArgument.Amount := BillingReceipt."Receive & Payment Amount";
                        ApprovalEntryArgument."Amount (LCY)" := BillingReceipt."Receive & Payment Amount";
                    end;
                    if BillingReceipt."Document Type" = BillingReceipt."Document Type"::"Sales Billing" then begin
                        ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"YVS Sales Billing";
                        ApprovalEntryArgument.Amount := BillingReceipt.Amount;
                        ApprovalEntryArgument."Amount (LCY)" := BillingReceipt.Amount;
                    end;
                    ApprovalEntryArgument."Document No." := BillingReceipt."No.";
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnAfterGetPageID', '', false, false)]
    local procedure "OnAfterGetPageID"(RecordRef: RecordRef; var PageID: Integer)
    var
        BillingReceipt: Record "YVS Billing Receipt Header";
    begin
        if (PageID = 0) and (RecordRef.Number = Database::"YVS Billing Receipt Header") then begin
            RecordRef.SetTable(BillingReceipt);
            if BillingReceipt."Document Type" = BillingReceipt."Document Type"::"Sales Receipt" then
                PageID := Page::"YVS Sales Receipt List";

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Notification Management", 'OnGetDocumentTypeAndNumber', '', false, false)]
    local procedure "OnGetDocumentTypeAndNumber"(var RecRef: RecordRef; var IsHandled: Boolean; var DocumentNo: Text; var DocumentType: Text);
    var
        FieldRef: FieldRef;
    begin
        IF RecRef.Number = DATABASE::"YVS Billing Receipt Header" then begin
            DocumentType := RecRef.Caption;
            FieldRef := RecRef.FieldIndex(1);
            DocumentNo := Format(FieldRef.Value);
            FieldRef := RecRef.Field(2);
            DocumentNo += ',' + Format(FieldRef.Value);
            IsHandled := true;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', false, false)]
    local procedure "OnAddWorkflowCategoriesToLibrary"();
    var
        workflowSetup: Codeunit "Workflow Setup";
    begin
        workflowSetup.InsertWorkflowCategory('BILLINGRECEIPT', 'Billing Receipt Workflow');
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInitWorkflowTemplates', '', false, false)]
    local procedure "OnAfterInitWorkflowTemplates"()
    var
        Workflow: Record Workflow;
        workflowSetup: Codeunit "Workflow Setup";
        BillingReceiptHeader: Record "YVS Billing Receipt Header";
        BillingReceiptLine: Record "YVS Billing Receipt Line";
        ApprovalEntry: Record "Approval Entry";

    begin
        Workflow.reset();
        Workflow.SetRange(Category, BillingReceiptCatLbl);
        Workflow.SetRange(Template, true);
        if Workflow.IsEmpty then begin
            workflowSetup.InsertTableRelation(Database::"YVS Billing Receipt Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
            workflowSetup.InsertTableRelation(Database::"YVS Billing Receipt Header", BillingReceiptHeader.FieldNo("Document Type"), DATABASE::"YVS Billing Receipt Line", BillingReceiptLine.FieldNo("Document Type"));
            workflowSetup.InsertTableRelation(Database::"YVS Billing Receipt Header", BillingReceiptHeader.FieldNo("No."), DATABASE::"YVS Billing Receipt Line", BillingReceiptLine.FieldNo("Document No."));
            InsertWorkflowBillingReceiptTemplateSalesReceipt();
        end;

    end;


    local procedure InsertWorkflowBillingReceiptTemplateSalesReceipt()
    var
        Workflow: Record 1501;
        workflowSetup: Codeunit "Workflow Setup";

    begin
        workflowSetup.InsertWorkflowTemplate(Workflow, 'SRECEIPT', 'Sales Receipt Workflow', BillingReceiptCatLbl);
        InsertBillingReceiptDetailWOrkflowSalesReceipt(Workflow);
        workflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;





    local procedure InsertBillingReceiptDetailWOrkflowSalesReceipt(var workflow: Record 1501)
    var

        WorkflowSetpArgument: Record 1523;
        blankDateFormula: DateFormula;
        BillingReceipt: Record "YVS Billing Receipt Header";
        WorkflowSetup: Codeunit "Workflow Setup";

    begin

        WorkflowSetup.InitWorkflowStepArgument(WorkflowSetpArgument,
        WorkflowSetpArgument."Approver Type"::Approver, WorkflowSetpArgument."Approver Limit Type"::"Direct Approver",
        0, '', blankDateFormula, TRUE);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
      workflow,
      BuildBillingReceiptCondition(BillingReceipt."Status"::Open, BillingReceipt."Document Type"::"Sales Receipt"),
      RunWorkflowOnSendBillingReceiptApprovalCode(),
       BuildBillingReceiptCondition(BillingReceipt."Status"::"Pending Approval", BillingReceipt."Document Type"::"Sales Receipt"),
       RunWorkflowOnCancelBillingReceiptApprovalCode(),
        WorkflowSetpArgument,
       TRUE
       );
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure "OnAddWorkflowEventPredecessorsToLibrary"(EventFunctionName: Code[128]);
    var
        WorkflowEventHadning: Codeunit "Workflow Event Handling";
    begin
        case EventFunctionName of
            RunWorkflowOnCancelBillingReceiptApprovalCode():
                WorkflowEventHadning.AddEventPredecessor(RunWorkflowOnCancelBillingReceiptApprovalCode(), RunWorkflowOnSendBillingReceiptApprovalCode());
            WorkflowEventHadning.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowEventHadning.AddEventPredecessor(WorkflowEventHadning.RunWorkflowOnApproveApprovalRequestCode(), RunWorkflowOnSendBillingReceiptApprovalCode());

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure "OnAddWorkflowResponsePredecessorsToLibrary"(ResponseFunctionName: Code[128]);
    var
        WorkflowResponseHanding: Codeunit 1521;
    begin
        case ResponseFunctionName of

            WorkflowResponseHanding.SetStatusToPendingApprovalCode():

                WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.SetStatusToPendingApprovalCode(),
                RunWorkflowOnSendBillingReceiptApprovalCode());
            WorkflowResponseHanding.SendApprovalRequestForApprovalCode():

                WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.SendApprovalRequestForApprovalCode(),
                RunWorkflowOnSendBillingReceiptApprovalCode());
            WorkflowResponseHanding.RejectAllApprovalRequestsCode():

                WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.RejectAllApprovalRequestsCode(),
                RunWorkflowOnRejectBillingReceiptApprovalCode());
            WorkflowResponseHanding.CancelAllApprovalRequestsCode():

                WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.CancelAllApprovalRequestsCode(),
                RunWorkflowOnCancelBillingReceiptApprovalCode());
            WorkflowResponseHanding.OpenDocumentCode():

                WorkflowResponseHanding.AddResponsePredecessor(WorkflowResponseHanding.OpenDocumentCode(),
                RunWorkflowOnCancelBillingReceiptApprovalCode());
        end;

    end;

    local procedure BuildBillingReceiptCondition(Status: Enum "YVS Billing Receipt Status"; DocumentType: Enum "YVS Billing Document Type"): Text
    var
        BillingReceipt: Record "YVS Billing Receipt Header";
        BillingReceiptLine: Record "YVS Billing Receipt Line";
        workflowSetup: Codeunit "Workflow Setup";
    begin
        BillingReceipt.SetRange("Document Type", DocumentType);
        BillingReceipt.SetRange("Status", Status);
        exit(StrSubstNo(BillingReceiptConditionTxt, workflowSetup.Encode(BillingReceipt.GetView(false)), workflowSetup.Encode(BillingReceiptLine.GetView(false))));
    end;

    /// <summary>
    /// OnbeforInsertWHTLine.
    /// </summary>
    /// <param name="WhtApplyLine">Record "YVS WHT Applied Entry".</param>
    /// <param name="WHTHeader">Record "YVS WHT Header".</param>
    /// <param name="GenLine">Record "Gen. Journal Line".</param>
    /// <param name="WHTLine">VAR Record "YVS WHT Line".</param>
    [IntegrationEvent(true, false)]
    procedure OnbeforInsertWHTLine(WhtApplyLine: Record "YVS WHT Applied Entry"; WHTHeader: Record "YVS WHT Header"; GenLine: Record "Gen. Journal Line"; var WHTLine: Record "YVS WHT Line")
    begin

    end;

    /// <summary>
    /// OnbeforModifyWHTHeader.
    /// </summary>
    /// <param name="WhtApplyLine">Record "YVS WHT Applied Entry".</param>
    /// <param name="WHTHeader">VAR Record "YVS WHT Header".</param>
    /// <param name="GenLine">Record "Gen. Journal Line".</param>
    [IntegrationEvent(true, false)]
    procedure OnbeforModifyWHTHeader(WhtApplyLine: Record "YVS WHT Applied Entry"; var WHTHeader: Record "YVS WHT Header"; GenLine: Record "Gen. Journal Line")
    begin

    end;

    /// <summary>
    /// OnbeformodifyCreateWHTCertificate.
    /// </summary>
    /// <param name="WHTHeader">Record "YVS WHT Header".</param>
    /// <param name="GenLine">VAR Record "Gen. Journal Line".</param>
    [IntegrationEvent(true, false)]
    procedure OnbeformodifyCreateWHTCertificate(WHTHeader: Record "YVS WHT Header"; var GenLine: Record "Gen. Journal Line")
    begin

    end;

    local procedure CheckDisableLCL(): Boolean
    var
        CompanyInfor: Record "Company Information";
    begin
        CompanyInfor.GET();
        exit(CompanyInfor."YVS Disable LCL");
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