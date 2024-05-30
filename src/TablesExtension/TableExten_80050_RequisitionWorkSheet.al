/// <summary>
/// TableExtension YVS Requisition WorkSheet (ID 80049) extends Record Requisition Line.
/// </summary>
tableextension 80049 "YVS Requisition WorkSheet" extends "Requisition Line"
{
    fields
    {
        field(80000; "YVS Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }

        field(80002; "YVS Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80003; "YVS Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80004; "YVS PR No. Series"; Code[20])
        {
            Caption = 'PR No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
    /// <summary> 
    /// Description for AssistEdit.
    /// </summary>
    /// <param name="OldReqLines">Parameter of type Record "Requisition Line".</param>
    /// <returns>Return variable "Boolean".</returns>
    procedure "AssistEdit"(OldReqLines: Record "Requisition Line"): Boolean
    var

        ReqWhs: Record "Requisition Wksh. Name";
        RequsitionLine: Record "Requisition Line";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        //  with RequsitionLine do begin
        RequsitionLine.Copy(Rec);
        ReqWhs.GET(RequsitionLine."Worksheet Template Name", RequsitionLine."Journal Batch Name");
        ReqWhs.TestField("YVS Document No. Series");
        IF NoSeriesMgt.LookupRelatedNoSeries(ReqWhs."YVS Document No. Series", OldReqLines."No. Series", RequsitionLine."No. Series") THEN BEGIN
            RequsitionLine."YVS Document No." := NoSeriesMgt.GetNextNo(RequsitionLine."No. Series");
            rec := RequsitionLine;
            EXIT(TRUE);
        END;
        // end;
    end;

    trigger OnInsert()
    var
        FuncenterYVS: Codeunit "YVS Function Center";
    begin
        if not FuncenterYVS.CheckDisableLCL() then
            exit;
        TestField("No.");
        "YVS Create By" := COPYSTR(UserId, 1, 50);
        "YVS Create DateTime" := CurrentDateTime();
    end;
}