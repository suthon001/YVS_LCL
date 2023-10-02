/// <summary>
/// Enum YVS Document Type Report (ID 80009).
/// </summary>
enum 80009 "YVS Document Type Report"
{
    Extensible = true;
    value(0; "Sales Quote") { Caption = 'Sales Quote'; }
    value(1; "Sales Order") { Caption = 'Sales Order'; }
    value(2; "Sales Invoice") { Caption = 'Sales Invoice'; }
    value(3; "Sales Credit Memo") { Caption = 'Sales Credit Memo'; }
    value(4; "Sales Receipt") { Caption = 'Sales Receipt'; }
}
