/// <summary>
/// TableExtension YVS Return Shipment Line (ID 80059) extends Record Return Shipment Line.
/// </summary>
tableextension 80059 "YVS Return Shipment Line" extends "Return Shipment Line"
{
    fields
    {

        field(95000; "YVS Get to CN"; Boolean)
        {
            Caption = 'Get to CN';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
