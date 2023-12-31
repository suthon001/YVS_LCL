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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"YVS Journal Function", 'OnbeforInsertWHTAPPLYGL', '', false, false)]
    local procedure OnbeforInsertWHTAPPLYGL()
    begin
        TempWHTApplied.reset();
        TempWHTApplied.deleteall();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"YVS Purchase Function", 'OnbeforInsertWHTAPPLY', '', false, false)]
    local procedure OnbeforInsertWHTAPPLY()
    begin
        TempWHTApplied.reset();
        TempWHTApplied.deleteall();
    end;

    var

        TempWHTApplied: Record "YVS WHT Applied Entry" temporary;
        PostingPreviewEventHandler: Codeunit "Posting Preview Event Handler";
}
