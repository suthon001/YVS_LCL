/// <summary>
/// TableExtension YVS ExtenItem Journal Line (ID 80015) extends Record Item Journal Line.
/// </summary>
tableextension 80015 "YVS ExtenItem Journal Line" extends "Item Journal Line"
{
    fields
    {

        field(80000; "YVS Status"; Enum "Purchase Document Status")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Status';
        }

        field(80001; "YVS Document No. Series"; code[20])
        {
            Caption = 'Document No. Series';
            TableRelation = "No. Series".Code;
            DataClassification = SystemMetadata;
        }
        field(80002; "YVS Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(80003; "YVS Vat Bus. Posting Group"; Code[20])
        {
            Caption = 'Vat Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
            DataClassification = SystemMetadata;
        }
        field(80004; "YVS Vendor/Customer Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Vendor/Customer Name';
        }
        field(80005; "YVS Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80006; "YVS Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80007; "YVS Temp. Bin Code"; code[20])
        {
            Caption = 'Temp. Bin Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80008; "YVS Temp. New Bin Code"; code[20])
        {
            Caption = 'Temp. New Bin Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        modify("Bin Code")
        {
            trigger OnAfterValidate()
            begin
                "YVS Temp. Bin Code" := "Bin Code";
            end;
        }
        modify("New Bin Code")
        {
            trigger OnAfterValidate()
            begin
                "YVS Temp. New Bin Code" := "New Bin Code";
            end;
        }
    }



    trigger OnInsert()
    begin
        "YVS Create By" := COPYSTR(USERID, 1, 50);
        "YVS Create DateTime" := CurrentDateTime;
    end;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldItemJournalLine">Record "Item Journal Line".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldItemJournalLine: Record "Item Journal Line"): Boolean
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalBatch: Record "Item Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin

        ItemJournalLine.COPY(Rec);
        ItemJournalBatch.GET(ItemJournalLine."Journal Template Name", ItemJournalLine."Journal Batch Name");
        ItemJournalBatch.TESTFIELD("YVS Document No. Series");
        IF NoSeriesMgt.SelectSeries(ItemJournalBatch."YVS Document No. Series", OldItemJournalLine."YVS Document No. Series",
            ItemJournalLine."YVS Document No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(ItemJournalLine."Document No.");
            Rec := ItemJournalLine;
            EXIT(TRUE);
        END;
    end;

    /// <summary>
    /// GetLastLine.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure GetLastLine(): Integer
    var
        ItemJournalLine: Record "Item Journal Line";
    begin
        ItemJournalLine.reset();
        ItemJournalLine.ReadIsolation := IsolationLevel::UpdLock;
        ItemJournalLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
        ItemJournalLine.SetRange("Journal Template Name", "Journal Template Name");
        ItemJournalLine.SetRange("Journal Batch Name", "Journal Batch Name");
        if ItemJournalLine.FindLast() then
            exit(ItemJournalLine."Line No." + 10000);
        exit(10000);
    end;

}