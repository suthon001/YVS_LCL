/// <summary>
/// TableExtension YVS ExtenSalesInvoice Header (ID 80019) extends Record Sales Invoice Header.
/// </summary>
tableextension 80019 "YVS ExtenSalesInvoice Header" extends "Sales Invoice Header"
{
    fields
    {

        field(80000; "YVS WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "YVS WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(80001; "YVS Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
        }
        field(80002; "YVS VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            TableRelation = "YVS Customer & Vendor Branch"."VAT Branch Code" WHERE("Source Type" = CONST(Customer), "Source No." = FIELD("Sell-to Customer No."));
            DataClassification = CustomerContent;


        }
        field(80003; "YVS Ref. Tax Invoice Date"; Date)
        {
            Caption = 'Ref. Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80004; "YVS Ref. Tax Invoice No."; Code[20])
        {
            Caption = 'Ref. Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80005; "YVS Ref. Tax Invoice Amount"; Decimal)
        {
            Caption = 'Ref. Tax Invoice Amount';
            DataClassification = CustomerContent;
        }

        field(80006; "YVS Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80007; "YVS Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80008; "YVS Make Order No. Series"; Code[20])
        {
            Caption = 'Make Order No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series".Code;
        }
        field(80009; "YVS Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(89998; "YVS Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(89999; "YVS Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }

}