/// <summary>
/// PageExtension ExtenSalesReceSetup (ID 80004) extends Record Sales  Receivables Setup.
/// </summary>
pageextension 80004 "YVS ExtenSales & ReceSetup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast("Number Series")
        {

            field("Sales VAT Nos."; rec."YVS Sales VAT Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Sales VAT Nos. field.';
            }

        }
    }
}