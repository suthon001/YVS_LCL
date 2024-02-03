/// <summary>
/// TableExtension YVS ExtenVendorLedger Entry (ID 80037) extends Record Vendor Ledger Entry.
/// </summary>
tableextension 80037 "YVS ExtenVendorLedger Entry" extends "Vendor Ledger Entry"
{
    fields
    {


        field(80000; "YVS Head Office"; Boolean)
        {
            Caption = 'Header Office';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80001; "YVS VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80002; "YVS Customer/Vendor No."; code[20])
        {
            Caption = 'Customer/Vendor No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80003; "YVS Bank Name"; Text[100])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80004; "YVS Cheque No."; code[35])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80005; "YVS Cheque Name"; Text[150])
        {
            Caption = 'Cheque Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80006; "YVS Cheque Date"; Date)
        {
            Caption = 'Check Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80007; "YVS Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80008; "YVS Bank Code"; code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80009; "YVS Bank Account No."; text[30])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;

        }
        field(80010; "YVS Ref. Prepayment PO No."; code[20])
        {
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Ref. Prepayment PO No.';

        }
    }
}