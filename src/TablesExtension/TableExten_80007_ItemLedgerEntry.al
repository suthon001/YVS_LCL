/// <summary>
/// TableExtension YVS ExtenItem Ledger Entry (ID 80007) extends Record Item Ledger Entry.
/// </summary>
tableextension 80007 "YVS ExtenItem Ledger Entry" extends "Item Ledger Entry"
{
    fields
    {

        field(80000; "YVS Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(80001; "YVS Cost Amount (Stock)"; Decimal)
        {
            Caption = 'Cost Amount (Stock)';
            DataClassification = SystemMetadata;
        }
        field(80002; "YVS Cost Amount (Actual Cal.)"; Decimal)
        {
            Caption = 'Cost Amount (Actual Cal.)';
            FieldClass = FlowField;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Item Ledger Entry No." = FIELD("Entry No."), "Posting Date" = FIELD("YVS Date Filter")));
            Editable = false;
        }

        field(80003; "YVS Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group".Code;
            DataClassification = SystemMetadata;
        }
        field(80004; "YVS Ref. Entry No."; Integer)
        {
            Caption = 'Ref. Entry No.';
            DataClassification = SystemMetadata;
        }
        field(80005; "YVS Vat Bus. Posting Group"; Code[20])
        {
            Caption = 'Vat Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
            DataClassification = SystemMetadata;
        }
        field(80006; "YVS Vendor/Customer Name"; Text[150])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Vendor/Customer Name';
        }
        field(80007; "YVS Bin Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Bin Code';
        }
        field(80008; "YVS Document Invoice No."; Code[30])
        {
            Caption = 'Document Invoice No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Value Entry"."Document No." WHERE("Item Ledger Entry No." = field("Entry No."), "Document Type" = filter("Purchase Credit Memo" | "Purchase Invoice" | "Sales Credit Memo" | "Sales Invoice")));
            Editable = false;
        }
    }
}