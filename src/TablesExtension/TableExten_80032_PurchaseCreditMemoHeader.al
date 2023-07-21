/// <summary>
/// TableExtension YVS Purchase Cr. Memo Header (ID 80032) extends Record Purch. Cr. Memo Hdr..
/// </summary>
tableextension 80032 "YVS Purchase Cr. Memo Header" extends "Purch. Cr. Memo Hdr."
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
            // TableRelation = "No. Series".Code;
            Caption = 'Make PO No.Series No.';
            DataClassification = CustomerContent;

        }
    }
}