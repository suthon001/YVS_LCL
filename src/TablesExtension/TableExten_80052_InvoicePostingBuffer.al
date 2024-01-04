/// <summary>
/// TableExtension ExtenInvoice Posting Buffer (ID 80052) extends Record Invoice Posting Buffer.
/// </summary>
tableextension 80052 "YVS Invoice Posting Buffer" extends "Invoice Posting Buffer"
{
    fields
    {
        field(80000; "YVS Tax Invoice No."; Code[35])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80001; "YVS Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80002; "YVS Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = CustomerContent;

        }
        field(80003; "YVS Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            DataClassification = CustomerContent;
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
            DataClassification = CustomerContent;
        }
        field(80006; "YVS Description Line"; Text[150])
        {
            Caption = 'Description Line';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80007; "YVS Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;

        }
        field(80008; "YVS VAT Branch Code"; Code[5])
        {
            Caption = 'Tax Branch No.';
            DataClassification = CustomerContent;

        }
        field(80009; "YVS Vat Registration No."; Text[20])
        {
            Caption = 'Tax Branch No.';
            DataClassification = CustomerContent;

        }
        field(80010; "YVS Line No."; Integer)
        {
            Caption = 'Tax Line No.';
            DataClassification = CustomerContent;

        }
        field(80011; "YVS Address"; Text[100])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(80012; "YVS City"; Text[50])
        {
            Caption = 'City';
            DataClassification = CustomerContent;
        }
        field(80013; "YVS Post Code"; Code[30])
        {
            Caption = 'Post Code';
            DataClassification = CustomerContent;
        }
        field(80014; "YVS Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = CustomerContent;
        }

        field(80015; "YVS Tax Invoice Name 2"; Text[50])
        {
            Caption = 'Tax Invoice Name 2';
            DataClassification = CustomerContent;
        }
        field(80016; "YVS Address 2"; Text[100])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;

        }

    }
}