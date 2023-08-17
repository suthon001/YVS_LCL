/// <summary>
/// Codeunit YVS Purchase Function (ID 80001).
/// </summary>
codeunit 80001 "YVS Purchase Function"
{
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeTestNoSeries', '', false, false)]
    local procedure OnBeforeTestNoSeriesPurch(var PurchaseHeader: Record "Purchase Header")
    var
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        PurchSetup.GET();
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"YVS Purchase Request" then
            PurchSetup.TestField("YVS Purchase Request Nos.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeGetNoSeriesCode', '', false, false)]
    local procedure OnBeforeGetNoSeriesCodePurch(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean; var NoSeriesCode: Code[20]; PurchSetup: Record "Purchases & Payables Setup")
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"YVS Purchase Request" then begin
            NoSeriesCode := PurchSetup."YVS Purchase Request Nos.";
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnAfterInitPurchOrderLine', '', false, false)]
    local procedure OnAfterInitPurchOrderLine(var PurchaseLine: Record "Purchase Line")
    begin
        PurchaseLine."YVS Original Quantity" := PurchaseLine.Quantity;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnBeforeDeletePurchQuote', '', false, false)]
    local procedure OnBeforeDeletePurchQuote(var QuotePurchHeader: Record "Purchase Header"; var IsHandled: Boolean; var OrderPurchHeader: Record "Purchase Header")
    begin
        IsHandled := true;
        QuotePurchHeader."YVS Purchase Order No." := OrderPurchHeader."No.";
        QuotePurchHeader.Modify();
        MESSAGE('Create to Document No. ' + OrderPurchHeader."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnCreatePurchHeaderOnBeforePurchOrderHeaderInsert', '', false, false)]
    local procedure OnCreatePurchHeaderOnBeforePurchOrderHeaderInsert(var PurchHeader: Record "Purchase Header"; var PurchOrderHeader: Record "Purchase Header")
    var
        NoseriesMgt: Codeunit NoSeriesManagement;
    begin
        PurchHeader.TestField("YVS Make PO No. Series");
        PurchOrderHeader."No." := NoseriesMgt.GetNextNo(PurchHeader."YVS Make PO No. Series", WorkDate(), True);
        PurchOrderHeader."No. Series" := PurchHeader."YVS Make PO No. Series";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnFinalizePostingOnBeforeUpdateAfterPosting', '', false, false)]
    local procedure OnFinalizePostingOnBeforeUpdateAfterPosting(var PurchHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        WHTAppEntry: Record "YVS WHT Applied Entry";
        LastLineNo: Integer;
    begin
        LastLineNo := 0;

        if PurchHeader."Document Type" in [PurchHeader."Document Type"::Invoice, PurchHeader."Document Type"::"Credit Memo"] then begin
            PurchaseLine.reset();
            PurchaseLine.SetRange("Document Type", PurchHeader."Document Type");
            PurchaseLine.SetRange("Document No.", PurchHeader."No.");
            PurchaseLine.SetFilter("YVS WHT %", '<>%1', 0);
            OnbeforInsertWHTAPPLY(PurchHeader, PurchaseLine);
            if PurchaseLine.FindSet() then
                repeat
                    LastLineNo := LastLineNo + 10000;
                    WHTAppEntry.init();
                    WHTAppEntry."Document No." := PurchaseLine."Document No.";
                    WHTAppEntry."Document Line No." := PurchaseLine."Line No.";
                    WHTAppEntry."Entry Type" := WHTAppEntry."Entry Type"::Initial;
                    WHTAppEntry."Line No." := LastLineNo;
                    WHTAppEntry."WHT Bus. Posting Group" := PurchaseLine."YVS WHT Business Posting Group";
                    WHTAppEntry."WHT Prod. Posting Group" := PurchaseLine."YVS WHT Product Posting Group";
                    WHTAppEntry.Description := PurchaseLine.Description;
                    WHTAppEntry."WHT %" := PurchaseLine."YVS WHT %";
                    WHTAppEntry."WHT Base" := PurchaseLine."YVS WHT Base";
                    WHTAppEntry."WHT Amount" := PurchaseLine."YVS WHT Amount";
                    WHTAppEntry."WHT Name" := PurchHeader."Buy-from Vendor Name";
                    WHTAppEntry."WHT Name 2" := PurchHeader."Buy-from Vendor Name 2";
                    WHTAppEntry."WHT Address" := PurchHeader."Buy-from Address";
                    WHTAppEntry."WHT Address 2" := PurchHeader."Buy-from Address 2";
                    WHTAppEntry."WHT City" := PurchHeader."Buy-from City";
                    WHTAppEntry."VAT Registration No." := PurchHeader."VAT Registration No.";
                    WHTAppEntry."WHT Option" := PurchaseLine."YVS WHT Option";
                    WHTAppEntry."VAT Branch Code" := PurchHeader."YVS VAT Branch Code";
                    WHTAppEntry."Head Office" := PurchHeader."YVS Head Office";
                    WHTAppEntry."WHT Post Code" := PurchHeader."Buy-from Post Code";
                    if PurchaseLine."Document Type" = PurchaseLine."Document Type"::Invoice then
                        WHTAppEntry."WHT Document Type" := WHTAppEntry."WHT Document Type"::Invoice;
                    if PurchaseLine."Document Type" = PurchaseLine."Document Type"::"Credit Memo" then
                        WHTAppEntry."WHT Document Type" := WHTAppEntry."WHT Document Type"::"Credit Memo";
                    WHTAppEntry.Insert(true);
                until PurchaseLine.Next() = 0;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purch. Inv. Line", 'OnAfterInitFromPurchLine', '', True, True)]
    local procedure "OnAfterInitFromPurchaseLine"(PurchLine: Record "Purchase Line"; PurchInvHeader: Record "Purch. Inv. Header"; var PurchInvLine: Record "Purch. Inv. Line")
    var
        FaDepBook: Record "FA Depreciation Book";
    begin
        if PurchLine.Type = PurchLine.Type::"Fixed Asset" then begin
            FaDepBook.reset();
            FaDepBook.SetRange("FA No.", PurchLine."No.");
            if FaDepBook.FindFirst() then begin
                FaDepBook.Validate("Depreciation Starting Date", PurchInvHeader."Posting Date");
                FaDepBook.Modify();
            end;

        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnAfterInsertPurchOrderLine', '', false, false)]
    local procedure OnAfterInsertPurchOrderLine(var PurchaseQuoteLine: Record "Purchase Line")
    begin
        PurchaseQuoteLine."Outstanding Qty. (Base)" := 0;
        PurchaseQuoteLine."Outstanding Quantity" := 0;
        PurchaseQuoteLine."Completely Received" := (PurchaseQuoteLine.Quantity <> 0) and (PurchaseQuoteLine."Outstanding Quantity" = 0);
        PurchaseQuoteLine.Modify();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnBeforeInsertPurchOrderLine', '', false, false)]
    local procedure OnBeforeInsertPurchOrderLine(PurchQuoteLine: Record "Purchase Line"; var PurchOrderLine: Record "Purchase Line")
    begin
        PurchOrderLine."YVS Ref. PQ No." := PurchQuoteLine."Document No.";
        PurchOrderLine."YVS Ref. PQ Line No." := PurchQuoteLine."Line No.";
        PurchOrderLine."YVS Make Order By" := COPYSTR(UserId, 1, 50);
        PurchOrderLine."YVS Make Order DateTime" := CurrentDateTime;
        PurchOrderLine."YVS Original Quantity" := PurchOrderLine.Quantity;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", 'OnAfterInsertLines', '', true, true)]
    local procedure "OnAfterInsertLines"(var PurchHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        ReceiptHeader: Record "Purch. Rcpt. Header";
    begin
        PurchaseLine.reset();
        PurchaseLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchHeader."No.");
        PurchaseLine.SetFilter("Receipt No.", '<>%1', '');
        if PurchaseLine.FindFirst() then begin
            ReceiptHeader.get(PurchaseLine."Receipt No.");
            PurchHeader."Vendor Invoice No." := ReceiptHeader."Vendor Shipment No.";
            PurchHeader.Modify();
        end;
    end;



    [IntegrationEvent(false, false)]
    local procedure HandleMessagebeforPostPurchase(var Handle: Boolean)
    begin
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInitOutstandingQty', '', false, false)]
    local procedure "OnAfterInitOutstandingQty"(var PurchaseLine: Record "Purchase Line")
    var
        POLine: Record "Purchase Line";
        TempQty, TempQtyBase : Decimal;
    begin
        if PurchaseLine."Document Type" IN [PurchaseLine."Document Type"::Quote, PurchaseLine."Document Type"::"YVS Purchase Request", PurchaseLine."Document Type"::Order] then begin
            PurchaseLine."Outstanding Quantity" := PurchaseLine.Quantity - PurchaseLine."Quantity Received" - PurchaseLine."YVS Qty. to Cancel";
            PurchaseLine."Outstanding Qty. (Base)" := PurchaseLine."Quantity (Base)" - PurchaseLine."Qty. Received (Base)" - PurchaseLine."YVS Qty. to Cancel (Base)";
            if PurchaseLine."Document Type" in [PurchaseLine."Document Type"::Quote, PurchaseLine."Document Type"::"YVS Purchase Request"] then begin
                POLine.reset();
                POLine.SetRange("Document Type", POLine."Document Type"::Order);
                POLine.SetRange("YVS Ref. PQ No.", PurchaseLine."Document No.");
                POLine.SetRange("YVS Ref. PQ Line No.", PurchaseLine."Line No.");
                if POLine.FindFirst() then begin
                    POLine.CalcSums(Quantity, "Quantity (Base)");
                    TempQty := POLine.Quantity;
                    TempQtyBase := POLine."Quantity (Base)";
                    PurchaseLine."Outstanding Quantity" := PurchaseLine.Quantity - PurchaseLine."Quantity Received" - TempQty - PurchaseLine."YVS Qty. to Cancel";
                    PurchaseLine."Outstanding Qty. (Base)" := PurchaseLine."Quantity (Base)" - PurchaseLine."Qty. Received (Base)" - TempQtyBase - PurchaseLine."YVS Qty. to Cancel (Base)";
                end;
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnAfterPreparePurchase', '', true, true)]
    local procedure "InvoiceBufferPurchase"(var InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; var PurchaseLine: Record "Purchase Line")
    var
        PurchHeader: Record "Purchase Header";
        VendCust: Record "YVS Customer & Vendor Branch";
        Vend: Record Vendor;
    begin
        //with InvoicePostBuffer do begin

        PurchHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");
        Vend.GET(PurchHeader."Buy-from Vendor No.");
        PurchHeader.CALCFIELDS(Amount, "Amount Including VAT");

        InvoicePostingBuffer."YVS Tax Vendor No." := PurchHeader."Pay-to Vendor No.";
        if PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice then
            InvoicePostingBuffer."YVS Tax Invoice No." := PurchHeader."Vendor Invoice No."
        else
            InvoicePostingBuffer."YVS Tax Invoice No." := PurchHeader."Vendor Cr. Memo No.";
        InvoicePostingBuffer."YVS VAT Registration No." := PurchHeader."VAT Registration No.";
        if InvoicePostingBuffer."YVS VAT Registration No." = '' then
            InvoicePostingBuffer."YVS VAT Registration No." := Vend."VAT Registration No.";
        InvoicePostingBuffer."YVS Head Office" := PurchHeader."YVS Head Office";
        InvoicePostingBuffer."YVS VAT Branch Code" := PurchHeader."YVS VAT Branch Code";
        InvoicePostingBuffer."YVS Tax Invoice Date" := PurchHeader."Document Date";
        InvoicePostingBuffer."YVS Tax Invoice Name" := PurchHeader."Buy-from Vendor Name";
        InvoicePostingBuffer."YVS Tax Invoice Name 2" := PurchHeader."Buy-from Vendor Name 2";
        InvoicePostingBuffer."YVS Address" := PurchHeader."Buy-from Address";
        InvoicePostingBuffer."YVS Address 2" := PurchHeader."Buy-from Address 2";
        InvoicePostingBuffer."YVS city" := PurchHeader."Buy-from city";
        InvoicePostingBuffer."YVS Post Code" := PurchHeader."Buy-from Post Code";
        InvoicePostingBuffer."YVS Document Line No." := PurchaseLine."Line No.";

        if VendCust.Get(VendCust."Source Type"::Vendor, PurchHeader."Buy-from Vendor No.", PurchHeader."YVS Head Office", PurchHeader."YVS VAT Branch Code") then begin
            if VendCust."Title Name" <> VendCust."Title Name"::" " then
                InvoicePostingBuffer."YVS Tax Invoice Name" := format(VendCust."Title Name") + ' ' + VendCust."Name"
            else
                InvoicePostingBuffer."YVS Tax Invoice Name" := VendCust."Name";
            InvoicePostingBuffer."YVS Address" := VendCust."Address";
            InvoicePostingBuffer."YVS Address 2" := VendCust."Address 2";
            InvoicePostingBuffer."YVS city" := VendCust."Province";
            InvoicePostingBuffer."YVS Post Code" := VendCust."Post Code";
        end;
        InvoicePostingBuffer."YVS Description Line" := PurchaseLine.Description;
        InvoicePostingBuffer."YVS Tax Invoice Base" := PurchaseLine.Amount;
        InvoicePostingBuffer."YVS Tax Invoice Amount" := PurchaseLine."Amount Including VAT" - PurchaseLine.Amount;
        IF PurchaseLine."YVS Tax Invoice No." <> '' THEN BEGIN
            InvoicePostingBuffer."YVS Tax Vendor No." := PurchaseLine."YVS Tax Vendor No.";
            InvoicePostingBuffer."YVS Head Office" := PurchaseLine."YVS Head Office";
            InvoicePostingBuffer."YVS VAT Branch Code" := PurchaseLine."YVS VAT Branch Code";
            InvoicePostingBuffer."YVS Tax Invoice No." := PurchaseLine."YVS Tax Invoice No.";
            InvoicePostingBuffer."Additional Grouping Identifier" := PurchaseLine."YVS Tax Invoice No.";
            InvoicePostingBuffer."YVS Tax Invoice Date" := PurchaseLine."YVS Tax Invoice Date";
            InvoicePostingBuffer."YVS Tax Invoice Name" := PurchaseLine."YVS Tax Invoice Name";
            InvoicePostingBuffer."YVS Tax Invoice Name 2" := PurchaseLine."YVS Tax Invoice Name 2";
            IF InvoicePostingBuffer."VAT %" <> 0 THEN BEGIN
                InvoicePostingBuffer."YVS Tax Invoice Base" := PurchaseLine.Amount;
                InvoicePostingBuffer."YVS Tax Invoice Amount" := PurchaseLine."Amount Including VAT" - PurchaseLine.Amount;
                if PurchaseLine."YVS Tax Invoice Base" <> 0 then begin
                    InvoicePostingBuffer."YVS Tax Invoice Base" := PurchaseLine."YVS Tax Invoice Base";
                    InvoicePostingBuffer."YVS Tax Invoice Amount" := PurchaseLine."YVS Tax Invoice Amount";
                end;
            END ELSE begin
                InvoicePostingBuffer."YVS Tax Invoice Base" := PurchaseLine."YVS Tax Invoice Base";
                InvoicePostingBuffer."YVS Tax Invoice Amount" := PurchaseLine."Line Amount";
            end;
        END;

        IF PurchaseLine."YVS VAT Registration No." <> '' THEN
            InvoicePostingBuffer."YVS VAT Registration No." := PurchaseLine."YVS VAT Registration No."
        ELSE
            InvoicePostingBuffer."YVS VAT Registration No." := PurchHeader."VAT Registration No.";

        IF (InvoicePostingBuffer.Type = InvoicePostingBuffer.Type::"G/L Account") OR (InvoicePostingBuffer.Type = InvoicePostingBuffer.Type::"Fixed Asset") THEN
            InvoicePostingBuffer."YVS Line No." := PurchaseLine."Line No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', true, true)]
    local procedure "OnAfterInvPostBufferPreparePurchase"(var InvoicePostBuffer: Record "Invoice Post. Buffer" temporary; var PurchaseLine: Record "Purchase Line")
    var
        PurchHeader: Record "Purchase Header";
        VendCust: Record "YVS Customer & Vendor Branch";
        Vend: Record Vendor;
    begin
        //with InvoicePostBuffer do begin

        PurchHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");
        PurchHeader.CALCFIELDS(Amount, "Amount Including VAT");
        Vend.GET(PurchHeader."Buy-from Vendor No.");
        InvoicePostBuffer."YVS Tax Vendor No." := PurchHeader."Pay-to Vendor No.";
        if PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice then
            InvoicePostBuffer."YVS Tax Invoice No." := PurchHeader."Vendor Invoice No."
        else
            InvoicePostBuffer."YVS Tax Invoice No." := PurchHeader."Vendor Cr. Memo No.";
        InvoicePostBuffer."YVS Tax Vendor No." := PurchHeader."Pay-to Vendor No.";
        InvoicePostBuffer."YVS VAT Registration No." := PurchHeader."VAT Registration No.";
        if InvoicePostBuffer."YVS VAT Registration No." = '' then
            InvoicePostBuffer."YVS VAT Registration No." := Vend."VAT Registration No.";
        InvoicePostBuffer."YVS Head Office" := PurchHeader."YVS Head Office";
        InvoicePostBuffer."YVS VAT Branch Code" := PurchHeader."YVS VAT Branch Code";
        InvoicePostBuffer."YVS Tax Invoice Date" := PurchHeader."Document Date";
        InvoicePostBuffer."YVS Tax Invoice Name" := PurchHeader."Pay-to Name";
        InvoicePostBuffer."YVS Tax Invoice Name 2" := PurchHeader."Pay-to Name 2";
        InvoicePostBuffer."YVS Address" := PurchHeader."Buy-from Address";
        InvoicePostBuffer."YVS Address 2" := PurchHeader."Buy-from Address 2";
        InvoicePostBuffer."YVS city" := PurchHeader."Buy-from city";
        InvoicePostBuffer."YVS Post Code" := PurchHeader."Buy-from Post Code";
        InvoicePostBuffer."YVS Document Line No." := PurchaseLine."Line No.";
        if VendCust.Get(VendCust."Source Type"::Vendor, PurchHeader."Buy-from Vendor No.", PurchHeader."YVS Head Office", PurchHeader."YVS VAT Branch Code") then begin
            if VendCust."Title Name" <> VendCust."Title Name"::" " then
                InvoicePostBuffer."YVS Tax Invoice Name" := format(VendCust."Title Name") + ' ' + VendCust."Name"
            else
                InvoicePostBuffer."YVS Tax Invoice Name" := VendCust."Name";
            InvoicePostBuffer."YVS Address" := VendCust."Address";
            InvoicePostBuffer."YVS Address 2" := VendCust."Address 2";
            InvoicePostBuffer."YVS city" := VendCust."Province";
            InvoicePostBuffer."YVS Post Code" := VendCust."Post Code";
        end;
        InvoicePostBuffer."YVS Description Line" := PurchaseLine.Description;
        InvoicePostBuffer."YVS Tax Invoice Base" := PurchaseLine.Amount;
        InvoicePostBuffer."YVS Tax Invoice Amount" := PurchaseLine."Amount Including VAT" - PurchaseLine.Amount;
        IF PurchaseLine."YVS Tax Invoice No." <> '' THEN BEGIN
            if PurchaseLine."YVS Tax Vendor No." <> '' then
                InvoicePostBuffer."YVS Tax Vendor No." := PurchaseLine."YVS Tax Vendor No.";
            InvoicePostBuffer."YVS Head Office" := PurchaseLine."YVS Head Office";
            InvoicePostBuffer."YVS VAT Branch Code" := PurchaseLine."YVS VAT Branch Code";
            InvoicePostBuffer."YVS Tax Invoice No." := PurchaseLine."YVS Tax Invoice No.";
            InvoicePostBuffer."Additional Grouping Identifier" := PurchaseLine."YVS Tax Invoice No.";
            InvoicePostBuffer."YVS Tax Invoice Date" := PurchaseLine."YVS Tax Invoice Date";
            InvoicePostBuffer."YVS Tax Invoice Name" := PurchaseLine."YVS Tax Invoice Name";
            InvoicePostBuffer."YVS Tax Invoice Name 2" := PurchaseLine."YVS Tax Invoice Name 2";
            IF InvoicePostBuffer."VAT %" <> 0 THEN BEGIN
                InvoicePostBuffer."YVS Tax Invoice Base" := PurchaseLine.Amount;
                InvoicePostBuffer."YVS Tax Invoice Amount" := PurchaseLine."Amount Including VAT" - PurchaseLine.Amount;
                if PurchaseLine."YVS Tax Invoice Base" <> 0 then begin
                    InvoicePostBuffer."YVS Tax Invoice Base" := PurchaseLine."YVS Tax Invoice Base";
                    InvoicePostBuffer."YVS Tax Invoice Amount" := PurchaseLine."YVS Tax Invoice Amount";
                end;
            END ELSE begin
                InvoicePostBuffer."YVS Tax Invoice Base" := PurchaseLine."YVS Tax Invoice Base";
                InvoicePostBuffer."YVS Tax Invoice Amount" := PurchaseLine."Line Amount";
            end;
        END;

        IF PurchaseLine."YVS VAT Registration No." <> '' THEN
            InvoicePostBuffer."YVS VAT Registration No." := PurchaseLine."YVS VAT Registration No."
        ELSE
            InvoicePostBuffer."YVS VAT Registration No." := PurchHeader."VAT Registration No.";

        IF (InvoicePostBuffer.Type = InvoicePostBuffer.Type::"G/L Account") OR (InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset") THEN
            InvoicePostBuffer."YVS Line No." := PurchaseLine."Line No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterCheckPurchaseApprovalPossible', '', false, false)]
    local procedure "OnSendPurchaseDocForApproval"(var PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        Item: Record Item;
    begin
        PurchaseLine.reset();
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetFilter("Location Code", '%1', '');
        if PurchaseLine.FindFirst() then begin
            Item.Get(PurchaseLine."No.");
            if NOT (Item.Type IN [Item.Type::Service, item.Type::"Non-Inventory"]) then
                PurchaseLine.TestField("Location Code");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order (Yes/No)", 'OnBeforePurchQuoteToOrder', '', false, false)]
    local procedure OnBeforePurchQuoteToOrder(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        text001Msg: Label 'this document has been order no. %1', Locked = true;
    begin
        PurchaseHeader.TestField(Status, PurchaseHeader.Status::Released);
        if PurchaseHeader."YVS Purchase Order No." <> '' then begin
            MESSAGE(StrSubstNo(text001Msg, PurchaseHeader."YVS Purchase Order No."));
            IsHandled := true;
        end;
    end;

    [BusinessEvent(false)]
    local procedure OnbeforInsertWHTAPPLY(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line")
    begin
    end;


}