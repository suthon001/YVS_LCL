/// <summary>
/// TableExtension YVS VatPostingSetup (ID 80040) extends Record VAT Posting Setup.
/// </summary>
tableextension 80040 "YVS VatPostingSetup" extends "VAT Posting Setup"
{
    fields
    {
        field(80000; "YVS Allow to Sales Vat"; Boolean)
        {
            Caption = 'Allow Generate Sales Vat';
            DataClassification = CustomerContent;
        }
        field(80001; "YVS Allow to Purch. Vat"; Boolean)
        {
            Caption = 'Allow Generate Purch. Vat';
            DataClassification = CustomerContent;
        }
    }
}