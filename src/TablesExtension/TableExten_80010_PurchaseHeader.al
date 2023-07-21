/// <summary>
/// TableExtension YVS ExtenPurchase Header (ID 80010) extends Record Purchase Header.
/// </summary>
tableextension 80010 "YVS ExtenPurchase Header" extends "Purchase Header"
{
    fields
    {
        field(80000; "YVS WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "YVS WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
        }
        field(80001; "YVS Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "YVS Head Office" then
                    "YVS VAT Branch Code" := '';
            end;


        }
        field(80002; "YVS VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            TableRelation = "YVS Customer & Vendor Branch"."VAT Branch Code" WHERE("Source Type" = CONST(Vendor), "Source No." = FIELD("Buy-from Vendor No."));
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

            trigger OnLookup()
            var
                VendCustBranch: Record "YVS Customer & Vendor Branch";
                VendCustPage: Page "YVS Cust. & Vendor BranchLists";
            begin
                clear(VendCustPage);
                VendCustBranch.reset();
                VendCustBranch.SetRange("Source Type", VendCustBranch."Source Type"::Vendor);
                VendCustBranch.SetRange("Source No.", "Buy-from Vendor No.");
                VendCustPage.Editable := false;
                VendCustPage.LookupMode := true;
                VendCustPage.SetTableView(VendCustBranch);
                if VendCustPage.RunModal() IN [Action::LookupOK, Action::OK] then begin
                    VendCustPage.GetRecord(VendCustBranch);
                    if VendCustBranch."Head Office" then begin
                        "YVS Head Office" := true;
                        "YVS VAT Branch Code" := '';
                        "VAT Registration No." := VendCustBranch."Vat Registration No.";
                    end else
                        if VendCustBranch."VAT Branch Code" <> '' then begin
                            "YVS VAT Branch Code" := VendCustBranch."VAT Branch Code";
                            "YVS Head Office" := false;
                            "VAT Registration No." := VendCustBranch."Vat Registration No.";
                        end;
                end;
                clear(VendCustPage);
            end;

        }

        field(80003; "YVS Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80004; "YVS Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80005; "YVS Purchase Order No."; Code[30])
        {
            Caption = 'Purchase Order No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80006; "YVS Make PO No. Series"; Code[20])
        {
            // TableRelation = "No. Series".Code;
            Caption = 'Make PO No.Series';
            DataClassification = CustomerContent;
            trigger OnLookup()
            var

                PayableSetup: Record "Purchases & Payables Setup";
                NoseriesMgt: Codeunit NoSeriesManagement;
                newNoseries: code[20];


            begin
                PayableSetup.GET();
                PayableSetup.TestField("Order Nos.");
                if NoseriesMgt.SelectSeries(PayableSetup."Order Nos.", "No. Series", newNoseries) then
                    "YVS Make PO No. Series" := newNoseries;
            end;
        }



        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
                Vend: Record Vendor;
            begin
                if not Vend.get("Buy-from Vendor No.") then
                    Vend.init();

                "YVS Head Office" := Vend."YVS Head Office";
                "YVS VAT Branch Code" := Vend."YVS VAT Branch Code";
                if (NOT "YVS Head Office") AND ("YVS VAT Branch Code" = '') then
                    "YVS Head Office" := true;
            end;
        }
    }
    trigger OnInsert()
    begin
        TestField("No.");
        "YVS Create By" := COPYSTR(UserId(), 1, 50);
        "YVS Create DateTime" := CurrentDateTime;
        if rec."Posting Date" = 0D then
            rec."Posting Date" := Today();
        if rec."Document Date" = 0D then
            rec."Document Date" := Today();
        if "Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"] then
            "Posting No." := "No.";
    end;
}