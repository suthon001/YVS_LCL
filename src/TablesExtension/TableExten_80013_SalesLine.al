/// <summary>
/// TableExtension YVS ExtenSales Line (ID 80013) extends Record Sales Line.
/// </summary>
tableextension 80013 "YVS ExtenSales Line" extends "Sales Line"
{
    fields
    {

        field(80000; "YVS WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "YVS WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(80001; "YVS WHT Product Posting Group"; Code[10])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "YVS WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;
        }

        field(80002; "YVS Qty. to Cancel"; Decimal)
        {
            Caption = 'Qty. to Cancel';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                UOMMgt: Codeunit "Unit of Measure Management";
            begin
                if not Confirm('Do you want Cancel Qty. ? ') then begin
                    rec."YVS Qty. to Cancel" := xRec."YVS Qty. to Cancel";
                    exit;
                end;
                IF ("Document Type" = "Document Type"::Order) THEN BEGIN
                    IF "Outstanding Quantity" = 0 THEN
                        ERROR('Outstanding Quantity must not be 0');

                    IF "YVS Qty. to Cancel" > (Quantity - "Quantity Shipped") THEN
                        ERROR('Remaining Qty. is %1', rec.Quantity - rec."Quantity Shipped");

                    "YVS Qty. to Cancel (Base)" := UOMMgt.CalcBaseQty("YVS Qty. to Cancel", "Qty. per Unit of Measure");
                    InitOutstanding();

                    VALIDATE("Qty. to Ship", "Outstanding Quantity");
                END ELSE
                    IF ("Document Type" = "Document Type"::"Blanket Order") THEN BEGIN
                        IF "YVS Qty. to Cancel" > Quantity THEN
                            ERROR('Remaining Qty. is %1', rec.Quantity);

                        "YVS Qty. to Cancel (Base)" := UOMMgt.CalcBaseQty("YVS Qty. to Cancel", "Qty. per Unit of Measure");
                        InitOutstanding();
                    END;
            end;
        }
        field(80003; "YVS Qty. to Cancel (Base)"; Decimal)
        {
            Caption = 'Qty. to Cancel (Base)';
            DataClassification = SystemMetadata;
            Editable = false;
        }

        field(80004; "YVS Ref. SQ No."; Code[30])
        {
            Editable = false;
            Caption = 'Ref. SQ No.';
            DataClassification = CustomerContent;
        }
        field(80005; "YVS Ref. SQ Line No."; Integer)
        {
            Editable = false;
            Caption = 'Ref. SQ Line No.';
            DataClassification = CustomerContent;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                if type = Type::"G/L Account" then
                    if "No." = '' then
                        Validate("Gen. Prod. Posting Group", '')


            end;
        }
    }

    /// <summary>
    /// GetLastLine.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure GetLastLine(): Integer
    var
        salesLine: Record "Sales Line";
    begin
        salesLine.reset();
        salesLine.ReadIsolation := IsolationLevel::UpdLock;
        salesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        salesLine.SetRange("Document Type", "Document Type");
        salesLine.SetRange("Document No.", "Document No.");
        if salesLine.FindLast() then
            EXIT(salesLine."Line No." + 10000);
        exit(10000);
    end;

}