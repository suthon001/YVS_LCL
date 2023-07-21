codeunit 80006 "WHT Preview Event Handler"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", 'OnGetEntries', '', false, false)]
    local procedure OnGetEntries(var RecRef: RecordRef; TableNo: Integer)
    begin
        if TableNo = DATABASE::"YVS WHT Applied Entry" then
            RecRef.GetTable(TempWHTApplied);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", 'OnAfterFillDocumentEntry', '', false, false)]
    local procedure OnAfterFillDocumentEntry(var DocumentEntry: Record "Document Entry" temporary)
    begin
        PostingPreviewEventHandler.InsertDocumentEntry(TempWHTApplied, DocumentEntry);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", 'OnAfterShowEntries', '', false, false)]
    local procedure OnAfterShowEntries(TableNo: Integer)
    var
        WHTAppliedEntry: Page "YVS WHT Applied Entry";
    begin
        if TableNo = Database::"YVS WHT Applied Entry" then begin
            CLEAR(WHTAppliedEntry);
            WHTAppliedEntry.Set(TempWHTApplied);
            WHTAppliedEntry.Run();
            Clear(WHTAppliedEntry);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"YVS WHT Applied Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertWHTApplyEntry(RunTrigger: Boolean; var Rec: Record "YVS WHT Applied Entry")
    begin
        if Rec.IsTemporary() then
            exit;
        PostingPreviewEventHandler.PreventCommit();
        TempWHTApplied := Rec;
        TempWHTApplied.Insert();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"YVS Purchase Function", 'OnbeforInsertWHTAPPLY', '', false, false)]
    local procedure OnbeforInsertWHTAPPLY()
    begin
        TempWHTApplied.reset();
        TempWHTApplied.deleteall();
    end;

    [EventSubscriber(ObjectType::Report, Report::"Carry Out Action Msg. - Req.", 'SetPODocumentNo', '', false, false)]
    local procedure SetPODocumentNo(PONoSeries: Code[20])
    begin
        gvPONoNories := PONoSeries;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Carry Out Action Msg. - Req.", 'OnUseOneJnlOnBeforeSetReqWkshMakeOrdersParameters', '', false, false)]
    local procedure OnUseOneJnlOnBeforeSetReqWkshMakeOrdersParameters()
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        newPoNoSeries: Code[20];
    begin
        if gvPONoNories <> '' then
            if NoSeriesMgt.SelectSeries(gvPONoNories, gvPONoNories, newPoNoSeries) then
                gvPONoNories := newPoNoSeries
            else
                ERROR('');
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnBeforePurchOrderHeaderInsert', '', false, false)]
    local procedure OnBeforePurchOrderHeaderInsert(var PurchaseHeader: Record "Purchase Header")
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if gvPONoNories <> '' then begin
            PurchaseHeader."No." := NoSeriesMgt.GetNextNo(gvPONoNories, WorkDate(), true);
            PurchaseHeader."No. Series" := gvPONoNories;
        end;
        CreatePONO := '';
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnAfterCode', '', false, false)]
    local procedure OnAfterCode()
    begin
        if CreatePONO <> '' then
            Message(CreatePONO);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnBeforeCheckInsertFinalizePurchaseOrderHeader', '', false, false)]
    local procedure OnBeforeCheckInsertFinalizePurchaseOrderHeader(RequisitionLine: Record "Requisition Line"; var PurchaseHeader: Record "Purchase Header"; var CheckInsert: Boolean)

    begin
        CheckInsert :=
            (PurchaseHeader."Buy-from Vendor No." <> RequisitionLine."Vendor No.") or
            (PurchaseHeader."Currency Code" <> RequisitionLine."Currency Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnInsertHeaderOnBeforeValidateSellToCustNoFromReqLine', '', false, false)]
    local procedure OnInsertHeaderOnBeforeValidateSellToCustNoFromReqLine(PurchOrderHeader: Record "Purchase Header")
    begin
        if CreatePONO <> '' then
            CreatePONO := CreatePONO + '\n';
        CreatePONO := CreatePONO + PurchOrderHeader."No.";
    end;

    var
        gvPONoNories: Code[20];
        CreatePONO: Text;
        TempWHTApplied: Record "YVS WHT Applied Entry" temporary;
        PostingPreviewEventHandler: Codeunit "Posting Preview Event Handler";
}
