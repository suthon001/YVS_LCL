/// <summary>
/// Codeunit YVS Purch.-Req to Order (ID 80014).
/// </summary>
codeunit 80014 "YVS Purch.-Req to Order"
{
    TableNo = "Purchase Header";

    trigger OnRun()
    var
        ConfirmManagement: Codeunit "Confirm Management";
        IsHandled: Boolean;
    begin
        rec.TestField("Document Type", rec."Document Type"::"YVS Purchase Request");
        if not ConfirmManagement.GetResponseOrDefault(ConvertQuoteToOrderQst, true) then
            exit;

        IsHandled := false;
        OnBeforePurchQuoteToOrder(Rec, IsHandled);
        if IsHandled then
            exit;

        PurchQuoteToOrder.Run(Rec);
        PurchQuoteToOrder.GetPurchOrderHeader(PurchOrderHeader);

        IsHandled := false;
        OnAfterCreatePurchOrder(PurchOrderHeader, IsHandled);
        if not IsHandled then
            if ConfirmManagement.GetResponseOrDefault(StrSubstNo(OpenNewOrderQst, PurchOrderHeader."No."), true) then
                PAGE.Run(PAGE::"Purchase Order", PurchOrderHeader);
    end;

    var
        ConvertQuoteToOrderQst: Label 'Do you want to convert the purchase request to an order?';
        PurchOrderHeader: Record "Purchase Header";
        PurchQuoteToOrder: Codeunit "Purch.-Quote to Order";
        OpenNewOrderQst: Label 'The quote has been converted to order number %1. Do you want to open the new order?', Comment = '%1 - No. of new purchase order.';

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePurchOrder(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePurchQuoteToOrder(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
    end;
}

