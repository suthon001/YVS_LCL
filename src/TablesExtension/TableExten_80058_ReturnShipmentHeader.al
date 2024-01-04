/// <summary>
/// TableExtension YVS Return Shipment Header (ID 80058) extends Record Return Shipment Header.
/// </summary>
tableextension 80058 "YVS Return Shipment Header" extends "Return Shipment Header"
{
    fields
    {
        field(80000; "YVS Vendor Cr. Memo No."; Code[35])
        {
            Caption = 'Vendor Cr. Memo No.';
            DataClassification = CustomerContent;
        }
        field(80001; "YVS Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;

        }
        field(80002; "YVS VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            DataClassification = CustomerContent;

        }
    }
}
