/// <summary>
/// PageExtension ExtenPurchaPayablesSetup (ID 80005) extends Record Purchases Payables Setup.
/// </summary>
pageextension 80005 "YVS ExtenPurchaPayablesSetup" extends "Purchases & Payables Setup"
{
    layout
    {
        addlast("Number Series")
        {

            field("Purchase VAT Nos."; rec."YVS Purchase VAT Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Purchase VAT Nos. field.';
            }

        }
        addafter("Quote Nos.")
        {
            field("YVS Purchase Request Nos."; rec."YVS Purchase Request Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Purchase Request Nos. field.';
            }
        }
    }
}