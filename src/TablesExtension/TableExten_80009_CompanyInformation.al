/// <summary>
/// TableExtension YVS CompanyInformation (ID 80009) extends Record Company Information.
/// </summary>
tableextension 80009 "YVS CompanyInformation" extends "Company Information"
{
    fields
    {
        field(80000; "YVS Name (Eng)"; Text[100])
        {
            Caption = 'Name (Eng)';
            DataClassification = CustomerContent;
        }
        field(80001; "YVS Name 2 (Eng)"; Text[50])
        {
            Caption = 'Name 2 (Eng)';
            DataClassification = CustomerContent;
        }
        field(80002; "YVS Address (Eng)"; Text[100])
        {
            Caption = 'Address (Eng)';
            DataClassification = CustomerContent;
        }
        field(80003; "YVS Address 2 (Eng)"; Text[50])
        {
            Caption = 'Address 2 (Eng)';
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
                    if StrLen("YVS VAT Branch Code") <> 5 then
                        Error('VAT Branch Code must be 5 characters');
                    "YVS Head Office" := false;
                end;
                if ("YVS VAT Branch Code" = '00000') OR ("YVS VAT Branch Code" = '') then begin
                    "YVS Head Office" := TRUE;
                    "YVS VAT Branch Code" := '';
                end;
            end;
        }
        field(80006; "YVS City (Eng)"; Text[50])
        {
            Caption = 'City (Eng)';
            DataClassification = CustomerContent;
        }
    }
}