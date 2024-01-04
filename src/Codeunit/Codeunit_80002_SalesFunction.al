/// <summary>
/// Codeunit YVS Sales Function (ID 80002).
/// </summary>
codeunit 80002 "YVS Sales Function"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesCrMemoHeaderInsert', '', false, false)]
    local procedure OnBeforeSalesCrMemoHeaderInsert(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SalesHeader: Record "Sales Header")
    begin
        SalesCrMemoHeader."YVS Applies-to ID" := SalesHeader."Applies-to ID";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvHeaderInsert', '', false, false)]
    local procedure OnBeforeSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header")
    begin
        SalesInvHeader."YVS Requested Delivery Date" := SalesHeader."Requested Delivery Date";
        SalesInvHeader."YVS Applies-to ID" := SalesHeader."Applies-to ID";
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateSellToCustomerName', '', false, false)]
    local procedure OnBeforeValidateSellToCustomerName(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeDeleteSalesQuote', '', false, false)]
    local procedure "OnBeferDeleteSalesQuote"(var IsHandled: Boolean; var QuoteSalesHeader: Record "Sales Header"; var OrderSalesHeader: Record "Sales Header")
    begin
        IsHandled := true;
        QuoteSalesHeader."YVS Sales Order No." := OrderSalesHeader."No.";
        QuoteSalesHeader.Modify();
        MESSAGE('Create to Document No. ' + OrderSalesHeader."No.");
    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order (Yes/No)", 'OnBeforeRun', '', false, false)]
    local procedure OnBeforeRun(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var

    begin
        if SalesHeader."YVS Sales Order No." <> '' then begin
            MESSAGE('Document has been convers to Order %1', SalesHeader."YVS Sales Order No.");
            IsHandled := true;
        end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeInsertSalesOrderHeader', '', false, false)]
    local procedure "OnBeforeInsertSalesOrderHeader"(SalesQuoteHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header")
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin

        SalesQuoteHeader.TestField("YVS Make Order No. Series");
        SalesOrderHeader."No." := NoseriesMgt.GetNextNo(SalesQuoteHeader."YVS Make Order No. Series", WorkDate(), True);
        SalesOrderHeader."No. Series" := SalesQuoteHeader."YVS Make Order No. Series";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", 'OnBeforeInsertSalesOrderLine', '', false, false)]
    local procedure OnBeforeInsertSalesOrderLineBlanket(var SalesOrderLine: Record "Sales Line"; SalesOrderHeader: Record "Sales Header"; BlanketOrderSalesLine: Record "Sales Line"; BlanketOrderSalesHeader: Record "Sales Header");
    begin
        SalesOrderLine."YVS Ref. SQ No." := BlanketOrderSalesLine."Document No.";
        SalesOrderLine."YVS Ref. SQ Line No." := BlanketOrderSalesLine."Line No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeInsertSalesOrderLine', '', false, false)]
    local procedure OnBeforeInsertSalesOrderLine(var SalesOrderLine: Record "Sales Line"; SalesOrderHeader: Record "Sales Header"; SalesQuoteLine: Record "Sales Line"; SalesQuoteHeader: Record "Sales Header");
    begin
        SalesOrderLine."YVS Ref. SQ No." := SalesQuoteLine."Document No.";
        SalesOrderLine."YVS Ref. SQ Line No." := SalesQuoteLine."Line No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnAfterInsertSalesOrderLine', '', false, false)]
    local procedure OnAfterInsertSalesOrderLine(SalesQuoteLine: Record "Sales Line");
    begin

        SalesQuoteLine."Outstanding Qty. (Base)" := 0;
        SalesQuoteLine."Outstanding Quantity" := 0;
        SalesQuoteLine."Completely Shipped" := (SalesQuoteLine.Quantity <> 0) and (SalesQuoteLine."Outstanding Quantity" = 0);
        SalesQuoteLine.Modify();

    end;



    [IntegrationEvent(false, false)]
    local procedure HandleMessagebeforPostSales(var Handle: Boolean)
    begin
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInitOutstandingQty', '', false, false)]
    local procedure "OnAfterInitOutstandingQty"(var SalesLine: Record "Sales Line")
    begin
        if SalesLine."Document Type" IN [SalesLine."Document Type"::Quote, SalesLine."Document Type"::Order] then begin
            SalesLine."Outstanding Quantity" := SalesLine.Quantity - SalesLine."Quantity Shipped" - SalesLine."YVS Qty. to Cancel";
            SalesLine."Outstanding Qty. (Base)" := SalesLine."Quantity (Base)" - SalesLine."Qty. Shipped (Base)" - SalesLine."YVS Qty. to Cancel (Base)";
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Invoice Posting Buffer", 'OnAfterPrepareSales', '', TRUE, TRUE)]

    /// <summary> 
    /// Description for InvoiceBufferSales.
    /// </summary>
    /// <param name="SalesLine">Parameter of type Record "Sales Line".</param>
    local procedure OnAfterPrepareSales(var InvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        VendCust: Record "YVS Customer & Vendor Branch";
    begin
        IF SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.") THEN BEGIN
            InvoicePostingBuffer."YVS Head Office" := SalesHeader."YVS Head Office";
            InvoicePostingBuffer."YVS VAT Branch Code" := SalesHeader."YVS VAT Branch Code";
            InvoicePostingBuffer."YVS VAT Registration No." := SalesHeader."VAT Registration No.";
            InvoicePostingBuffer."YVS Tax Invoice Date" := SalesHeader."Document Date";
            InvoicePostingBuffer."YVS Tax Invoice Name" := SalesHeader."Bill-to Name";
            InvoicePostingBuffer."YVS Tax Invoice Name 2" := SalesHeader."Bill-to Name 2";
            InvoicePostingBuffer."YVS Tax Invoice Base" := SalesLine.Amount;
            InvoicePostingBuffer."YVS Tax Invoice Amount" := SalesLine."Amount Including VAT" - SalesLine.Amount;
            InvoicePostingBuffer."YVS Address" := SalesHeader."Bill-to Address";
            InvoicePostingBuffer."YVS Address 2" := SalesHeader."Bill-to Address 2";
            InvoicePostingBuffer."YVS City" := SalesHeader."Bill-to city";
            InvoicePostingBuffer."YVS Post Code" := SalesHeader."Bill-to Post Code";
            if not SalesHeader."YVS Head Office" then
                if VendCust.Get(VendCust."Source Type"::Customer, SalesHeader."Bill-to Customer No.", SalesHeader."YVS Head Office", SalesHeader."YVS VAT Branch Code") then begin
                    if VendCust."Title Name" <> '' then
                        InvoicePostingBuffer."YVS Tax Invoice Name" := format(VendCust."Title Name") + ' ' + VendCust."Name"
                    else
                        InvoicePostingBuffer."YVS Tax Invoice Name" := VendCust."Name";
                    InvoicePostingBuffer."YVS Address" := VendCust."Address";
                    InvoicePostingBuffer."YVS Address 2" := VendCust."Address 2";
                    InvoicePostingBuffer."YVS city" := VendCust."Province";
                    InvoicePostingBuffer."YVS Post Code" := VendCust."Post Code";
                end;
        END;
        InvoicePostingBuffer."YVS Description Line" := SalesLine.Description;
        InvoicePostingBuffer."YVS Document Line No." := SalesLine."Line No.";

        IF (InvoicePostingBuffer.Type = InvoicePostingBuffer.Type::"G/L Account") OR (InvoicePostingBuffer.Type = InvoicePostingBuffer.Type::"Fixed Asset") THEN
            InvoicePostingBuffer."YVS Line No." := SalesLine."Line No.";

    end;


    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPrepareSales', '', TRUE, TRUE)]

    local procedure "OnAfterInvPostBufferPrepareSales"(var InvoicePostBuffer: Record "Invoice Post. Buffer" temporary; var SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        VendCust: Record "YVS Customer & Vendor Branch";
    begin
        IF SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.") THEN BEGIN
            InvoicePostBuffer."YVS Head Office" := SalesHeader."YVS Head Office";
            InvoicePostBuffer."YVS VAT Branch Code" := SalesHeader."YVS VAT Branch Code";
            InvoicePostBuffer."YVS VAT Registration No." := SalesHeader."VAT Registration No.";
            InvoicePostBuffer."YVS Tax Invoice Date" := SalesHeader."Document Date";
            InvoicePostBuffer."YVS Tax Invoice Name" := SalesHeader."Bill-to Name";
            InvoicePostBuffer."YVS Tax Invoice Name 2" := SalesHeader."Bill-to Name 2";
            InvoicePostBuffer."YVS Tax Invoice Base" := SalesLine.Amount;
            InvoicePostBuffer."YVS Tax Invoice Amount" := SalesLine."Amount Including VAT" - SalesLine.Amount;
            InvoicePostBuffer."YVS Address" := SalesHeader."Bill-to Address";
            InvoicePostBuffer."YVS Address 2" := SalesHeader."Bill-to Address 2";
            InvoicePostBuffer."YVS City" := SalesHeader."Bill-to city";
            InvoicePostBuffer."YVS Post Code" := SalesHeader."Bill-to Post Code";
            if not SalesHeader."YVS Head Office" then
                if VendCust.Get(VendCust."Source Type"::Customer, SalesHeader."Bill-to Customer No.", SalesHeader."YVS Head Office", SalesHeader."YVS VAT Branch Code") then begin
                    if VendCust."Title Name" <> '' then
                        InvoicePostBuffer."YVS Tax Invoice Name" := format(VendCust."Title Name") + ' ' + VendCust."Name"
                    else
                        InvoicePostBuffer."YVS Tax Invoice Name" := VendCust."Name";
                    InvoicePostBuffer."YVS Address" := VendCust."Address";
                    InvoicePostBuffer."YVS Address 2" := VendCust."Address 2";
                    InvoicePostBuffer."YVS city" := VendCust."Province";
                    InvoicePostBuffer."YVS Post Code" := VendCust."Post Code";
                end;


        END;
        InvoicePostBuffer."YVS Description Line" := SalesLine.Description;
        InvoicePostBuffer."YVS Document Line No." := SalesLine."Line No.";

        IF (InvoicePostBuffer.Type = InvoicePostBuffer.Type::"G/L Account") OR (InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset") THEN
            InvoicePostBuffer."YVS Line No." := SalesLine."Line No.";

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterCheckSalesApprovalPossible', '', false, false)]
    local procedure "OnSendSalesDocForApproval"(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        Item: Record Item;
    begin
        SalesLine.reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Location Code", '%1', '');
        if SalesLine.FindFirst() then begin
            Item.Get(SalesLine."No.");
            if NOT (Item.Type IN [Item.Type::Service, item.Type::"Non-Inventory"]) then
                SalesLine.TestField("Location Code");
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order (Yes/No)", 'OnBeforeConfirmConvertToOrder', '', false, false)]
    local procedure OnBeforeConfirmConvertToOrder(SalesHeader: Record "Sales Header"; var IsHandled: Boolean; var Result: Boolean)
    var
        text001Msg: Label 'this document has been order no. %1', Locked = true;
    begin
        SalesHeader.TestField(Status, SalesHeader.Status::Released);
        if SalesHeader."YVS Sales Order No." <> '' then begin
            MESSAGE(StrSubstNo(text001Msg, SalesHeader."YVS Sales Order No."));
            IsHandled := true;
            Result := false;
        end;
    end;

}
