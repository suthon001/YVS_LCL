/// <summary>
/// Table NC WHT Business Posting Group (ID 80003).
/// </summary>
table 80003 "YVS WHT Business Posting Group"
{
    Caption = 'WHT Business Posting Group';
    DrillDownPageID = "YVS WHT Business Posting Group";
    LookupPageID = "YVS WHT Business Posting Group";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "WHT Certificate Option"; Option)
        {
            Caption = 'WHT Certificate Option';
            OptionCaption = ' ,ภ.ง.ด.1ก.,ภ.ง.ด. 1ก.พิเศษ,ภ.ง.ด.2,ภ.ง.ด.3,ภ.ง.ด.2ก,ภ.ง.ด.3ก,ภ.ง.ด.53,ภ.ง.ด.54';
            OptionMembers = " ","ภ.ง.ด.1ก.","ภ.ง.ด. 1ก.พิเศษ","ภ.ง.ด.2","ภ.ง.ด.3","ภ.ง.ด.2ก","ภ.ง.ด.3ก","ภ.ง.ด.53","ภ.ง.ด.54";
            DataClassification = CustomerContent;
        }
        field(4; "WHT Certificate No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            Caption = 'WHT Certificate No. Series';
            DataClassification = CustomerContent;
        }
        field(5; "Type"; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Domestic Company,Foreign Company,Individual,No WHT';
            OptionMembers = "Domestic Company","Foreign Company",Individual,"No WHT";
            DataClassification = CustomerContent;
        }
        field(6; "Name"; Text[100])
        {
            Description = 'Name';
            DataClassification = CustomerContent;
        }
        field(7; "Name 2"; Text[50])
        {
            Description = 'Name 2';
            DataClassification = CustomerContent;
        }
        field(8; "Address"; Text[100])
        {
            Description = 'Address';
            DataClassification = CustomerContent;
        }
        field(9; "Address 2"; Text[50])
        {
            Description = 'Address 2';
            DataClassification = CustomerContent;
        }
        field(10; "Head Office"; boolean)
        {
            Description = 'Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Head Office" then
                    "VAT Branch Code" := '';
            end;

        }
        field(11; "VAT Branch Code"; Text[5])
        {
            Description = 'VAT Branch Code';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "VAT Branch Code" <> '' then begin
                    if StrLen("VAT Branch Code") < 5 then
                        Error('VAT Branch Code must be 5 characters');
                    "Head Office" := false;
                end;
                if "VAT Branch Code" = '00000' then begin
                    "Head Office" := TRUE;
                    "VAT Branch Code" := '';
                end;
            end;
        }
        field(12; "VAT Registration No."; Text[20])
        {
            Description = 'VAT Registration No.';
            DataClassification = CustomerContent;
        }
        field(13; "WHT Account No."; code[20])
        {
            Caption = 'WHT Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No." where("Account Type" = const(Posting), Blocked = const(false));
        }
        field(14; "WHT Type"; Enum "YVS WHT Type")
        {
            Caption = 'WHT Type';
            DataClassification = CustomerContent;

        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }


    }
    fieldgroups
    {
        fieldgroup("DropDown"; "Code", "Description") { }
    }
}

