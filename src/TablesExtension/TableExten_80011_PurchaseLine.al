/// <summary>
/// TableExtension YVS ExtenPurchase Line (ID 80011) extends Record Purchase Line.
/// </summary>
tableextension 80011 "YVS ExtenPurchase Line" extends "Purchase Line"
{
    fields
    {
        field(80000; "YVS Qty. to Cancel"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. to Cancel';
            trigger OnValidate()
            var
                UOMMgt: Codeunit "Unit of Measure Management";
            begin
                if not Confirm('Do you want to Cancel Qty. ? ') then begin
                    rec."YVS Qty. to Cancel" := xRec."YVS Qty. to Cancel";
                    exit;
                end;
                IF ("Document Type" = "Document Type"::Order) THEN BEGIN
                    IF "Outstanding Quantity" = 0 THEN
                        ERROR('Outstanding Quantity must not be 0');

                    IF "YVS Qty. to Cancel" > (Quantity - "Quantity Received") THEN
                        VALIDATE("YVS Qty. to Cancel", Quantity - "Quantity Received");

                    "YVS Qty. to Cancel (Base)" := UOMMgt.CalcBaseQty("YVS Qty. to Cancel", "Qty. per Unit of Measure");
                    InitOutstanding();

                    VALIDATE("Qty. to Receive", "Outstanding Quantity");
                END ELSE begin

                    IF ("Document Type" = "Document Type"::"Blanket Order") THEN BEGIN
                        IF "YVS Qty. to Cancel" > Quantity THEN
                            VALIDATE("YVS Qty. to Cancel", Quantity);

                        "YVS Qty. to Cancel (Base)" := UOMMgt.CalcBaseQty("YVS Qty. to Cancel", "Qty. per Unit of Measure");
                        InitOutstanding();
                    END;
                    IF ("Document Type" IN ["Document Type"::Quote, "Document Type"::"YVS Purchase Request"]) THEN BEGIN
                        checkBeforQtyToCancal();
                        "YVS Qty. to Cancel (Base)" := UOMMgt.CalcBaseQty("YVS Qty. to Cancel", "Qty. per Unit of Measure");
                        InitOutstanding();
                    END;

                end;
            end;
        }
        field(80001; "YVS Qty. to Cancel (Base)"; Decimal)
        {
            Editable = false;
            DataClassification = SystemMetadata;
            Caption = 'Qty. to Cancel (Base)';
        }
        field(80002; "YVS Make Order By"; Code[50])
        {
            Caption = 'Make Order By';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(80003; "YVS Make Order DateTime"; DateTime)
        {
            Caption = 'Make Order DateTime';
            Editable = false;
            DataClassification = SystemMetadata;
        }

        field(80004; "YVS Ref. PQ No."; Code[30])
        {
            Caption = 'Ref. PR No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80005; "YVS Ref. PQ Line No."; Integer)
        {
            Caption = 'Ref. PR Line No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80006; "YVS WHT Business Posting Group"; Code[10])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "YVS WHT Business Posting Group"."Code";
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalWhtAmount();
            end;

        }
        field(80007; "YVS Tax Invoice No."; Code[20])
        {
            Caption = 'Tax Invoice No.';
            DataClassification = CustomerContent;
        }
        field(80008; "YVS Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            DataClassification = CustomerContent;
        }
        field(80009; "YVS Tax Invoice Base"; Decimal)
        {
            Caption = 'Tax Invoice Base';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "YVS Tax Invoice Amount" := ROUND("YVS Tax Invoice Base" * "VAT %" / 100, 0.01);
            end;

        }
        field(80010; "YVS Tax Invoice Amount"; Decimal)
        {
            Caption = 'Tax Invoice Amount';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(80011; "YVS Tax Vendor No."; Code[20])
        {
            Caption = 'Tax Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin
                if not Vend.GET("YVS Tax Vendor No.") then
                    Vend.init();
                "YVS Tax Invoice Name" := Vend.Name;
                "YVS Tax Invoice Name 2" := Vend."Name 2";
                "YVS Vat Registration No." := Vend."VAT Registration No.";
                "YVS Head Office" := Vend."YVS Head Office";
                "YVS VAT Branch Code" := Vend."YVS VAT Branch Code";
                if (NOT "YVS Head Office") AND ("YVS VAT Branch Code" = '') then
                    "YVS Head Office" := true;
            end;
        }
        field(80012; "YVS Tax Invoice Name"; Text[100])
        {
            Caption = 'Tax Invoice Name';
            DataClassification = CustomerContent;
        }
        field(80013; "YVS Head Office"; Boolean)
        {
            Caption = 'Tax Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "YVS Head Office" then
                    "YVS VAT Branch Code" := '';
            end;
        }
        field(80014; "YVS VAT Branch Code"; Code[5])
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
        field(80015; "YVS Vat Registration No."; Text[20])
        {
            Caption = 'Vat Registration No.';
            DataClassification = CustomerContent;
        }
        field(80016; "YVS WHT Product Posting Group"; Code[10])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "YVS WHT Product Posting Group"."Code";
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CalWhtAmount();
            end;

        }
        field(80017; "YVS Status"; Enum "Purchase Document Status")
        {
            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header".Status where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Editable = false;
        }


        field(80018; "YVS Tax Invoice Name 2"; Text[50])
        {
            Caption = 'Tax Invoice Name 2';
            DataClassification = CustomerContent;
        }
        field(80019; "YVS WHT %"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'WHT %';

        }
        field(80020; "YVS WHT Base"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'WHT Base';


        }
        field(80021; "YVS WHT Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'WHT Amount';
        }
        field(80022; "YVS WHT Option"; Enum "YVS WHT Option")
        {
            Caption = 'WHT Option';
            DataClassification = CustomerContent;
        }
        field(80023; "YVS Original Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if rec."Document Type" = rec."Document Type"::Order then
                    rec.Validate(Quantity, rec."YVS Original Quantity");
            end;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
            begin
                if Type = Type::Item then begin
                    if not Item.Get("No.") then
                        Item.init();
                    "YVS WHT Product Posting Group" := Item."YVS WHT Product Posting Group";
                end;
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                CheckQtyPR();
                CalWhtAmount();
                if rec."Document Type" <> rec."Document Type"::Order then
                    rec.Validate("YVS Original Quantity", rec.Quantity)
                else
                    if rec."Over-Receipt Code" = '' then
                        rec."YVS Original Quantity" := rec.Quantity;
            end;
        }
        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                CalWhtAmount();
            end;
        }

    }
    /// <summary>
    /// GetPurchaseQuotesLine.
    /// </summary>
    procedure GetPurchaseQuotesLine()
    var
        PurchaseQuotesLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
        GetPurchaseLine: Page "YVS Get Purchase Lines";
    begin
        CLEAR(GetPurchaseLine);
        PurchaseHeader.GET("Document Type", "Document No.");
        PurchaseHeader.TestField(Status, PurchaseHeader.Status::Open);
        PurchaseQuotesLine.reset();
        PurchaseQuotesLine.SetFilter("Document Type", '%1|%2', PurchaseQuotesLine."Document Type"::Quote, PurchaseQuotesLine."Document Type"::"YVS Purchase Request");
        PurchaseQuotesLine.SetRange("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
        PurchaseQuotesLine.SetRange("YVS Status", PurchaseQuotesLine."YVS Status"::Released);
        PurchaseQuotesLine.SetFilter("Outstanding Quantity", '<>%1', 0);
        GetPurchaseLine.SetTableView(PurchaseQuotesLine);
        GetPurchaseLine."Set PurchaseHeader"("Document Type", "Document No.");
        GetPurchaseLine.LookupMode := true;
        GetPurchaseLine.Run();
        clear(GetPurchaseLine);


    end;

    /// <summary>
    /// GetLastLine.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure GetLastLine(): Integer
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.reset();
        PurchaseLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        PurchaseLine.SetRange("Document Type", "Document Type");
        PurchaseLine.SetRange("Document No.", "Document No.");
        if PurchaseLine.FindLast() then
            EXIT(PurchaseLine."Line No." + 10000);
        exit(10000);
    end;

    local procedure CheckQtyPR()

    var
        POLine: Record "Purchase Line";
        PRLine: Record "Purchase Line";
        TempQty, TempQtyBase : Decimal;

    begin
        TempQty := 0;
        TempQtyBase := 0;
        if ("Document Type" = "Document Type"::Order) AND
            ("YVS Ref. PQ No." <> '') then begin

            POLine.reset();
            POLine.SetRange("Document Type", "Document Type");
            POLine.SetFilter("Document No.", '<>%1', "Document No.");
            POLine.SetRange("YVS Ref. PQ No.", "YVS Ref. PQ No.");
            POLine.SetRange("YVS Ref. PQ Line No.", "YVS Ref. PQ Line No.");
            if POLine.FindFirst() then begin
                POLine.CalcSums(Quantity, "Quantity (Base)");
                TempQty := POLine.Quantity;
                TempQtyBase := POLine."Quantity (Base)";
            end;
            POLine.reset();
            POLine.SetRange("Document Type", "Document Type");
            POLine.SetFilter("Document No.", '%1', "Document No.");
            POLine.SetFilter("Line No.", '<>%1', "Line No.");
            POLine.SetRange("YVS Ref. PQ No.", "YVS Ref. PQ No.");
            POLine.SetRange("YVS Ref. PQ Line No.", "YVS Ref. PQ Line No.");
            if POLine.FindFirst() then begin
                POLine.CalcSums(Quantity, "Quantity (Base)");
                TempQty := TempQty + POLine.Quantity;
                TempQtyBase := TempQtyBase + POLine."Quantity (Base)";
            end;
            if PRLine.GET(PRLine."Document Type"::Quote, "YVS Ref. PQ No.", "YVS Ref. PQ Line No.") then begin
                if (TempQty + Quantity) > PRLine.Quantity then
                    FieldError(Quantity, StrSubstNo(PrRemainingErr, "YVS Ref. PQ No.", PRLine.Quantity - TempQty));
                PRLine."Outstanding Quantity" := PRLine.Quantity - (TempQty + Quantity);
                PRLine."Outstanding Qty. (Base)" := PRLine."Quantity (Base)" - (TempQtyBase + "Quantity (Base)");
                PRLine."Completely Received" := PRLine."Outstanding Quantity" = 0;
                PRLine.Modify();
            end else
                if PRLine.GET(PRLine."Document Type"::"YVS Purchase Request", "YVS Ref. PQ No.", "YVS Ref. PQ Line No.") then begin
                    if (TempQty + Quantity) > PRLine.Quantity then
                        FieldError(Quantity, StrSubstNo(PrRemainingErr, "YVS Ref. PQ No.", PRLine.Quantity - TempQty));

                    PRLine."Outstanding Quantity" := PRLine.Quantity - (TempQty + Quantity);
                    PRLine."Outstanding Qty. (Base)" := PRLine."Quantity (Base)" - (TempQtyBase + "Quantity (Base)");
                    PRLine."Completely Received" := PRLine."Outstanding Quantity" = 0;
                    PRLine.Modify();
                end;
        end;



    end;



    /// <summary>
    /// OnAfterValidateSelectBy.
    /// </summary>
    /// <param name="UserName">VAR Code[30].</param>
    [IntegrationEvent(false, false)]
    procedure OnAfterValidateSelectBy(var UserName: Code[30])
    begin
    end;


    local procedure CalWhtAmount()
    var
        WHTPostingSetup: Record "YVS WHT Posting Setup";
    begin
        IF WHTPostingSetup.GET(rec."YVS WHT Business Posting Group", rec."YVS WHT Product Posting Group") THEN BEGIN
            "YVS WHT Base" := rec."Line Amount";
            "YVS WHT %" := WHTPostingSetup."WHT %";
            "YVS WHT Amount" := ROUND(("YVS WHT Base") * (WHTPostingSetup."WHT %" / 100), 0.01);
            "YVS WHT Option" := "YVS WHT Option"::"(1) หักภาษี ณ ที่จ่าย";
        END
        ELSE BEGIN
            "YVS WHT Base" := 0;
            "YVS WHT %" := 0;
            "YVS WHT Amount" := 0;
            "YVS WHT Option" := "YVS WHT Option"::" ";
        END;
    end;

    local procedure checkBeforQtyToCancal()
    var
        POLine: Record "Purchase Line";
        TempQty: Decimal;
    begin
        POLine.reset();
        POLine.SetRange("Document Type", POLine."Document Type"::Order);
        POLine.SetRange("YVS Ref. PQ No.", "Document No.");
        POLine.SetRange("YVS Ref. PQ Line No.", "Line No.");
        if POLine.FindFirst() then begin
            POLine.CalcSums(Quantity);
            TempQty := POLine.Quantity;
            if (TempQty + "YVS Qty. to Cancel") > rec."Outstanding Quantity" then
                FieldError("Outstanding Quantity", StrSubstNo(PrRemainingOutStdErr, rec."Outstanding Quantity"));
        end;
    end;

    var
        PrRemainingErr: Label 'PR No. %1 ,Remaining Quantity is %2', Locked = true;
        PrRemainingOutStdErr: Label 'Remaining Quantity is %1', Locked = true;

}