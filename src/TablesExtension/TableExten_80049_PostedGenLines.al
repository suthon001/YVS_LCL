/// <summary>
/// TableExtension YVS ExtenPostedGenLines (ID 80050) extends Record Posted Gen. Journal Line.
/// </summary>
tableextension 80050 "YVS ExtenPostedGenLines" extends "Posted Gen. Journal Line"
{
    fields
    {
        field(80000; "YVS Document No. Series"; Code[20])
        {
            Caption = 'Document No. Series';
            DataClassification = CustomerContent;
        }
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
            Caption = 'Tax Vendor/Cutomer No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Gen. Posting Type" = filter(Purchase)) Vendor."no."
            else
            IF ("Gen. Posting Type" = filter(Sale)) Customer."No."
            else
            IF ("Gen. Posting Type" = filter(" "), "YVS Template Source Type" = filter("Cash Receipts")) Customer."No."
            else
            Vendor."No.";
        }
        field(80006; "YVS Tax Invoice Name"; Text[120])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = CustomerContent;
        }
        field(80007; "YVS Description Line"; Text[150])
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
        field(80010; "YVS Description Voucher"; Text[250])
        {
            Caption = 'Description Voucher';
            DataClassification = CustomerContent;
        }
        field(80011; "YVS WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "YVS WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(80012; "YVS WHT Product Posting Group"; Code[10])
        {
            Caption = 'Product Posting Group';
            TableRelation = "YVS WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;

        }
        field(80013; "YVS WHT Name"; text[100])
        {
            Caption = 'WHT Name';
            DataClassification = CustomerContent;
        }
        field(80014; "YVS WHT Name 2"; text[50])
        {
            Caption = 'WHT Name 2';
            DataClassification = CustomerContent;
        }
        field(80015; "YVS WHT Address"; Text[100])
        {
            Caption = 'WHT Address';
            DataClassification = CustomerContent;
        }
        field(80016; "YVS WHT Address 2"; Text[50])
        {
            Caption = 'WHT Address 2';
            DataClassification = CustomerContent;
        }
        field(80017; "YVS WHT Post Code"; Code[20])
        {
            Caption = 'WHT Post Code';
            DataClassification = CustomerContent;
        }
        field(80018; "YVS WHT City"; Text[50])
        {
            Caption = 'WHT City';
            DataClassification = CustomerContent;
        }
        field(80019; "YVS WHT County"; Text[50])
        {
            Caption = 'WHT County';
            DataClassification = CustomerContent;
        }
        field(80020; "YVS WHT Country Code"; Code[10])
        {
            Caption = 'WHT Country Code';
            DataClassification = CustomerContent;
        }
        field(80021; "YVS WHT Registration No."; Text[20])
        {
            Caption = 'WHT Registration No.';
            DataClassification = CustomerContent;
        }
        field(80022; "YVS WHT Base"; Decimal)
        {
            Caption = 'WHT Base';
            DataClassification = CustomerContent;

        }
        field(80023; "YVS WHT Amount"; Decimal)
        {
            Caption = 'WHT Amount';
            DataClassification = CustomerContent;
        }
        field(80024; "YVS WHT Revenue Type"; Code[10])
        {
            Caption = 'WHT Revenue Type';
            DataClassification = CustomerContent;
        }
        field(80025; "YVS WHT Revenue Description"; Text[50])
        {
            Caption = 'WHT Revenue Description';
            DataClassification = CustomerContent;
        }
        field(80026; "YVS WHT %"; Decimal)
        {
            Caption = 'WHT %';
            DataClassification = CustomerContent;
        }
        field(80027; "YVS WHT Document No."; Code[30])
        {
            Caption = 'WHT Document No.';
            DataClassification = CustomerContent;
        }
        field(80028; "YVS WHT Option"; Enum "YVS WHT Option")
        {
            Caption = 'WHT Option';
            DataClassification = CustomerContent;
        }
        field(80029; "YVS WHT No. Series"; Code[20])
        {
            Caption = 'WHT No. Series';
            DataClassification = CustomerContent;
        }
        field(80030; "YVS WHT Date"; Date)
        {
            Caption = 'WHT Date';
            DataClassification = CustomerContent;
        }
        field(80031; "YVS Bank Code"; Code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
            TableRelation = "Bank Account"."No.";


        }
        field(80032; "YVS Bank Name"; Text[100])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;

        }
        field(80033; "YVS Bank Account No."; text[20])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;

        }
        field(80034; "YVS Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            DataClassification = CustomerContent;

        }
        field(80035; "YVS Cheque No."; Text[35])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;


        }
        field(80036; "YVS Cheque Date"; Date)
        {
            Caption = 'Cheque Date';
            DataClassification = CustomerContent;

        }
        field(80037; "YVS Pay Name"; Text[100])
        {
            Caption = 'Pay Name';
            DataClassification = CustomerContent;
        }

        field(80038; "YVS WHT Vendor No."; Code[20])
        {
            Caption = 'WHT Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";

        }
        field(80039; "YVS Tax Invoice Address"; Code[100])
        {
            Caption = 'Tax Invoice Address';
            DataClassification = CustomerContent;
        }
        field(80040; "YVS Tax Invoice City"; text[50])
        {
            Caption = 'Tax Invoice City';
            DataClassification = CustomerContent;
        }
        field(80041; "YVS Tax Invoice Post Code"; Code[30])
        {
            Caption = 'Tax Invoice Post Code';
            DataClassification = CustomerContent;
        }
        field(80042; "YVS Require Screen Detail"; Enum "YVS Require Screen Detail")
        {
            Caption = 'Require Screen Detail';
            DataClassification = CustomerContent;
        }
        field(80043; "YVS Customer/Vendor No."; code[20])
        {
            Caption = 'Customer/Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("YVS Template Source Type" = filter("Cash Receipts")) Customer."No."
            else
            Vendor."No.";


        }


        field(80044; "YVS Cheque Name"; Text[100])
        {
            Caption = 'Cheque Name';
            DataClassification = CustomerContent;

        }
        field(80045; "YVS Journal Description"; Text[250])
        {

            Caption = 'Journal Description';
            DataClassification = CustomerContent;
        }
        field(80046; "YVS WHT Cust/Vend No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'WHT Cust/Vend No.';
        }
        field(80047; "YVS Tax Invoice Name 2"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Tax Invoice Name 2';
        }

        field(80048; "YVS Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80049; "YVS Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80050; "YVS Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80051; "YVS Tax Invoice Address 2"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Tax Invoice Address 2';
        }
        field(80052; "YVS Template Source Type"; Enum "Gen. Journal Template Type")
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Gen. Journal Template".Type where(Name = field("Journal Template Name")));
            Caption = 'Template Source Type';
        }


    }
}