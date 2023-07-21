/// <summary>
/// TableExtension YVS VATBusinessPostingGroup (ID 80023) extends Record VAT Business Posting Group.
/// </summary>
tableextension 80023 "YVS VATBusinessPostingGroup" extends "VAT Business Posting Group"
{
    fields
    {
        field(80000; "YVS Company Name (Thai)"; Text[100])
        {
            Caption = 'Company Name (Thai)';
            DataClassification = CustomerContent;
        }
        field(80001; "YVS Company Name 2 (Thai)"; Text[50])
        {
            Caption = 'Company Name 2 (Thai)';
            DataClassification = CustomerContent;
        }
        field(80002; "YVS Company Address (Thai)"; Text[100])
        {
            Caption = 'Company Address (Thai)';
            DataClassification = CustomerContent;
        }
        field(80003; "YVS Company Address 2 (Thai)"; Text[50])
        {
            Caption = 'Company Address 2 (Thai)';
            DataClassification = CustomerContent;
        }
        field(80004; "YVS Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()

            begin
                if "YVS Head Office" then
                    "YVS VAT Branch Code" := '';

            end;

        }
        field(80005; "YVS VAT Branch Code"; code[5])
        {
            Caption = 'VAT Branch Code';
            DataClassification = CustomerContent;
            trigger OnValidate()

            begin
                if "YVS VAT Branch Code" <> '' then begin
                    if StrLen("YVS VAT Branch Code") < 5 then
                        Error('VAT Branch Code must be 5 characters');
                    "YVS Head Office" := false;
                end;
                if "YVS VAT Branch Code" = '00000' then begin
                    "YVS Head Office" := TRUE;
                    "YVS VAT Branch Code" := '';

                end;

            end;
        }
        field(80006; "YVS VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = CustomerContent;
        }
        field(80007; "YVS Phone No."; Text[20])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
        }
        field(80008; "YVS Fax No."; Text[20])
        {
            Caption = 'Fax No.';
            DataClassification = CustomerContent;
        }
        field(80009; "YVS Email"; Text[100])
        {
            Caption = 'E-mail';
            DataClassification = CustomerContent;
        }
        field(80010; "YVS City (Thai)"; Text[30])
        {
            Caption = 'City (Thai)';
            DataClassification = CustomerContent;
        }
        field(80012; "YVS Post code"; Code[20])
        {
            Caption = 'Post code';
            DataClassification = CustomerContent;
        }

        field(80013; "YVS Company Name (Eng)"; Text[100])
        {
            Caption = 'Company Name (Eng)';
            DataClassification = CustomerContent;
        }
        field(80014; "YVS Company Name 2 (Eng)"; Text[50])
        {
            Caption = 'Company Name 2 (Eng)';
            DataClassification = CustomerContent;
        }
        field(80015; "YVS Company Address (Eng)"; Text[100])
        {
            Caption = 'Company Address (Eng)';
            DataClassification = CustomerContent;
        }
        field(80016; "YVS Company Address 2 (Eng)"; Text[50])
        {
            Caption = 'Company Address 2 (Eng)';
            DataClassification = CustomerContent;
        }
        field(80017; "YVS City (Eng)"; Text[30])
        {
            Caption = 'City (Eng)';
            DataClassification = CustomerContent;
        }

    }
}