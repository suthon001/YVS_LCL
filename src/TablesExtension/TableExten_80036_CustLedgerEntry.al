/// <summary>
/// TableExtension YVS ExtenCustLedger Entry (ID 80036) extends Record Cust. Ledger Entry.
/// </summary>
tableextension 80036 "YVS ExtenCustLedger Entry" extends "Cust. Ledger Entry"
{
    fields
    {

        field(80000; "YVS Head Office"; Boolean)
        {
            Caption = 'Header Office';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80001; "YVS VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(80002; "YVS Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80003; "YVS Bank Code"; code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80004; "Bank Account No."; text[30])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;

        }
        field(80005; "YVS Bank Name"; Text[100])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80006; "YVS Cheque No."; code[35])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80007; "YVS Cheque Name"; Text[150])
        {
            Caption = 'Cheque Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80008; "YVS Cheque Date"; Date)
        {
            Caption = 'Check Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80009; "YVS Customer/Vendor No."; code[20])
        {
            Caption = 'Customer/Vendor No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80011; "YVS Receipt Amount"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Receipt Amount';
            Editable = false;
            CalcFormula = Sum("YVS Billing Receipt Line"."Amount" WHERE("Document Type" = filter('Sales Receipt'),
             "Source Ledger Entry No." = FIELD("Entry No."), "Status" = filter(<> "Posted")));
        }
        field(80012; "YVS Remaining Amt."; Decimal)
        {
            Caption = 'Remaining Amt.';
            Editable = false;
            DataClassification = CustomerContent;

        }
        field(80013; "YVS Aging Due Date"; Date)
        {
            Editable = false;
            Caption = 'Aging Due Date';
            DataClassification = CustomerContent;
        }
        field(80014; "YVS Billing Amount"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Billing Amount';
            Editable = false;
            CalcFormula = Sum("YVS Billing Receipt Line"."Amount" WHERE("Document Type" = filter('Sales Billing'),
             "Source Ledger Entry No." = FIELD("Entry No."), "Status" = filter(<> "Posted")));
        }
    }
}