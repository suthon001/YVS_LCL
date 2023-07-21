/// <summary>
/// Report YVS AP Voucher (ID 80031).
/// </summary>
report 80031 "YVS AP Voucher (Post)"
{
    Permissions = TableData "G/L Entry" = rimd;
    Caption = 'AP Voucher';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80031_APVoucherPosted.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = None;
    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            DataItemTableView = sorting("Entry No.") where(Amount = filter(<> 0));
            UseTemporary = true;
            column(G_L_Account_No_; "G/L Account No.") { }
            column(G_L_Account_Name; AccountName) { }
            column(Debit_Amount; "Debit Amount") { }
            column(Credit_Amount; "Credit Amount") { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            column(External_Document_No_; "External Document No.") { }
            column(companyInfor_Picture; companyInfor.Picture) { }
            column(PostingDate; format(PurHeader."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(DocumentDate; format(PurHeader."Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(DueDate; format(PurHeader."Due Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(DocumentNo; PurHeader."No.") { }
            column(ExchangeRate; ExchangeRate) { }
            column(PostingDescription; PurHeader."Posting Description") { }
            column(ComText_1; ComText[1]) { }
            column(ComText_2; ComText[2]) { }
            column(ComText_3; ComText[3]) { }
            column(ComText_4; ComText[4]) { }
            column(ComText_5; ComText[5]) { }
            column(ComText_6; ComText[6]) { }
            column(VendText_1; VendText[1]) { }
            column(VendText_2; VendText[2]) { }
            column(VendText_3; VendText[3]) { }
            column(VendText_4; VendText[4]) { }
            column(VendText_5; VendText[5]) { }
            column(VendText_9; VendText[9]) { }
            column(VendText_10; VendText[10]) { }
            column(CreateDocBy; PurHeader."YVS Create By") { }
            column(SplitDate_1; SplitDate[1]) { }
            column(SplitDate_2; SplitDate[2]) { }
            column(SplitDate_3; SplitDate[3]) { }
            column(AmtText; AmtText) { }
            column(HaveItemLine; HaveItemLine) { }
            column(HaveItemCharge; HaveItemCharge) { }
            column(HaveItemVAT; HaveItemVAT) { }
            column(HAVEWHT; HAVEWHT) { }

            trigger OnPreDataItem()
            var
                NewDate: Date;
            begin


                FunctionCenter.SetReportGLEntryPosted(PurHeader."No.", PurHeader."Posting Date", GLEntry, TempAmt, groupping);
                companyInfor.get();
                companyInfor.CalcFields(Picture);
                if PurHeader."Currency Code" = '' then
                    FunctionCenter."CompanyinformationByVat"(ComText, PurHeader."VAT Bus. Posting Group", false)
                else
                    FunctionCenter."CompanyinformationByVat"(ComText, PurHeader."VAT Bus. Posting Group", true);

                FunctionCenter.PurchasePostedVendorInformation(2, PurHeader."No.", VendText, 0);
                FunctionCenter."ConvExchRate"(PurHeader."Currency Code", PurHeader."Currency Factor", ExchangeRate);
                if PurHeader."Currency Code" = '' then
                    AmtText := '(' + FunctionCenter."NumberThaiToText"(TempAmt) + ')'
                else
                    AmtText := '(' + FunctionCenter."NumberEngToText"(TempAmt, PurHeader."Currency Code") + ')';

                NewDate := DT2Date(PurHeader."YVS Create DateTime");
                SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                SplitDate[3] := Format(NewDate, 0, '<Year4>');
                "CheckLineData"();
            end;

            trigger OnAfterGetRecord()
            begin
                if not glAccount.GET("G/L Account No.") then
                    glAccount.Init();
                AccountName := glAccount.Name;
            end;
        }
        dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
        {
            DataItemTableView = sorting("Document No.", "Line No.") where(Type = const(Item));


            column(No_; "No.") { }
            column(Description; Description + ' ' + "Description 2") { }
            column(Location_Code; "Location Code") { }
            column(Unit_of_Measure_Code; "Unit of Measure Code") { }
            column(Quantity; Quantity) { }
            column(Direct_Unit_Cost; "Direct Unit Cost") { }
            column(Amount; Amount) { }
            column(Amount_Including_VAT; "Amount Including VAT") { }
            column(Line_Amount; "Line Amount") { }
            column(Receipt_No_; "Receipt No.") { }
            trigger OnPreDataItem()
            begin

                SetRange("Document No.", PurHeader."No.");
            end;
        }
        dataitem("PurchaseLineTaxInvoice"; "Purch. Inv. Line")
        {
            DataItemTableView = sorting("Document No.", "Line No.") where("YVS Tax Invoice No." = filter(<> ''));

            column(Tax_Invoice_No_; "YVS Tax Invoice No.") { }
            column(Tax_Invoice_Date; format("YVS Tax Invoice Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(Tax_Invoice_Name; "YVS Tax Invoice Name") { }
            column(Tax_Invoice_Amount; "YVS Tax Invoice Amount") { }
            column(Tax_Invoice_Base; "YVS Tax Invoice Base") { }
            column(Vat_Registration_No_; "YVS Vat Registration No.") { }
            column(BranchCode; BranchCode) { }
            trigger OnPreDataItem()
            begin

                SetRange("Document No.", PurHeader."No.");
            end;

            trigger OnAfterGetRecord()
            begin
                if "YVS Head Office" then
                    BranchCode := 'สำนักงานใหญ่'
                else
                    BranchCode := "YVS VAT Branch Code";

            end;
        }
        dataitem(PurchaseItemCharge; "Purch. Inv. Line")
        {
            DataItemTableView = sorting("Document No.", "Line No.")
            where(Type = const("Charge (Item)"));

            dataitem(ItemChargeAssignment; "Value Entry")
            {
                DataItemTableView = sorting("Entry No.") where("Item Charge No." = filter(<> ''));
                DataItemLink = "Document No." = FIELD("Document No."), "Document Line No." = FIELD("Line No.");
                column(Applies_to_Doc__No_; "Document No.") { }
                column(Item_No_; "Item No.") { }
                column(ItemChangeDescription; Description) { }
                column(Amount_to_Assign; "Cost Amount (Actual)") { }
                column(Qty__to_Assign; "Valued Quantity") { }
                column(vgVendorNoItemCharge; vgVendorNoItemCharge) { }
                column(vgQtyonReceiptItemCharge; vgQtyonReceiptItemCharge) { }
                column(vgUOMFromItemCharge; vgUOMFromItemCharge) { }
                trigger OnAfterGetRecord()
                var
                    PurchRcptHeader: Record "Purch. Rcpt. Header";
                    PurchRcptLine: Record "Purch. Rcpt. Line";
                    Item: Record Item;
                    ItemLedger: Record "Item Ledger Entry";
                begin
                    IF NOT Item.GET("Item No.") THEN
                        Item.init();
                    vgUOMFromItemCharge := Item."Base Unit of Measure";


                    IF NOT PurchRcptHeader.GET(ItemLedger."Document No.") then
                        PurchRcptHeader.init();
                    vgVendorNoItemCharge := PurchRcptHeader."Buy-from Vendor No.";

                    ItemLedger.GET("Item Ledger Entry No.");
                    if not PurchRcptLine.GET(ItemLedger."Document No.", ItemLedger."Document Line No.") then
                        PurchRcptLine.Init();

                    vgQtyonReceiptItemCharge := PurchRcptLine.Quantity;
                end;
            }
            trigger OnPreDataItem()
            begin

                SetRange("Document No.", PurHeader."No.");
            end;
        }
        dataitem(WHTLINE; "Purch. Inv. Line")
        {

            DataItemTableView = SORTING("Document No.", "Line No.") where("YVS WHT Product Posting Group" = filter(<> ''));

            column(NCT_WHT_Bus__Posting_Group; "YVS WHT Business Posting Group") { }
            column(NCT_WHT_Product_Posting_Group; "YVS WHT Product Posting Group") { }
            column(NCT_WHT_Option; format("YVS WHT Option")) { }
            column(NCT_WHT_Base; "YVS WHT Base") { }
            column(NCT_WHT_Amount; "YVS WHT Amount") { }
            column(NCT_WHT__; "YVS WHT %") { }
            trigger OnPreDataItem()
            begin

                SetRange("Document No.", PurHeader."No.");
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(gvgroupping; groupping)
                {
                    ApplicationArea = all;
                    ToolTip = 'Grouping data';
                    Caption = 'Grouping G/L Account';
                }
            }
        }

    }

    /// <summary> 
    /// Description for CheckLineData.
    /// </summary>
    procedure "CheckLineData"()
    var
        PurchaseLine: Record "Purch. Inv. Line";
    begin
        PurchaseLine.reset();
        PurchaseLine.SetRange("Document No.", PurHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        HaveItemLine := PurchaseLine.Count <> 0;
        PurchaseLine.SetRange(Type);
        PurchaseLine.SetFilter("YVS Tax Invoice No.", '<>%1', '');
        HaveItemVAT := PurchaseLine.Count <> 0;

        PurchaseLine.reset();
        PurchaseLine.SetRange("Document No.", PurHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::"Charge (Item)");
        HaveItemCharge := PurchaseLine.Count <> 0;


        PurchaseLine.RESET();
        PurchaseLine.SETRANGE("Document No.", PurHeader."No.");
        PurchaseLine.SETFILTER("YVS WHT Product Posting Group", '<>%1', '');
        HAVEWHT := PurchaseLine.Count <> 0;



    end;

    /// <summary> 
    /// Description for SetGLEntry.
    /// </summary>
    /// <param name="PurchaseHeader">Parameter of type Record "Purch. Inv. Header".</param>
    procedure "SetGLEntry"(PurchaseHeader: Record "Purch. Inv. Header")
    begin
        PurHeader.GET(PurchaseHeader."No.");
    end;

    var
        PurHeader: Record "Purch. Inv. Header";
        FunctionCenter: Codeunit "YVS Function Center";
        companyInfor: Record "Company Information";
        ExchangeRate: Text[30];
        ComText: array[10] Of Text[250];
        VendText: array[10] Of Text[250];
        BranchCode: Text[50];
        SplitDate: Array[3] of Text[20];
        vgUOMFromItemCharge: Code[10];
        vgVendorNoItemCharge: Code[20];
        vgQtyonReceiptItemCharge: Decimal;
        AmtText: Text[1024];
        TempAmt: Decimal;
        HaveItemLine: Boolean;
        HaveItemCharge: Boolean;
        HaveItemVAT, HAVEWHT : Boolean;
        groupping: Boolean;
        AccountName: text[100];
        glAccount: Record "G/L Account";

}
