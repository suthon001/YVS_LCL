/// <summary>
/// TableExtension YVS ExtenCheck Ledger Entry (ID 80039) extends Record Check Ledger Entry.
/// </summary>
tableextension 80039 "YVS ExtenCheck Ledger Entry" extends "Check Ledger Entry"
{
    fields
    {
        field(80000; "YVS Customer/Vendor No."; code[20])
        {
            Caption = 'Customer/Vendor No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80001; "YVS Bank Name"; Text[100])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80002; "YVS Cheque No."; code[35])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80003; "YVS Cheque Name"; Text[150])
        {
            Caption = 'Cheque Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80004; "YVS Cheque Date"; Date)
        {
            Caption = 'Check Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80005; "YVS Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionMembers = " ","Customer","Vendor";
            OptionCaption = ' ,Customer,Vendor';
            DataClassification = CustomerContent;
        }
        field(80006; "YVS Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80007; "YVS Bank Code"; code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
            Editable = false;
        }

    }
}