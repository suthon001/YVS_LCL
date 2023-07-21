/// <summary>
/// TableExtension YVS ExtenSalesCr.MemoLine (ID 80022) extends Record Sales Cr.Memo Line.
/// </summary>
tableextension 80022 "YVS ExtenSalesCr.MemoLine" extends "Sales Cr.Memo Line"
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
    }

}