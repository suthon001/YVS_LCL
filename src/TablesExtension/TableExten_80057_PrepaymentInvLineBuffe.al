/// <summary>
/// TableExtension YVS Prepayment Inv. Line Buffe (ID 80057) extends Record Prepayment Inv. Line Buffer.
/// </summary>
tableextension 80057 "YVS Prepayment Inv. Line Buffe" extends "Prepayment Inv. Line Buffer"
{
    fields
    {
        field(80000; "YVS Tax Invoice No."; Code[35])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = SystemMetadata;
        }
        field(80001; "YVS Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = SystemMetadata;
        }
        field(80002; "YVS Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = SystemMetadata;

        }
        field(80003; "YVS Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            DataClassification = SystemMetadata;
        }
        field(80004; "YVS Tax Vendor No."; Code[20])
        {
            Caption = 'Tax Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(80005; "YVS Tax Invoice Name"; Text[120])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = SystemMetadata;
        }
        field(80006; "YVS Description Line"; Text[150])
        {
            Caption = 'Description Line';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80007; "YVS Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = SystemMetadata;

        }
        field(80008; "YVS VAT Branch Code"; Code[5])
        {
            Caption = 'Tax Branch No.';
            DataClassification = SystemMetadata;

        }
        field(80009; "YVS Vat Registration No."; Text[20])
        {
            Caption = 'Tax Branch No.';
            DataClassification = SystemMetadata;

        }
        field(80010; "YVS Line No."; Integer)
        {
            Caption = 'Tax Line No.';
            DataClassification = SystemMetadata;

        }
        field(80011; "YVS Address"; Text[100])
        {
            Caption = 'Address';
            DataClassification = SystemMetadata;
        }
        field(80012; "YVS City"; Text[50])
        {
            Caption = 'City';
            DataClassification = SystemMetadata;
        }
        field(80013; "YVS Post Code"; Code[30])
        {
            Caption = 'Post Code';
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
        field(80016; "YVS Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = SystemMetadata;

        }
    }
}
