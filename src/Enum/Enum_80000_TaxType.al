/// <summary>
/// Enum YVS Tax Type (ID 80000).
/// </summary>
enum 80000 "YVS Tax Type"
{
    Extensible = true;
    value(0; "Purchase") { Caption = 'Purchase'; }
    value(1; Sale) { Caption = 'Sale'; }
    value(2; WHT03) { Caption = 'WHT03'; }
    value(3; WHT53) { Caption = 'WHT53'; }

}
