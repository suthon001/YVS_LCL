/// <summary>
/// TableExtension YVS ExtenSalesReceivableSetup (ID 80004) extends Record Sales  Receivables Setup.
/// </summary>
tableextension 80004 "YVS ExtenSales&ReceivableSetup" extends "Sales & Receivables Setup"
{
    fields
    {

        field(80000; "YVS Sales VAT Nos."; Code[20])
        {
            Caption = 'Sales VAT Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(80001; "YVS Sale Receipt Nos."; Code[20])
        {
            Caption = 'Sale Receipt Nos.';
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
        }
        field(80002; "YVS Default Prepaid WHT Acc."; code[20])
        {
            Caption = 'Default Prepaid WHT Acc.';
            TableRelation = "G/L Account"."No." where(Blocked = const(false), "Account Type" = const(Posting));
            DataClassification = CustomerContent;
        }

        field(80003; "YVS Default Bank Fee Acc."; code[20])
        {
            Caption = 'Default Bank Fee Acc.';
            TableRelation = "G/L Account"."No." where(Blocked = const(false), "Account Type" = const(Posting));
            DataClassification = CustomerContent;
        }
        field(80004; "YVS Default Diff Amount Acc."; code[20])
        {
            Caption = 'Default Diff Amount Acc.';
            TableRelation = "G/L Account"."No." where(Blocked = const(false), "Account Type" = const(Posting));
            DataClassification = CustomerContent;
        }
        field(80005; "YVS Default Cash Rec. Template"; code[10])
        {
            Caption = 'Default Default Cash Receipt Template';
            TableRelation = "Gen. Journal Template".Name;
            DataClassification = CustomerContent;
        }
    }
}