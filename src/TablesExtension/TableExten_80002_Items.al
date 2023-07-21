/// <summary>
/// TableExtension YVS ExtenItems (ID 80002) extends Record Item.
/// </summary>
tableextension 80002 "YVS ExtenItems" extends Item
{
    fields
    {
        field(80000; "YVS WHT Product Posting Group"; Code[10])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "YVS WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;
        }
    }


    fieldgroups
    {
        addlast(DropDown; Inventory, "Item Category Code") { }
    }

}