/// <summary>
/// PageExtension ApplyVendLedgEntry (ID 80054) extends Record Apply Vendor Entries.
/// </summary>
pageextension 80054 "YVS ApplyVendLedgEntry" extends "Apply Vendor Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("LS Purch. Billing No."; PurchBillingDocNo)
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the PurchBillingDocNo field.';
                Caption = 'Purchase Billing No.';
            }
        }
    }



    var
        PurchBillingDocNo: Code[20];
}