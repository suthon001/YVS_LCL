/// <summary>
/// TableExtension YVS ExtenCustomer (ID 80000) extends Record Customer.
/// </summary>
tableextension 80000 "YVS ExtenCustomer" extends Customer
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
            TableRelation = "YVS Customer & Vendor Branch"."VAT Branch Code" WHERE("Source Type" = CONST(Customer), "Source No." = FIELD("No."));
            ValidateTableRelation = true;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                CustVendBarch: Record "YVS Customer & Vendor Branch";
            begin

                CustVendBarch.reset();
                CustVendBarch.SetRange("Source Type", CustVendBarch."Source Type"::Customer);
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
        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(5, rec.Name, false);
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
            end;
        }
        modify("Post Code")
        {
            trigger OnAfterValidate()
            begin
                UpdateVendorCustBranch(17, "Post Code", false);
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
    begin

        CLEAR(tempHeadOffice);

        if FieldsBranch then
            tempHeadOffice := WHTResult = '00000';

        if (xRec."No." <> '') AND (xRec."No." <> "No.") then begin
            if xrec."No." <> '' then begin
                VendorCustBranch.reset();
                VendorCustBranch.SetRange("Source Type", VendorCustBranch."Source Type"::Customer);
                VendorCustBranch.SetRange("Source No.", xrec."No.");
                VendorCustBranch.DeleteAll();
            end;

            VendorCustBranch.init();
            VendorCustBranch."Source Type" := VendorCustBranch."Source Type"::Customer;
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
            VendorCustBranch.SetRange("Source Type", VendorCustBranch."Source Type"::Customer);
            VendorCustBranch.SetRange("Source No.", "No.");
            VendorCustBranch.SetRange("Head Office", TRUE);
            if VendorCustBranch.FindFirst() then begin
                VenCust.Get(VendorCustBranch.RecordId);
                MyFieldRef := VenCust.Field(FiledsNo);
                if FiledsNo = 3 then
                    MyFieldRef.validate(tempHeadOffice)
                else
                    MyFieldRef.validate(WHTResult);
                VenCust.Modify();
            end else begin
                VendorCustBranch.init();
                VendorCustBranch."Source Type" := VendorCustBranch."Source Type"::Customer;
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
    begin
        VendorCustBranch.reset();
        VendorCustBranch.SetRange("Source Type", VendorCustBranch."Source Type"::Customer);
        VendorCustBranch.SetRange("Source No.", "No.");
        VendorCustBranch.DeleteAll();
    end;
}