/// <summary>
/// Table YVS WHT Header (ID 80006).
/// </summary>
table 80006 "YVS WHT Header"
{
    Caption = 'WHT Header';
    DataClassification = CustomerContent;
    fields
    {
        field(1; "WHT No."; Code[20])
        {
            Caption = 'WHT No.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(2; "WHT Business Posting Group"; Code[20])
        {
            Caption = 'WHT Business Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "YVS WHT Business Posting Group";

        }
        field(3; "WHT Certificate No."; Code[20])
        {
            Caption = 'WHT Certificate No';
            DataClassification = CustomerContent;
        }
        field(4; "WHT Date"; Date)
        {
            Caption = 'WHT Date';
            DataClassification = CustomerContent;
        }
        field(5; "WHT Source Type"; Option)
        {
            OptionMembers = Vendor,Customer;
            OptionCaption = 'Vendor,Customer';
            Caption = 'WHT Source Type';
            DataClassification = CustomerContent;

        }
        field(6; "WHT Source No."; Code[20])
        {
            Caption = 'WHT Source No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("WHT Source Type" = CONST(Vendor)) Vendor else
            IF ("WHT Source Type" = CONST(Customer)) Customer;
            trigger OnValidate()
            var
                Vendor: Record Vendor;
                Customer: Record Customer;
                whtBusPostingGroup: Record "YVS WHT Business Posting Group";
            begin
                IF "WHT Source Type" = "WHT Source Type"::Vendor THEN BEGIN
                    IF Vendor.GET("WHT Source No.") THEN BEGIN
                        "WHT Source No." := Vendor."No.";
                        "WHT Name" := Vendor.Name;
                        "WHT Name 2" := Vendor."Name 2";
                        "WHT Address" := Vendor.Address;
                        "WHT Address 2" := Vendor."Address 2";
                        "VAT Registration No." := Vendor."VAT Registration No.";
                        "Head Office" := Vendor."YVS Head Office";
                        "VAT Branch Code" := Vendor."YVS VAT Branch Code";
                        "WHT Business Posting Group" := Vendor."YVS WHT Business Posting Group";
                        if NOT whtBusPostingGroup.GET(Vendor."YVS WHT Business Posting Group") then
                            whtBusPostingGroup.init();
                        "WHT Type" := whtBusPostingGroup."WHT Type";
                        "WHT City" := Vendor.City;
                        "WHT Post Code" := Vendor."Post Code";
                        "WHT Title Name" := Vendor."YVS WHT Title Name";
                        "WHT Name" := Vendor."YVS WHT Name";
                        "WHT Building" := Vendor."YVS WHT Building";
                        "WHT District" := Vendor."YVS WHT District";
                        "WHT Sub-district" := Vendor."YVS WHT Sub-district";
                        "WHT Province" := Vendor."YVS WHT Province";
                        "WHT Alley/Lane" := Vendor."YVS WHT Alley/Lane";
                        "WHT of No." := Vendor."YVS WHT No.";
                        "WHT House No." := Vendor."YVS WHT House No.";
                        "Wht Post Code" := Vendor."Post Code";
                        if Vendor."YVS WHT Post Code" <> '' then
                            "Wht Post Code" := Vendor."YVS WHT Post Code";
                        if Vendor."YVS WHT Province" <> '' then
                            "WHT City" := Vendor."YVS WHT Province";
                        OnAfterinitWHTHeaderVend(rec, Vendor);
                        UpdateAddress();
                    END;
                END ELSE
                    IF Customer.GET("WHT Source No.") THEN BEGIN
                        "WHT Source No." := Customer."No.";
                        "WHT Name" := Customer.Name;
                        "WHT Name 2" := Customer."Name 2";
                        "WHT Address" := Customer.Address;
                        "WHT Address 2" := Customer."Address 2";
                        "VAT Registration No." := Customer."VAT Registration No.";
                        "Head Office" := Customer."YVS Head Office";
                        "VAT Branch Code" := Customer."YVS VAT Branch Code";
                        "WHT Business Posting Group" := Customer."YVS WHT Business Posting Group";
                        if NOT whtBusPostingGroup.GET(Customer."YVS WHT Business Posting Group") then
                            whtBusPostingGroup.init();
                        "WHT Type" := whtBusPostingGroup."WHT Type";
                        "WHT City" := Customer.City;
                        "WHT Post Code" := Customer."Post Code";
                        OnAfterinitWHTHeaderCust(rec, Customer);
                    END;

            end;
        }
        field(7; "WHT Name"; Text[160])
        {
            Caption = 'WHT Name';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TrasnferToWHTLine();
            end;
        }
        field(8; "WHT Name 2"; Text[50])
        {
            Caption = 'WHT Name 2';
            DataClassification = CustomerContent;
        }
        field(9; "WHT Address"; Text[100])
        {
            Caption = 'WHT Address';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin

                TrasnferToWHTLine();
            end;
        }
        field(10; "WHT Address 2"; Text[100])
        {
            Caption = 'WHT Address 2';
            DataClassification = CustomerContent;
        }
        field(11; "WHT Address 3"; Text[100])
        {
            Caption = 'WHT Address 3';
            DataClassification = CustomerContent;
        }
        field(12; "WHT City"; Text[50])
        {
            Caption = 'WHT City';
            DataClassification = CustomerContent;
        }
        field(13; "VAT Registration No."; Code[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = CustomerContent;
        }
        field(14; "Head Office"; Boolean)
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Head Office" then
                    "VAT Branch Code" := '';
            end;
        }
        field(15; "VAT Branch Code"; Code[5])
        {
            Caption = 'VAT Branch Code';
            DataClassification = CustomerContent;
            TableRelation = IF ("WHT Source Type" = CONST(Vendor)) "YVS Customer & Vendor Branch"."VAT Branch Code" WHERE("Source Type" = FILTER(Vendor), "Source No." = FIELD("WHT Source No.")) ELSE
            IF ("WHT Source Type" = CONST(Customer)) "YVS Customer & Vendor Branch"."VAT Branch Code" WHERE("Source Type" = FILTER(Customer), "Source No." = FIELD("WHT Source No."));
            ValidateTableRelation = true;
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
        field(16; "Gen. Journal Template Code"; Code[10])
        {
            Caption = 'Gen. Journal Template Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(17; "Gen. Journal Batch Code"; Code[10])
        {
            Caption = 'Gen. Journal Batch Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(18; "Gen. Journal Line No."; Integer)
        {
            Caption = 'Gen. Journal Line No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(19; "Gen. Journal Document No."; Code[20])
        {
            Caption = 'Gen. Journal Document No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(20; "WHT Type"; Enum "YVS WHT Type")
        {
            Caption = 'WHT Type';
            DataClassification = CustomerContent;

        }
        field(21; "WHT Option"; Enum "YVS WHT Option")
        {
            Caption = 'WHT Option';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TrasnferToWHTLine();
            end;
        }
        field(22; "WHT Base"; Decimal)
        {
            Caption = 'WHT Base';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("YVS WHT Line"."WHT Base" where("WHT No." = field("WHT No.")));

        }
        field(23; "WHT Amount"; Decimal)
        {
            Caption = 'WHT Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("YVS WHT Line"."WHT Amount" where("WHT No." = field("WHT No.")));

        }
        field(24; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = SystemMetadata;
        }
        field(25; "Posted"; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(26; "Wht Post Code"; Text[20])
        {
            Caption = 'รหัสไปรษณีย์';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TrasnferToWHTLine();
            end;

        }
        field(27; "Get to WHT"; Boolean)
        {
            Caption = 'Get to WHT';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(28; "WHT Title Name"; Enum "YVS Title Document Name")
        {
            Caption = 'คำนำหน้า';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "WHT Title Name" <> "WHT Title Name"::" " then
                    "WHT Name" := COPYSTR(format("WHT Title Name") + ' ' + "WHT Name", 1, 160)
                else
                    "WHT Name" := "WHT Name";
            end;
        }
        field(29; "WHT Building"; Text[100])
        {
            Caption = 'ชื่ออาคาร/หมู่บ้าน';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateAddress();
            end;
        }
        field(30; "WHT Alley/Lane"; Text[100])
        {
            Caption = 'ตรอก/ซอย';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateAddress();
            end;
        }
        field(31; "WHT Sub-district"; Text[100])
        {
            Caption = 'ตำบล/แขวง';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateAddress();
            end;
        }
        field(32; "WHT District"; Text[100])
        {
            Caption = 'อำเภอ/เขต';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateAddress();
            end;
        }
        field(33; "WHT Floor"; Text[10])
        {
            Caption = 'ชั้น';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateAddress();
            end;
        }
        field(34; "WHT House No."; Text[50])
        {
            Caption = 'เลขที่ห้อง';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateAddress();
            end;
        }
        field(35; "WHT Village No."; Text[15])
        {
            Caption = 'หมู่ที่';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateAddress();
            end;
        }
        field(36; "WHT Street"; Text[50])
        {
            Caption = 'ถนน';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateAddress();
            end;
        }
        field(37; "WHT Province"; Text[50])
        {
            Caption = 'จังหวัด';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateAddress();
            end;
        }

        field(38; "WHT of No."; code[20])
        {
            Caption = 'เลขที่';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateAddress();
            end;
        }
    }
    keys
    {
        key(PK; "WHT No.")
        {
            Clustered = true;
        }
    }

    local procedure UpdateAddress()
    var
        VTxT: Text;
        i: Integer;
        Addr: array[4] of text[100];
    begin
        Clear(VTxT);
        i := 1;
        if "WHT Building" <> '' then begin
            VTxT := 'อาคาร/หมู่บ้าน ' + "WHT Building" + ' ';
            i := CheckLen(Addr[i], VTxT, i);
            Addr[i] += VTxT;
        end;
        if "WHT House No." <> '' then begin
            VTxT := 'เลขที่บ้าน ' + "WHT House No." + ' ';
            i := CheckLen(Addr[i], VTxT, i);
            Addr[i] += VTxT;
        end;
        if "WHT Village No." <> '' then begin
            VTxT := 'หมู่ที่ ' + "WHT Village No." + ' ';
            i := CheckLen(Addr[i], VTxT, i);
            Addr[i] += VTxT;
        end;
        if "WHT Floor" <> '' then begin
            VTxT := 'ชั้น ' + "WHT Floor" + ' ';
            i := CheckLen(Addr[i], VTxT, i);
            Addr[i] += VTxT;
        end;
        if "WHT of No." <> '' then begin
            VTxT := 'ห้องเลขที่ ' + "WHT of No." + ' ';
            i := CheckLen(Addr[i], VTxT, i);
            Addr[i] += VTxT;
        end;
        if "WHT Street" <> '' then begin
            VTxT := 'ถนน' + "WHT Street" + ' ';
            i := CheckLen(Addr[i], VTxT, i);
            Addr[i] += VTxT;
        end;
        if "WHT Alley/Lane" <> '' then begin
            VTxT := 'ซอย' + "WHT Alley/Lane" + ' ';
            i := CheckLen(Addr[i], VTxT, i);
            Addr[i] += VTxT;
        end;
        if StrPos("WHT City", 'กรุงเทพ') <> 0 then begin
            Clear(VTxT);
            if "WHT Sub-district" <> '' then begin
                VTxT := 'แขวง' + "WHT Sub-district" + ' ';
                i := CheckLen(Addr[i], VTxT, i);
                Addr[i] += VTxT;
            end;
            if "WHT District" <> '' then begin
                VTxT := 'เขต' + "WHT District" + ' ';
                i := CheckLen(Addr[i], VTxT, i);
                Addr[i] += VTxT;
            end;
        end else begin
            Clear(VTxT);
            if "WHT Sub-district" <> '' then begin
                VTxT := 'ตำบล' + "WHT Sub-district" + ' ';
                i := CheckLen(Addr[i], VTxT, i);
                Addr[i] += VTxT;
            end;
            if "WHT District" <> '' then begin
                VTxT := 'อำเภอ' + "WHT District" + ' ';
                i := CheckLen(Addr[i], VTxT, i);
                Addr[i] += VTxT;
            end;
        end;

        if Addr[1] <> '' then begin
            Rec."WHT Address" := Addr[1];
            Rec."WHT Address 2" := '';
            Rec."WHT Address 3" := '';
        end;
        if Addr[2] <> '' then
            Rec."WHT Address 2" := Addr[2];
        if Addr[3] <> '' then
            Rec."WHT Address 3" := Addr[3];

    end;

    local procedure CheckLen(Txt: text; inTxt: text; i: Integer): Integer
    begin
        if StrLen(Txt) + StrLen(inTxt) > 100 then
            exit(i + 1);
        exit(i);
    end;
    /// <summary> 
    /// Description for AssistEditCertificate.
    /// </summary>
    /// <returns>Return variable "Boolean".</returns>
    procedure AssistEditCertificate(): Boolean
    var

        WHTBus: Record "YVS WHT Business Posting Group";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewSeries: Code[20];
    begin

        WHTBus.GET("WHT Business Posting Group");
        WHTBus.TESTFIELD("WHT Certificate No. Series");
        IF NoSeriesMgt.SelectSeries(WHTBus."WHT Certificate No. Series", "No. Series", NewSeries) THEN
            "WHT Certificate No." := NoSeriesMgt.GetNextNo(NewSeries, Today, TRUE);

    end;


    /// <summary> 
    /// Description for SetWHT.
    /// </summary>
    /// <param name="GenLine">Parameter of type Record "Gen. Journal Line".</param>
    procedure "SetWHT"(GenLine: Record "Gen. Journal Line")
    begin
        Genlines.reset();
        Genlines.copy(GenLine);
        Genlines.FindFirst();
    end;

    trigger OnDelete()
    var
        WHTLine: Record "YVS WHT Line";
        ltGenJournalLine: Record "Gen. Journal Line";
    begin

        WHTLine.RESET();
        WHTLine.SETRANGE("WHT No.", "WHT No.");
        IF WHTLine.FindFirst() THEN
            WHTLine.DELETEALL(TRUE);
        if ltGenJournalLine.GET(rec."Gen. Journal Template Code", rec."Gen. Journal Batch Code", rec."Gen. Journal Line No.") then
            ltGenJournalLine.Delete(true);
    end;

    local procedure TrasnferToWHTLine()
    var
        ltWHTLine: Record "YVS WHT Line";
    begin
        ltWHTLine.reset();
        ltWHTLine.SetRange("WHT No.", rec."WHT No.");
        ltWHTLine.SetFilter("WHT Product Posting Group", '<>%1', '');
        if ltWHTLine.FindSet() then
            repeat
                ltWHTLine.TransferFromHeader();
                ltWHTLine.Modify();
            until ltWHTLine.Next() = 0;

    end;

    [IntegrationEvent(true, false)]

    procedure OnAfterinitWHTHeaderVend(var WHTHeader: Record "YVS WHT Header"; Vend: Record Vendor)
    begin

    end;

    [IntegrationEvent(true, false)]

    procedure OnAfterinitWHTHeaderCust(var WHTHeader: Record "YVS WHT Header"; Cust: Record Customer)
    begin

    end;

    var
        Genlines: Record "Gen. Journal Line";
}
