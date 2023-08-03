/// <summary>
/// TableExtension YVS ExtenGeneral Ledger Setup (ID 80003) extends Record General Ledger Setup.
/// </summary>
tableextension 80003 "YVS ExtenGeneral Ledger Setup" extends "General Ledger Setup"
{
    fields
    {
        field(80000; "YVS No. of Copy WHT Cert."; Integer)
        {
            Caption = 'No. of Copy WHT Cert.';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(80002; "YVS WHT Certificate Caption 1"; Text[1024])
        {
            Caption = 'WHT Certificate Caption 1';
            DataClassification = CustomerContent;
        }
        field(80003; "YVS WHT Certificate Caption 2"; Text[1024])
        {
            Caption = 'WHT Certificate Caption 2';
            DataClassification = CustomerContent;
        }
        field(80004; "YVS WHT Certificate Caption 3"; Text[1024])
        {
            Caption = 'WHT Certificate Caption 3';
            DataClassification = CustomerContent;
        }
        field(80005; "YVS WHT Certificate Caption 4"; Text[1024])
        {
            Caption = 'WHT Certificate Caption 4';
            DataClassification = CustomerContent;
        }
        field(80006; "YVS WHT Document Nos."; Code[20])
        {
            Caption = 'WHT Document Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(80007; "YVS WHT03 Nos."; Code[20])
        {
            Caption = 'WHT03 Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(80008; "YVS WHT53 Nos."; Code[20])
        {
            Caption = 'WHT53 Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
    }
}