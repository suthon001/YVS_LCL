/// <summary>
/// TableExtension YVS Purchase Rcpt. Line (ID 80029) extends Record Purch. Rcpt. Line.
/// </summary>
tableextension 80029 "YVS Purchase Rcpt. Line" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(80000; "YVS Qty. to Cancel"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. to Cancel';

        }
        field(80001; "YVS Qty. to Cancel (Base)"; Decimal)
        {
            Editable = false;
            DataClassification = SystemMetadata;
            Caption = 'Qty. to Cancel (Base)';
        }
        field(80002; "YVS Make Order By"; Code[50])
        {
            Caption = 'Make Order By';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(80003; "YVS Make Order DateTime"; DateTime)
        {
            Caption = 'Make Order DateTime';
            Editable = false;
            DataClassification = SystemMetadata;
        }

        field(80004; "YVS Ref. PQ No."; Code[30])
        {
            Caption = 'Ref. PR No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80005; "YVS Ref. PQ Line No."; Integer)
        {
            Caption = 'Ref. PR Line No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80006; "YVS WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "YVS WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;

        }
        field(80007; "YVS Tax Invoice No."; Code[20])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80008; "YVS Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80009; "YVS Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = CustomerContent;


        }
        field(80010; "YVS Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(80011; "YVS Tax Vendor No."; Code[20])
        {
            Caption = 'Tax Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";

        }
        field(80012; "YVS Tax Invoice Name"; Text[100])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = CustomerContent;
        }
        field(80013; "YVS Head Office"; Boolean)
        {
            Caption = 'Tax Head Office';
            DataClassification = CustomerContent;

        }
        field(80014; "YVS VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            DataClassification = CustomerContent;


        }
        field(80015; "YVS Vat Registration No."; Text[20])
        {
            Caption = 'Vat Registration No.';
            DataClassification = CustomerContent;
        }
        field(80016; "YVS WHT Product Posting Group"; Code[10])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "YVS WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;

        }

        field(80018; "YVS Tax Invoice Name 2"; Text[50])
        {
            Caption = 'Tax Invoice Name 2';
            DataClassification = CustomerContent;
        }
        field(80019; "YVS WHT %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'WHT %';
        }
        field(80020; "YVS WHT Base"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'WHT Base';
        }
        field(80021; "YVS WHT Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'WHT Amount';
        }
        field(80022; "YVS WHT Option"; Enum "YVS WHT Option")
        {
            Caption = 'WHT Option';
            DataClassification = CustomerContent;
        }
        field(80023; "YVS Original Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

        }
        field(95000; "YVS Get to Invoice"; Boolean)
        {
            Caption = 'Get to Invoice';
            DataClassification = CustomerContent;
            Editable = false;
        }

    }
}