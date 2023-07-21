/// <summary>
/// TableExtension YVS ExtenPurchaPayablesSetup (ID 80005) extends Record Purchases Payables Setup.
/// </summary>
tableextension 80005 "YVS ExtenPurcha&PayablesSetup" extends "Purchases & Payables Setup"
{
    fields
    {

        field(80001; "YVS Purchase VAT Nos."; Code[20])
        {
            Caption = 'Purchase VAT Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(80002; "YVS WHT03 Nos."; Code[20])
        {
            Caption = 'WHT03 Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(80003; "YVS WHT53 Nos."; Code[20])
        {
            Caption = 'WHT53 Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
    }
}