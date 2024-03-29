/// <summary>
/// EnumExtension YVS ApproveEntryDocType (ID 80000) extends Record Approval Document Type.
/// </summary>
enumextension 80000 "YVS ApproveEntryDocType" extends "Approval Document Type"
{
    value(80000; "YVS Sales Receipt")
    {
        Caption = 'Sales Receipt';
    }
    value(80001; "YVS Purchase Request")
    {
        Caption = 'Purchase Request';
    }
    value(80002; "YVS Sales Billing")
    {
        Caption = 'Sales Billing';
    }
}