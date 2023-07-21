/// <summary>
/// Query YVS Groupping WHT Transaction (ID 80000).
/// </summary>
query 80000 "YVS Groupping WHT Transaction"
{
    Caption = 'Groupping WHT Transaction';
    QueryType = Normal;

    elements
    {
        dataitem(NCTTaxWHTLine; "YVS Tax & WHT Line")
        {
            column(TaxType; "Tax Type")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(WHTCertificateNo; "WHT Certificate No.")
            {
            }

            column(CountLine)
            {
                Method = Count;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
