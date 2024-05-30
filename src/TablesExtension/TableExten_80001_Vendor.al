/// <summary>
/// TableExtension YVS ExtenVendor (ID 80001) extends Record Vendor.
/// </summary>
tableextension 80001 "YVS ExtenVendor" extends Vendor
{
    fields
    {
        field(80000; "YVS Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "YVS Head Office" then
                    "YVS VAT Branch Code" := '';

            end;

        }
        field(80001; "YVS VAT Branch Code"; code[5])
        {
            Caption = 'VAT Branch Code';
            TableRelation = "YVS Customer & Vendor Branch"."VAT Branch Code" WHERE("Source Type" = CONST(Vendor), "Source No." = FIELD("No."));
            ValidateTableRelation = true;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var

                CustVendBarch: Record "YVS Customer & Vendor Branch";
            begin
                CustVendBarch.reset();
                CustVendBarch.SetRange("Source Type", CustVendBarch."Source Type"::Vendor);
                CustVendBarch.SetRange("Source No.", "No.");
                CustVendBarch.SetRange("VAT Branch Code", "YVS VAT Branch Code");
                if CustVendBarch.FindFirst() then begin
                    "VAT Registration No." := CustVendBarch."Vat Registration No.";
                    if CustVendBarch."Head Office" then
                        "YVS VAT Branch Code" := '00000';
                end;
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
        field(80002; "YVS WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "YVS WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(80003; "YVS WHT Title Name"; Text[50])
        {
            Caption = 'คำนำหน้า';
            DataClassification = CustomerContent;
        }
        field(80004; "YVS WHT Building"; Text[100])
        {
            Caption = 'ชื่ออาคาร/หมู่บ้าน';
            DataClassification = CustomerContent;
        }
        field(80005; "YVS WHT Alley/Lane"; Text[100])
        {
            Caption = 'ตรอก/ซอย';
            DataClassification = CustomerContent;
        }
        field(80006; "YVS WHT Sub-district"; Text[100])
        {
            Caption = 'ตำบล/แขวง';
            DataClassification = CustomerContent;
        }
        field(80007; "YVS WHT District"; Text[100])
        {
            Caption = 'อำเภอ/เขต';
            DataClassification = CustomerContent;
        }
        field(80008; "YVS WHT Floor"; Text[10])
        {
            Caption = 'ชั้น';
            DataClassification = CustomerContent;
        }
        field(80009; "YVS WHT House No."; Text[50])
        {
            Caption = 'เลขที่ห้อง';
            DataClassification = CustomerContent;
        }
        field(80010; "YVS WHT Village No."; Text[15])
        {
            Caption = 'หมู่ที่';
            DataClassification = CustomerContent;
        }
        field(80011; "YVS WHT Street"; Text[50])
        {
            Caption = 'ถนน';
            DataClassification = CustomerContent;
        }
        field(80012; "YVS WHT Province"; Text[50])
        {
            Caption = 'จังหวัด';
            DataClassification = CustomerContent;
        }
        field(80013; "YVS WHT Post Code"; code[20])
        {
            Caption = 'รหัสไปรษณีย์';
            DataClassification = CustomerContent;
            TableRelation = "Post Code".Code;
            trigger OnValidate()
            var
                ltPostCode: Record "Post Code";
            begin
                ltPostCode.reset();
                ltPostCode.SetRange(code, rec."YVS WHT Post Code");
                if ltPostCode.FindFirst() then
                    rec."YVS WHT Province" := ltPostCode.City;
            end;
        }
        field(80014; "YVS WHT No."; code[20])
        {
            Caption = 'เลขที่';
            DataClassification = CustomerContent;
        }
        field(80015; "YVS WHT Name"; text[100])
        {
            Caption = 'ชื่อ';
            DataClassification = CustomerContent;
        }
        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(5, Name, false);
                rec."YVS WHT Name" := rec.Name;
            end;
        }
        modify(Address)
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(6, Address, false);
            end;
        }
        modify("Address 2")
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(23, "Address 2", false);
            end;
        }
        modify(City)
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(16, City, false);
                rec."YVS WHT Province" := rec.City;
            end;
        }
        modify("Post Code")
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(17, "Post Code", false);
                rec."YVS WHT Post Code" := rec."Post Code";
            end;
        }

        modify("VAT Registration No.")
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(19, "VAT Registration No.", false);
            end;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(3, '00000', TRUE);
            end;
        }
        modify("Phone No.")
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(21, "Phone No.", TRUE);
            end;
        }
        modify("Fax No.")
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(22, "Fax No.", TRUE);
            end;
        }

    }
    local procedure UpdateVendorCustBranch(FiledsNo: Integer; WHTResult: Text[250]; FieldsBranch: Boolean)
    var
        VendorCustBranch: Record "YVS Customer & Vendor Branch";
        VenCust: RecordRef;
        MyFieldRef: FieldRef;
        tempHeadOffice: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";
    begin
        if not FuncenterYVS.CheckDisableLCL() then
            exit;

        CLEAR(tempHeadOffice);

        if FieldsBranch then
            tempHeadOffice := WHTResult = '00000';

        if (xRec."No." <> '') AND (xRec."No." <> "No.") then begin
            if xrec."No." <> '' then begin
                VendorCustBranch.reset();
                VendorCustBranch.SetRange("Source Type", VendorCustBranch."Source Type"::Vendor);
                VendorCustBranch.SetRange("Source No.", xrec."No.");
                VendorCustBranch.DeleteAll();
            end;

            VendorCustBranch.init();
            VendorCustBranch."Source Type" := VendorCustBranch."Source Type"::Vendor;
            VendorCustBranch."Source No." := "No.";
            VendorCustBranch."Head Office" := TRUE;

            VendorCustBranch.insert();
            VenCust.Get(VendorCustBranch.RecordId);
            MyFieldRef := VenCust.Field(FiledsNo);
            if FiledsNo = 3 then
                MyFieldRef.validate(tempHeadOffice)
            else
                MyFieldRef.validate(WHTResult);
            VenCust.Modify();
        end else begin
            VendorCustBranch.reset();
            VendorCustBranch.SetRange("Source Type", VendorCustBranch."Source Type"::Vendor);
            VendorCustBranch.SetRange("Source No.", "No.");
            VendorCustBranch.SetRange("Head Office", TRUE);
            if VendorCustBranch.FindFirst() then begin
                VenCust.Get(VendorCustBranch.RecordId);
                MyFieldRef := VenCust.Field(FiledsNo);
                if FiledsNo in [16, 17, 23] then begin
                    MyFieldRef := VenCust.Field(23);
                    MyFieldRef.validate(StrSubstNo('%1', rec."Address 2" + ' ' + rec.City + ' ' + rec."Post Code").TrimEnd());
                end else begin
                    MyFieldRef := VenCust.Field(FiledsNo);
                    if FiledsNo = 3 then
                        MyFieldRef.validate(tempHeadOffice)
                    else
                        MyFieldRef.validate(WHTResult);
                end;
                VenCust.Modify();
            end else begin
                VendorCustBranch.init();
                VendorCustBranch."Source Type" := VendorCustBranch."Source Type"::Vendor;
                VendorCustBranch."Source No." := "No.";
                VendorCustBranch."Head Office" := TRUE;

                VendorCustBranch.insert();
                VenCust.Get(VendorCustBranch.RecordId);
                MyFieldRef := VenCust.Field(FiledsNo);
                if FiledsNo in [16, 17, 23] then begin
                    MyFieldRef := VenCust.Field(23);
                    MyFieldRef.validate(StrSubstNo('%1', rec."Address 2" + ' ' + rec.City + ' ' + rec."Post Code").TrimEnd());
                end else begin
                    MyFieldRef := VenCust.Field(FiledsNo);
                    if FiledsNo = 3 then
                        MyFieldRef.validate(tempHeadOffice)
                    else
                        MyFieldRef.validate(WHTResult);
                end;
                VenCust.Modify();
            end;
        END;
    end;

    trigger OnInsert()
    begin
        "YVS Head Office" := true;
    end;

    trigger OnDelete()
    var
        VendorCustBranch: Record "YVS Customer & Vendor Branch";
        FuncenterYVS: Codeunit "YVS Function Center";
    begin
        if not FuncenterYVS.CheckDisableLCL() then
            exit;
        VendorCustBranch.reset();
        VendorCustBranch.SetRange("Source Type", VendorCustBranch."Source Type"::Vendor);
        VendorCustBranch.SetRange("Source No.", rec."No.");
        VendorCustBranch.DeleteAll();
    end;
}