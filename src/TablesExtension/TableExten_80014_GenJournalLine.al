/// <summary>
/// TableExtension YVS GenJournal Lines (ID 80014) extends Record Gen. Journal Line.
/// </summary>
tableextension 80014 "YVS GenJournal Lines" extends "Gen. Journal Line"
{
    fields
    {
        field(80000; "YVS Document No. Series"; Code[20])
        {
            Caption = 'Document No. Series';
            DataClassification = CustomerContent;
        }
        field(80001; "YVS Tax Invoice No."; Code[35])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80002; "YVS Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80003; "YVS Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "YVS Tax Invoice Amount" := ROUND("YVS Tax Invoice Base" * "VAT %" / 100, 0.01);
                if "YVS Tax Invoice Amount" = 0 then
                    "YVS Tax Invoice Amount" := "Amount (LCY)";
            end;

        }
        field(80004; "YVS Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            DataClassification = CustomerContent;
        }
        field(80005; "YVS Tax Vendor No."; Code[20])
        {
            Caption = 'Tax Vendor/Cutomer No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Gen. Posting Type" = filter(Purchase)) Vendor."no."
            else
            IF ("Gen. Posting Type" = filter(Sale)) Customer."No."
            else
            IF ("Gen. Posting Type" = filter(" "), "YVS Template Source Type" = filter("Cash Receipts")) Customer."No."
            else
            Vendor."No.";


            trigger OnValidate()
            var
                Vendor: Record Vendor;
                Cust: Record Customer;
            begin
                IF "Gen. Posting Type" = "Gen. Posting Type"::Sale then begin
                    IF not Cust.GET("YVS Tax Vendor No.") THEN
                        Cust.INIT();
                    "YVS Tax Invoice Name" := Cust.Name;
                    "YVS Tax Invoice Name 2" := Cust."Name 2";
                    "YVS Head Office" := Cust."YVS Head Office";
                    "YVS VAT Branch Code" := Cust."YVS VAT Branch Code";
                    if (NOT "YVS Head Office") AND ("YVS VAT Branch Code" = '') then
                        "YVS Head Office" := true;
                    "YVS Tax Invoice Address" := Cust.Address;
                    "YVS Tax Invoice Address 2" := Cust."Address 2";
                    "VAT Registration No." := Cust."VAT Registration No.";
                end else
                    IF "Gen. Posting Type" = "Gen. Posting Type"::Purchase then begin
                        IF NOT Vendor.GET("YVS Tax Vendor No.") THEN
                            Vendor.INIT();
                        "YVS Tax Invoice Name" := Vendor.Name;
                        "YVS Tax Invoice Name 2" := Vendor."Name 2";
                        "YVS Head Office" := Vendor."YVS Head Office";
                        "YVS VAT Branch Code" := Vendor."YVS VAT Branch Code";
                        if (NOT "YVS Head Office") AND ("YVS VAT Branch Code" = '') then
                            "YVS Head Office" := true;
                        "YVS Tax Invoice Address" := Vendor.Address;
                        "YVS Tax Invoice Address 2" := Vendor."Address 2";
                        "VAT Registration No." := Vendor."VAT Registration No.";
                    end;


            end;

        }
        field(80006; "YVS Tax Invoice Name"; Text[120])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = CustomerContent;
        }
        field(80007; "YVS Description Line"; Text[150])
        {
            Caption = 'Description Line';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80008; "YVS Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "YVS Head Office" then
                    "YVS VAT Branch Code" := '';

            end;

        }
        field(80009; "YVS VAT Branch Code"; Code[5])
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
        field(80010; "YVS Description Voucher"; Text[250])
        {
            Caption = 'Description Voucher';
            DataClassification = CustomerContent;
        }
        field(80011; "YVS WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "YVS WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                WHTBusinessPostingGroup: Record "YVS WHT Business Posting Group";
            begin
                IF NOT WHTBusinessPostingGroup.GET("YVS WHT Business Posting Group") THEN
                    WHTBusinessPostingGroup.init();
                "YVS WHT No. Series" := WHTBusinessPostingGroup."WHT Certificate No. Series";
                CalWhtAmount();
            end;
        }
        field(80012; "YVS WHT Product Posting Group"; Code[10])
        {
            Caption = 'Product Posting Group';
            TableRelation = "YVS WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalWhtAmount();
            end;
        }
        field(80013; "YVS WHT Name"; text[100])
        {
            Caption = 'WHT Name';
            DataClassification = CustomerContent;
        }
        field(80014; "YVS WHT Name 2"; text[50])
        {
            Caption = 'WHT Name 2';
            DataClassification = CustomerContent;
        }
        field(80015; "YVS WHT Address"; Text[100])
        {
            Caption = 'WHT Address';
            DataClassification = CustomerContent;
        }
        field(80016; "YVS WHT Address 2"; Text[50])
        {
            Caption = 'WHT Address 2';
            DataClassification = CustomerContent;
        }
        field(80017; "YVS WHT Post Code"; Code[20])
        {
            Caption = 'WHT Post Code';
            DataClassification = CustomerContent;
        }
        field(80018; "YVS WHT City"; Text[50])
        {
            Caption = 'WHT City';
            DataClassification = CustomerContent;
        }
        field(80019; "YVS WHT County"; Text[50])
        {
            Caption = 'WHT County';
            DataClassification = CustomerContent;
        }
        field(80020; "YVS WHT Country Code"; Code[10])
        {
            Caption = 'WHT Country Code';
            DataClassification = CustomerContent;
        }
        field(80021; "YVS WHT Registration No."; Text[20])
        {
            Caption = 'WHT Registration No.';
            DataClassification = CustomerContent;
        }
        field(80022; "YVS WHT Base"; Decimal)
        {
            Caption = 'WHT Base';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalWhtAmount();
            end;
        }
        field(80023; "YVS WHT Amount"; Decimal)
        {
            Caption = 'WHT Amount';
            DataClassification = CustomerContent;
        }
        field(80024; "YVS WHT Revenue Type"; Code[10])
        {
            Caption = 'WHT Revenue Type';
            DataClassification = CustomerContent;
        }
        field(80025; "YVS WHT Revenue Description"; Text[50])
        {
            Caption = 'WHT Revenue Description';
            DataClassification = CustomerContent;
        }
        field(80026; "YVS WHT %"; Decimal)
        {
            Caption = 'WHT %';
            DataClassification = CustomerContent;
        }
        field(80027; "YVS WHT Document No."; Code[30])
        {
            Caption = 'WHT Document No.';
            DataClassification = CustomerContent;
        }
        field(80028; "YVS WHT Option"; Enum "YVS WHT Option")
        {
            Caption = 'WHT Option';
            DataClassification = CustomerContent;
        }
        field(80029; "YVS WHT No. Series"; Code[10])
        {
            Caption = 'WHT No. Series';
            DataClassification = CustomerContent;
        }
        field(80030; "YVS WHT Date"; Date)
        {
            Caption = 'WHT Date';
            DataClassification = CustomerContent;
        }
        field(80031; "YVS Bank Code"; Code[20])
        {
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
            TableRelation = "Bank Account"."No.";
            trigger OnValidate()
            var
                BankAcc: Record "Bank Account";
            begin
                IF NOT BankAcc.GET("YVS Bank Code") THEN
                    BankAcc.INIT();
                "YVS Bank Name" := BankAcc.Name;
                "YVS Bank Account No." := COPYSTR(BankAcc."Bank Account No.", 1, 20);
                "YVS Bank Branch No." := BankAcc."Bank Branch No.";
            end;

        }
        field(80032; "YVS Bank Name"; Text[100])
        {
            Caption = 'Bank Name';
            DataClassification = CustomerContent;

        }
        field(80033; "YVS Bank Account No."; text[20])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;

        }
        field(80034; "YVS Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            DataClassification = CustomerContent;

        }
        field(80035; "YVS Cheque No."; Text[35])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                IsHandle: Boolean;
            begin
                IsHandle := false;
                "YVS OnbeforUpdateChequeToExternal"(IsHandle);
                if not IsHandle then begin
                    "External Document No." := "YVS Cheque No.";
                    if "YVS Cheque No." <> '' then
                        "YVS Cheque Date" := "Document Date"
                    else
                        "YVS Cheque Date" := 0D;
                end;
            end;

        }
        field(80036; "YVS Cheque Date"; Date)
        {
            Caption = 'Cheque Date';
            DataClassification = CustomerContent;

        }
        field(80037; "YVS Pay Name"; Text[100])
        {
            Caption = 'Pay Name';
            DataClassification = CustomerContent;
        }

        field(80038; "YVS WHT Vendor No."; Code[20])
        {
            Caption = 'WHT Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                Vendor: Record vendor;
            begin
                IF NOT Vendor.GET("YVS WHT Vendor No.") THEN
                    Vendor.INIT();
                "VAT Registration No." := Vendor."VAT Registration No.";
                "YVS WHT Name" := Vendor.Name;
                "YVS WHT Name 2" := Vendor."Name 2";
                "YVS WHT Address" := Vendor.Address;
                "YVS WHT Address 2" := Vendor."Address 2";
                "YVS WHT City" := Vendor.City;
                "YVS WHT Post Code" := Vendor."Post Code";
                "YVS WHT County" := Vendor.County;
                VALIDATE("YVS WHT Business Posting Group", Vendor."YVS WHT Business Posting Group");
                "YVS WHT Registration No." := Vendor."VAT Registration No.";
                "YVS OnAfterInitWHTVendorNo"(rec, Vendor);
                CalWhtAmount();
            end;
        }
        field(80039; "YVS Tax Invoice Address"; Code[100])
        {
            Caption = 'Tax Invoice Address';
            DataClassification = CustomerContent;
        }
        field(80040; "YVS Tax Invoice City"; text[50])
        {
            Caption = 'Tax Invoice City';
            DataClassification = CustomerContent;
        }
        field(80041; "YVS Tax Invoice Post Code"; Code[30])
        {
            Caption = 'Tax Invoice Post Code';
            DataClassification = CustomerContent;
        }
        field(80042; "YVS Require Screen Detail"; Enum "YVS Require Screen Detail")
        {
            Caption = 'Require Screen Detail';
            DataClassification = CustomerContent;


        }
        field(80043; "YVS Customer/Vendor No."; code[20])
        {
            Caption = 'Customer/Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("YVS Template Source Type" = filter("Cash Receipts")) Customer."No."
            else
            Vendor."No.";
            trigger OnValidate()
            var
                Customer: Record Customer;
                Vendor: Record Vendor;
            begin
                if ("YVS Template Source Type" = "YVS Template Source Type"::"Cash Receipts") then begin
                    IF not Customer.GET("YVS Customer/Vendor No.") THEN
                        Customer.init();
                    "YVS Pay Name" := Customer.Name;
                end else begin
                    IF not Vendor.GET("YVS Customer/Vendor No.") THEN
                        Vendor.init();
                    "YVS Pay Name" := Vendor.Name;
                end;


            end;

        }


        field(80044; "YVS Cheque Name"; Text[100])
        {
            Caption = 'Cheque Name';
            DataClassification = CustomerContent;

        }
        field(80045; "YVS Journal Description"; Text[250])
        {

            Caption = 'Journal Description';
            DataClassification = CustomerContent;
        }
        field(80046; "YVS WHT Cust/Vend No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'WHT Cust/Vend No.';
        }
        field(80047; "YVS Tax Invoice Name 2"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Tax Invoice Name 2';
        }

        field(80048; "YVS Create By"; Code[50])
        {
            Caption = 'Create By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80049; "YVS Create DateTime"; DateTime)
        {
            Caption = 'Create DateTime';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80050; "YVS Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80051; "YVS Tax Invoice Address 2"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Tax Invoice Address 2';
        }

        field(80052; "YVS Template Source Type"; Enum "Gen. Journal Template Type")
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Gen. Journal Template".Type where(Name = field("Journal Template Name")));
            Caption = 'Template Source Type';
        }
        field(80053; "Ref. Billing & Receipt No."; code[30])
        {
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Ref. Billing & Receipt No.';

        }

        modify("External Document No.")
        {
            trigger OnAfterValidate()
            var
                IsHandle: Boolean;
            begin
                IsHandle := false;
                "YVS OnbeforUpdateExternalToCheque"(IsHandle);
                if not IsHandle then
                    if "Account Type" = "Account Type"::"Bank Account" then begin
                        "YVS Cheque No." := rec."External Document No.";
                        "YVS Cheque Date" := rec."Document Date";
                    end else begin
                        "YVS Cheque No." := '';
                        "YVS Cheque Date" := 0D;
                    end;

            end;
        }
        modify("Account No.")
        {
            trigger OnAfterValidate()
            var
                GLAccount: Record "G/L Account";
                BankAccount: Record "Bank Account";
                Cust: Record Customer;
                Vend: record Vendor;
            begin
                if not GLAccount.GET("Account No.") then
                    GLAccount.init();

                if not BankAccount.GET("Account No.") then
                    BankAccount.init();
                "YVS Bank Name" := BankAccount.Name;
                "YVS Bank Branch No." := BankAccount."Bank Branch No.";
                "YVS Bank Account No." := COPYSTR(BankAccount."Bank Account No.", 1, 20);

                if "Account Type" = "Account Type"::Customer then begin
                    if not Cust.GET("Account No.") then
                        Cust.init();
                    "YVS Head Office" := Cust."YVS Head Office";
                    "YVS VAT Branch Code" := Cust."YVS VAT Branch Code";
                    "VAT Registration No." := Cust."VAT Registration No.";
                end;
                if "Account Type" = "Account Type"::Vendor then begin
                    if not Vend.GET("Account No.") then
                        Vend.init();
                    "YVS Head Office" := Vend."YVS Head Office";
                    "YVS VAT Branch Code" := Vend."YVS VAT Branch Code";
                    "VAT Registration No." := Vend."VAT Registration No.";
                end;

            end;
        }
        modify("Account Type")
        {
            trigger OnAfterValidate()
            begin
                if xRec."Account Type" <> "Account Type" then begin
                    "YVS Require Screen Detail" := "YVS Require Screen Detail"::" ";
                    "YVS Head Office" := false;
                    "YVS VAT Branch Code" := '';
                end;
            end;
        }
    }
    trigger OnInsert()
    begin
        "YVS Create By" := COPYSTR(USERID, 1, 50);
        "YVS Create DateTime" := CurrentDateTime;
    end;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldGenJnlLine">Record "Gen. Journal Line".</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure "AssistEdit"(OldGenJnlLine: Record "Gen. Journal Line"): Boolean
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        // WITH GenJnlLine DO BEGIN
        GenJnlLine.COPY(Rec);
        GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
        GenJnlBatch.TESTFIELD("YVS Document No. Series");
        IF NoSeriesMgt.SelectSeries(GenJnlBatch."YVS Document No. Series", OldGenJnlLine."YVS Document No. Series",
            GenJnlLine."YVS Document No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(GenJnlLine."Document No.");
            Rec := GenJnlLine;
            EXIT(TRUE);
        END;
        //  END;
    end;

    local procedure CalWhtAmount()
    var
        WHTPostingSetup: Record "YVS WHT Posting Setup";

    begin
        IF WHTPostingSetup.GET("YVS WHT Business Posting Group", "YVS WHT Product Posting Group") THEN BEGIN
            CalcFields("YVS Template Source Type");
            "YVS WHT %" := WHTPostingSetup."WHT %";
            "YVS WHT Amount" := ROUND(("YVS WHT Base") * (WHTPostingSetup."WHT %" / 100), 0.01);
            if "YVS Template Source Type" = "YVS Template Source Type"::Payments THEN
                VALIDATE(Amount, "YVS WHT Amount" * -1)
            else
                if "YVS Template Source Type" = "YVS Template Source Type"::"Cash Receipts" THEN
                    Validate(Amount, Abs("YVS WHT Amount"));
        END
        ELSE BEGIN
            "YVS WHT %" := 0;
            "YVS WHT Amount" := 0;
            VALIDATE(Amount, 0);
        END;
    end;

    /// <summary>
    /// GetLastLine.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure GetLastLine(): Integer
    var
        genJournalLine: Record "Gen. Journal Line";
    begin
        genJournalLine.reset();
        genJournalLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
        genJournalLine.SetRange("Journal Template Name", "Journal Template Name");
        genJournalLine.SetRange("Journal Batch Name", "Journal Batch Name");
        if genJournalLine.FindLast() then
            exit(genJournalLine."Line No." + 10000);
        exit(10000);
    end;

    [IntegrationEvent(false, false)]
    local procedure "YVS OnbeforUpdateExternalToCheque"(var IsHandle: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure "YVS OnbeforUpdateChequeToExternal"(var IsHandle: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure "YVS OnAfterInitWHTVendorNo"(var GenLine: Record "Gen. Journal Line"; Vendor: Record Vendor)
    begin
    end;
}