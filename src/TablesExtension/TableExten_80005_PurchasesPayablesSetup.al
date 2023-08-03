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
    }
}