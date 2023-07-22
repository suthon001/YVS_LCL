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
    }
}