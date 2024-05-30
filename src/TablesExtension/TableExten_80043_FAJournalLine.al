/// <summary>
/// TableExtension YVS FAJournalLine (ID 80043) extends Record FA Journal Line.
/// </summary>
tableextension 80043 "YVS FAJournalLine" extends "FA Journal Line"
{
    fields
    {
        field(80000; "YVS Document No. Series"; code[20])
        {
            Caption = 'Document No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }

    }
    /// <summary> 
    /// Description for AssistEdit.
    /// </summary>
    /// <param name="OldFaJournalLine">Parameter of type Record "FA Journal Line".</param>
    /// <returns>Return variable "Boolean".</returns>
    procedure "AssistEdit"(OldFaJournalLine: Record "FA Journal Line"): Boolean
    var
        FAJournalLine: Record "FA Journal Line";
        FaJournalBatch: Record "FA Journal Batch";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        // WITH FAJournalLine DO BEGIN
        FAJournalLine.COPY(Rec);
        FaJournalBatch.GET(FAJournalLine."Journal Template Name", FAJournalLine."Journal Batch Name");
        FaJournalBatch.TESTFIELD("YVS Document No. Series");
        IF NoSeriesMgt.LookupRelatedNoSeries(FaJournalBatch."YVS Document No. Series", OldFaJournalLine."YVS Document No. Series",
            FAJournalLine."YVS Document No. Series") THEN BEGIN
            FAJournalLine."Document No." := NoSeriesMgt.GetNextNo(FAJournalLine."YVS Document No. Series");
            Rec := FAJournalLine;
            EXIT(TRUE);
        END;
        //END;
    end;

}