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
            field("YVS Sale Receipt Nos."; rec."YVS Sale Receipt Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Sales Receipt Nos. field.';
            }
        }
        addafter("Number Series")
        {
            group(SalesReceiptInformation)
            {
                Caption = 'Sales Receipt Information';
                field("YVS Default Prepaid WHT Acc."; rec."YVS Default Prepaid WHT Acc.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Default Prepaid WHT Acc. field.';
                }
                field("YVS Default Bank Fee Acc."; rec."YVS Default Bank Fee Acc.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Default Bank Fee Acc. field.';
                }
                field("YVS Default Diff Amount Acc."; rec."YVS Default Diff Amount Acc.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Default Diff Amount Acc. field.';
                }
            }
        }
    }
}