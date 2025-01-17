/// <summary>
/// TableExtension YVS ExtenSales Header (ID 80012) extends Record Sales Header.
/// </summary>
tableextension 80012 "YVS ExtenSales Header" extends "Sales Header"
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
            TableRelation = "YVS Customer & Vendor Branch"."VAT Branch Code" WHERE("Source Type" = CONST(Customer), "Source No." = FIELD("Sell-to Customer No."));
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
                VendCustBranch.SetRange("Source Type", VendCustBranch."Source Type"::Customer);
                VendCustBranch.SetRange("Source No.", "Sell-to Customer No.");
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
        field(80003; "YVS Ref. Tax Invoice Date"; Date)
        {
            Caption = 'Ref. Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80004; "YVS Ref. Tax Invoice No."; Code[20])
        {
            Caption = 'Ref. Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80005; "YVS Ref. Tax Invoice Amount"; Decimal)
        {
            Caption = 'Ref. Tax Invoice Amount';
            DataClassification = CustomerContent;
        }

        field(80006; "YVS Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80007; "YVS Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80008; "YVS Make Order No. Series"; Code[20])
        {
            Caption = 'Make Order No. Series';
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                SalesSetup: Record "Sales & Receivables Setup";
                NoseriesMgt: Codeunit "No. Series";
                newNoseries: code[20];
            begin
                SalesSetup.GET();
                SalesSetup.TestField("Order Nos.");
                if NoseriesMgt.LookupRelatedNoSeries(SalesSetup."Order Nos.", "No. Series", newNoseries) then
                    "YVS Make Order No. Series" := newNoseries;
            end;
        }
        field(80009; "YVS Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }

        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                Cust: Record Customer;
                FuncenterYVS: Codeunit "YVS Function Center";
            begin
                if not FuncenterYVS.CheckDisableLCL() then
                    exit;
                if not Cust.get("Sell-to Customer No.") then
                    Cust.init();

                "YVS Head Office" := Cust."YVS Head Office";
                "YVS VAT Branch Code" := Cust."YVS VAT Branch Code";
                "YVS WHT Business Posting Group" := Cust."YVS WHT Business Posting Group";
                if (NOT "YVS Head Office") AND ("YVS VAT Branch Code" = '') then
                    "YVS Head Office" := true;
            end;
        }
        modify("Applies-to Doc. No.")
        {
            trigger OnAfterValidate()
            var
                SalesInvoice: Record "Sales Invoice Header";
            begin
                if not SalesInvoice.GET(rec."Applies-to Doc. No.") then
                    SalesInvoice.Init();
                SalesInvoice.CalcFields(Amount);
                rec."YVS Ref. Tax Invoice Date" := SalesInvoice."Document Date";
                rec."YVS Ref. Tax Invoice Amount" := SalesInvoice.Amount;
            end;
        }
        modify("Applies-to ID")
        {
            trigger OnAfterValidate()
            var
                SalesInvoice: Record "Sales Invoice Header";
            begin
                if not SalesInvoice.GET(rec."Applies-to ID") then
                    SalesInvoice.Init();
                SalesInvoice.CalcFields(Amount);
                Rec."YVS Ref. Tax Invoice Date" := SalesInvoice."Document Date";
                Rec."YVS Ref. Tax Invoice Amount" := SalesInvoice.Amount;
            end;
        }

    }

    trigger OnInsert()
    var
        FuncenterYVS: Codeunit "YVS Function Center";
    begin
        if not FuncenterYVS.CheckDisableLCL() then
            exit;
        TestField("No.");
        "YVS Create By" := COPYSTR(UserId, 1, 50);
        "YVS Create DateTime" := CurrentDateTime;
        if rec."Posting Date" = 0D then
            rec."Posting Date" := Today();
        if rec."Document Date" = 0D then
            rec."Document Date" := Today();
        if "Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"] then begin
            "Posting No." := "No.";
            "Posting No. Series" := "No. Series";
        end;
        if "Document Type" = "Document Type"::"Return Order" then begin
            "Return Receipt No." := "No.";
            "Return Receipt No. Series" := "No. Series";
        end;
    end;
}