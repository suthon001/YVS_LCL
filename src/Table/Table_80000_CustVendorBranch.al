/// <summary>
/// Table YVS Customer Vendor Branch (ID 80000).
/// </summary>
table 80000 "YVS Customer & Vendor Branch"
{
    Caption = 'Customer & Vendor Branch';
    DrillDownPageId = "YVS Cust. & Vendor BranchLists";
    LookupPageId = "YVS Cust. & Vendor BranchLists";
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = 'Vendor,Customer';
            OptionMembers = Vendor,Customer;
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(2; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(3; "Head Office"; boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Head Office" then
                    "VAT Branch Code" := '';
            end;

        }
        field(4; "VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "VAT Branch Code" <> '' then begin
                    if StrLen("VAT Branch Code") <> 5 then
                        Error('VAT Branch Code must be 5 characters');
                    "Head Office" := false;
                end;
                if ("VAT Branch Code" = '00000') OR ("VAT Branch Code" = '') then begin
                    "Head Office" := TRUE;
                    "VAT Branch Code" := '';
                end;
            end;
        }
        field(5; "Name"; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(6; "Address"; Text[100])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(7; "Title Name"; Enum "YVS Title Document Name")
        {
            Caption = 'คำนำหน้า';
            DataClassification = CustomerContent;
        }
        field(8; "Building"; Text[100])
        {
            Caption = 'ชื่ออาคาร/หมู่บ้าน';
            DataClassification = CustomerContent;
        }
        field(9; "Alley/Lane"; Text[100])
        {
            Caption = 'ตรอก/ซอย';
            DataClassification = CustomerContent;
        }
        field(10; "Sub-district"; Text[100])
        {
            Caption = 'ตำบล/แขวง';
            DataClassification = CustomerContent;
        }
        field(11; "District"; Text[100])
        {
            Caption = 'อำเภอ/เขต';
            DataClassification = CustomerContent;
        }
        field(12; "Floor"; Text[10])
        {
            Caption = 'ชั้น';
            DataClassification = CustomerContent;
        }
        field(13; "House No."; Text[50])
        {
            Caption = 'เลขที่ห้อง';
            DataClassification = CustomerContent;
        }
        field(14; "Village No."; Text[15])
        {
            Caption = 'หมู่ที่';
            DataClassification = CustomerContent;
        }
        field(15; "Street"; Text[50])
        {
            Caption = 'ถนน';
            DataClassification = CustomerContent;
        }
        field(16; "Province"; Text[50])
        {
            Caption = 'จังหวัด';
            DataClassification = CustomerContent;
        }
        field(17; "Post Code"; code[20])
        {
            Caption = 'รหัสไปรษณีย์';
            DataClassification = CustomerContent;
        }
        field(18; "No."; code[20])
        {
            Caption = 'เลขที่';
            DataClassification = CustomerContent;
        }
        field(19; "Vat Registration No."; Text[20])
        {
            Caption = 'Vat Registration No.';
            DataClassification = CustomerContent;
        }
        field(20; "Contact"; Text[30])
        {
            Caption = 'Contact';
            DataClassification = CustomerContent;
        }
        field(21; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
        }
        field(22; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
            DataClassification = CustomerContent;
        }
        field(23; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Source Type", "Source No.", "Head Office", "VAT Branch Code")
        {
            Clustered = true;
        }
    }
}