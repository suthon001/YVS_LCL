/// <summary>
/// PageExtension VatPostingSetupLists (ID 80057) extends Record VAT Posting Setup.
/// </summary>
pageextension 80057 "YVS VatPostingSetupLists" extends "VAT Posting Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("YVS Allow to Purch. Vat"; rec."YVS Allow to Purch. Vat")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Generate Purch. Vat Report field.';
            }
            field("YVS Allow to Sales Vat"; rec."YVS Allow to Sales Vat")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Generate Sales Vat Report field.';
            }
        }
    }
}