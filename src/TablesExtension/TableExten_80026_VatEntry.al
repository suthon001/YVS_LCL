/// <summary>
/// TableExtension YVS Vat Entry (ID 80026) extends Record VAT Entry.
/// </summary>
tableextension 80026 "YVS Vat Entry" extends "VAT Entry"
{
    fields
    {
        field(80001; "YVS Tax Invoice No."; Code[35])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80002; "YVS Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80003; "YVS Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = CustomerContent;

        }
        field(80004; "YVS Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            DataClassification = CustomerContent;
        }
        field(80005; "YVS Tax Vendor No."; Code[20])
        {
            Caption = 'Tax Vendor No.';
            DataClassification = CustomerContent;
            //TableRelation = Vendor."No.";
        }
        field(80006; "YVS Tax Invoice Name"; Text[120])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = CustomerContent;
        }
        field(80007; "YVS Description Line"; Text[250])
        {
            Caption = 'Description Line';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80008; "YVS Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;

        }
        field(80009; "YVS VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            DataClassification = CustomerContent;

        }
        field(80011; "YVS Tax Invoice Address"; Text[100])
        {
            Caption = 'Tax Invoice Address';
            DataClassification = SystemMetadata;

        }
        field(80012; "YVS Tax Invoice City"; Text[50])
        {
            Caption = 'Tax Invoice City';
            DataClassification = SystemMetadata;

        }
        field(80013; "YVS Tax Invoice Post Code"; Code[30])
        {
            Caption = 'Tax Invoice Post Code';
            DataClassification = SystemMetadata;

        }
        field(80014; "YVS Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = SystemMetadata;
        }
        field(80015; "YVS Tax Invoice Name 2"; Text[50])
        {
            Caption = 'Tax Invoice Name 2';
            DataClassification = CustomerContent;
        }
        field(80016; "YVS Tax Invoice Address 2"; Text[50])
        {
            Caption = 'Tax Invoice Address 2';
            DataClassification = SystemMetadata;

        }

    }
}