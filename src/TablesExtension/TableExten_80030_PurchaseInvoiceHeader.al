/// <summary>
/// TableExtension YVS Purchase Inv. Header (ID 80030) extends Record Purch. Inv. Header.
/// </summary>
tableextension 80030 "YVS Purchase Inv. Header" extends "Purch. Inv. Header"
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
            TableRelation = "YVS Customer & Vendor Branch"."VAT Branch Code" WHERE("Source Type" = CONST(Vendor), "Source No." = FIELD("Buy-from Vendor No."));
            DataClassification = CustomerContent;
        }
        field(80003; "YVS Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80004; "YVS Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80005; "YVS Purchase Order No."; Code[30])
        {
            Caption = 'Purchase Order No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80006; "YVS Make PO No.Series No."; Code[20])
        {
            Caption = 'Make PO No.Series No.';
            DataClassification = CustomerContent;

        }
    }
}