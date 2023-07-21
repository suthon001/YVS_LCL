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
            field("WHT03 Nos."; rec."YVS WHT03 Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the WHT03 Nos. field.';
            }
            field("WHT53 Nos."; rec."YVS WHT53 Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the WHT53 Nos. field.';
            }
        }
    }
}