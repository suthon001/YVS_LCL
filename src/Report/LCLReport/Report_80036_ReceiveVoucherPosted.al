/// <summary>
/// Report YVS Receive Voucher (ID 80036).
/// </summary>
report 80036 "YVS Receive Voucher (Post)"
{
    Permissions = TableData "G/L Entry" = rimd;
    Caption = 'Receive Voucher';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80036_ReceiveVoucherPosted.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = None;
    dataset
    {
        dataitem(GenJournalLine; "Posted Gen. Journal Line")
        {
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Document No.";
            MaxIteration = 1;
            dataitem(GLEntry; "G/L Entry")
            {
                DataItemTableView = sorting("Entry No.") where(Amount = filter(<> 0));
                UseTemporary = true;
                CalcFields = "G/L Account Name";
                column(JournalDescriptionEng; JournalDescriptionEng) { }
                column(Journal_Batch_Name; "Journal Batch Name") { }
                column(JournalDescriptionThai; JournalDescriptionThai) { }
                column(G_L_Account_No_; "G/L Account No.") { }
                column(G_L_Account_Name; AccountName) { }
                column(Debit_Amount; "Debit Amount") { }
                column(Credit_Amount; "Credit Amount") { }
                column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
                column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
                column(External_Document_No_; "External Document No.") { }
                column(companyInfor_Picture; companyInfor.Picture) { }
                column(PostingDate; format(GenJournalLine."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(DocumentDate; format(GenJournalLine."Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(DocumentNo; GenJournalLine."DOcument No.") { }
                column(ExchangeRate; ExchangeRate) { }
                column(PostingDescription; PostingDescription) { }
                column(Journal_Description; "YVS Journal Description") { }
                column(ComText_1; ComText[1]) { }
                column(ComText_2; ComText[2]) { }
                column(ComText_3; ComText[3]) { }
                column(ComText_4; ComText[4]) { }
                column(ComText_5; ComText[5]) { }
                column(ComText_6; ComText[6]) { }
                column(CustText_1; CustText[1]) { }
                column(CustText_2; CustText[2]) { }
                column(CustText_3; CustText[3]) { }
                column(CustText_4; CustText[4]) { }
                column(CustText_5; CustText[5]) { }
                column(CustText_9; CustText[9]) { }
                column(CustText_10; CustText[10]) { }
                column(CreateDocBy; UserName) { }
                column(SplitDate_1; SplitDate[1]) { }
                column(SplitDate_2; SplitDate[2]) { }
                column(SplitDate_3; SplitDate[3]) { }
                column(AmtText; AmtText) { }
                column(haveCheque; haveCheque) { }
                column(HaveApply; HaveApply) { }
                column(HaveWHT; HaveWHT) { }
                column(HaveItemVAT; HaveItemVAT) { }
                column(HaveBankAccount; HaveBankAccount) { }
                column(GenjournalTemplate_DescThai; GenJournalBatchName.Description) { }
                trigger OnAfterGetRecord()

                begin
                    if not glAccount.GET("G/L Account No.") then
                        glAccount.Init();
                    AccountName := glAccount.Name;
                end;

            }
            dataitem(ApplyEntry; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                column(CVBufferEntry_DocumentNO; CVBufferEntry."Document No.") { }
                column(CVBufferEntry_ApplyAmount; CVBufferEntry."Amount to Apply") { }
                column(CVBufferEntry_RemainingAmt; CVBufferEntry."Remaining Amount") { }
                column(CVBufferEntry_DueDate; format(CVBufferEntry."Due Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(CVBufferEntry_DocumnentDate; format(CVBufferEntry."Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(CVBufferEntry_ExternalDoc; CVBufferEntry."External Document No.") { }
                column(CV_RemimAmt; CVBufferEntry."Remaining Amount" - CVBufferEntry."Amount to Apply") { }
                column(CVBufferEntry_Golbal_Dimension_1_Code; CVBufferEntry."Global Dimension 1 Code") { }
                column(CVBufferEntry_Currency_Code; CVBufferEntry."Currency Code") { }



                trigger OnAfterGetRecord()
                begin
                    IF Number = 1 THEN
                        OK := CVBufferEntry.FindFirst()
                    ELSE
                        OK := CVBufferEntry.NEXT() <> 0;
                    IF NOT OK THEN
                        CurrReport.BREAK();
                end;
            }
            dataitem(GenJournalLineVAT; "Posted Gen. Journal Line")
            {
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.") where("YVS Require Screen Detail" = filter(VAT));

                column(Tax_Invoice_Date; format("YVS Tax Invoice Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(Tax_Invoice_No_; "YVS Tax Invoice No.") { }
                column(Tax_Invoice_Name; "YVS Tax Invoice Name") { }
                column(Tax_Invoice_Amount; ABS("YVS Tax Invoice Amount")) { }
                column(Tax_Invoice_Base; ABS("YVS Tax Invoice Base")) { }
                column(BranchCode; BranchCode) { }
                column(Vat_Registration_No_; "VAT Registration No.") { }
                trigger OnPreDataItem()
                begin
                    SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
                    SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
                    SetRange("Document No.", GenJournalLine."Document No.");
                end;

                trigger OnAfterGetRecord()
                begin
                    if "YVS Head Office" then
                        BranchCode := 'สำนักงานใหญ่'
                    else
                        BranchCode := "YVS VAT Branch Code";


                end;
            }
            dataitem(GenJournalLineWHT; "YVS WHT Header")
            {

                DataItemTableView = sorting("WHT No.") where("posted" = const(false));
                dataitem("WHT Lines"; "YVS WHT Line")
                {
                    DataItemTableView = sorting("WHT No.", "WHT Line No.");
                    DataItemLink = "WHT No." = field("WHT No.");

                    column(WHT_Document_No_; GenJournalLineWHT."WHT Certificate No.") { }
                    column(WHT_Date; format("WHT Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                    column(WHT_Name; "WHT Name" + ' ' + "WHT Name 2") { }
                    column(WHT__; "WHT %") { }
                    column(WHT_Amount; "WHT Amount") { }
                    column(WHT_Base; "WHT Base") { }
                    column(WHT_Product_Posting_Group; "WHT Lines"."WHT Product Posting Group") { }
                    column(WHT_Business_Posting_Group; GenJournalLineWHT."WHT Business Posting Group") { }

                }
                trigger OnPreDataItem()
                begin
                    SetRange("Gen. Journal Template Code", GenJournalLine."Journal Template Name");
                    SetRange("Gen. Journal Batch Code", GenJournalLine."Journal Batch Name");
                    SetRange("Gen. Journal Document No.", GenJournalLine."Document No.");
                end;
            }
            dataitem(GenJournalLineBankAccount; "Posted Gen. Journal Line")
            {
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.") where("Account Type" = filter("Bank Account"));

                column(BankBranchNo; BankBranchNo) { }
                column(BankName; BankName) { }
                column(VendorBankAccountName; VendorBankAccountName) { }
                column(Bank_Amount__LCY_; ABS("Amount (LCY)")) { }
                column(Bank_Account_No_; "Account No.") { }

                trigger OnPreDataItem()
                begin
                    SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
                    SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
                    SetRange("Document No.", GenJournalLine."Document No.");
                end;

                trigger OnAfterGetRecord()
                var
                    BankAccount: Record "Bank Account";
                    GenJournalLineBank: Record "Posted Gen. Journal Line";
                    VendorBankAccount: Record "Vendor Bank Account";
                begin
                    VendorBankAccountName := '';
                    if not BankAccount.get("Account No.") then
                        BankAccount.init();

                    BankName := BankAccount.Name + ' ' + BankAccount."Name 2";
                    BankBranchNo := BankAccount."Bank Branch No.";

                    GenJournalLineBank.RESET();
                    GenJournalLineBank.SETFILTER("Document No.", '%1', "Document No.");
                    GenJournalLineBank.SETFILTER("Account Type", '%1', GenJournalLineBank."Account Type"::Vendor);
                    GenJournalLineBank.SETFILTER("Recipient Bank Account", '<>%1', '');
                    IF GenJournalLineBank.FindFirst() THEN BEGIN
                        IF NOT VendorBankAccount.GET(GenJournalLineBank."Account No.", GenJournalLineBank."Recipient Bank Account") THEN
                            VendorBankAccount.init();
                        VendorBankAccountName := VendorBankAccount.Name;

                    END;
                end;
            }
            dataitem(GenJournalLineCheque; "Posted Gen. Journal Line")
            {
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.") where("YVS Require Screen Detail" = filter(Cheque));

                column(Pay_Name; "YVS Pay Name") { }
                column(CQ_Bank_Account_No_; "YVS Bank Account No.") { }
                column(CQ_Bank_Branch_No_; "YVS Bank Branch No.") { }
                column(CQ_Bank_Code; "YVS Bank Code") { }
                column(CQ_Bank_Name; "YVS Bank Name") { }
                column(CQ_Cheque_Date; format("YVS Cheque Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(CQ_Cheque_No_; "YVS Cheque No.") { }
                column(CQ_Name; '') { }
                column(CQ_Customer_Vendor; "YVS Customer/Vendor No.") { }
                column(Cheque_Amount__LCY_; ABS("Amount (LCY)")) { }

                trigger OnPreDataItem()
                begin
                    SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
                    SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
                    SetRange("Document No.", GenJournalLine."Document No.");
                end;

            }
            trigger OnPreDataItem()
            begin
                companyInfor.get();
                companyInfor.CalcFields(Picture);
                FunctionCenter.CompanyInformation(ComText, false);
            end;

            trigger OnAfterGetRecord()
            var
                ltGenjournalTemplate: Record "Gen. Journal Template";
                NewDate: Date;
            begin
                FunctionCenter.SetReportGLEntryPosted(GenJournalLine."Document No.", GenJournalLine."Posting Date", GLEntry, TempAmt, groupping);
                GetCustExchange();
                FunctionCenter.CusInfo(CustCode, CustText);

                FunctionCenter."ConvExchRate"(CurrencyCode, CurrencyFactor, ExchangeRate);
                AmtText := '(' + FunctionCenter."NumberThaiToText"(TempAmt) + ')';
                gvGenLine.reset();
                gvGenLine.SetRange("Journal Template Name", "Journal Template Name");
                gvGenLine.SetRange("Journal Batch Name", "Journal Batch Name");
                gvGenLine.SetRange("Document No.", "Document No.");
                gvGenLine.SetFilter("YVS Create By", '<>%1', '');
                if gvGenLine.FindFirst() then begin
                    UserName := gvGenLine."YVS Create By";
                    NewDate := DT2Date(gvGenLine."YVS Create DateTime");
                    SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                    SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                    SplitDate[3] := Format(NewDate, 0, '<Year4>');
                end;
                CheckLineData();
                FindPostingDescription();
                ltGenjournalTemplate.Get(GenJournalLine."Journal Template Name");
                GenJournalBatchName.GET(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");


                JournalDescriptionThai := ltGenjournalTemplate."YVS Description Thai";
                JournalDescriptionEng := ltGenjournalTemplate."YVS Description Eng";


                CVBufferEntry.Reset();
                CVBufferEntry.DeleteAll();
                FunctionCenter.PostedJnlFindApplyEntries(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", GenJournalLine."Posting Date",
                GenJournalLine."Document No.", CVBufferEntry);
                HaveApply := CVBufferEntry.Count <> 0;
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
        trigger OnInit()
        begin
            groupping := true;
        end;
    }
    /// <summary> 
    /// Description for GetCustExchange.
    /// </summary>
    procedure "GetCustExchange"()
    var
        GenLine: Record "Posted Gen. Journal Line";
    begin
        GenLine.reset();
        GenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLine.SetRange("Document No.", GenJournalLine."Document No.");
        GenLine.SetRange("Account Type", GenLine."Account Type"::Customer);
        if GenLine.FindFirst() then
            CustCode := GenLine."Account No.";
        GenLine.SetFilter("Currency Code", '<>%1', '');
        if GenLine.FindFirst() then begin
            CurrencyCode := GenLine."Currency Code";
            CurrencyFactor := GenLine."Currency Factor";
        end;
        if CustCode = '' then begin
            GenLine.reset();
            GenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
            GenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
            GenLine.SetRange("Document No.", GenJournalLine."Document No.");
            GenLine.Setfilter("YVS Tax Vendor No.", '<>%1', '');
            if GenLine.FindFirst() then
                CustCode := GenLine."YVS Tax Vendor No.";
        end;
    end;

    /// <summary> 
    /// Description for FindPostingDescription.
    /// </summary>
    procedure FindPostingDescription()
    var
        GenLine: Record "Posted Gen. Journal Line";
    begin
        GenLine.reset();
        GenLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLine.SetRange("Document No.", GenJournalLine."Document No.");
        GenLine.SetFilter("YVS Journal Description", '<>%1', '');
        if GenLine.FindFirst() then
            PostingDescription := GenLine."YVS Journal Description";
    end;




    /// <summary> 
    /// Description for CheckLineData.
    /// </summary>
    procedure CheckLineData()
    var
        GenLineCheck: Record "Posted Gen. Journal Line";
    begin
        GenLineCheck.reset();
        GenLineCheck.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLineCheck.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLineCheck.SetRange("Document No.", GenJournalLine."Document No.");
        GenLineCheck.SetRange("YVS Require Screen Detail", GenLineCheck."YVS Require Screen Detail"::VAT);
        HaveItemVAT := GenLineCheck.Count <> 0;
        GenLineCheck.SetRange("YVS Require Screen Detail", GenLineCheck."YVS Require Screen Detail"::WHT);
        HaveWHT := GenLineCheck.Count <> 0;
        GenLineCheck.SetRange("YVS Require Screen Detail", GenLineCheck."YVS Require Screen Detail"::CHEQUE);
        haveCheque := GenLineCheck.Count <> 0;
        GenLineCheck.reset();
        GenLineCheck.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLineCheck.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenLineCheck.SetRange("Document No.", GenJournalLine."Document No.");
        GenLineCheck.SetRange("Account Type", GenLineCheck."Account Type"::"Bank Account");
        HaveBankAccount := GenLineCheck.Count <> 0;


    end;

    var

        FunctionCenter: Codeunit "YVS Function Center";
        companyInfor: Record "Company Information";
        ExchangeRate: Text[30];
        ComText: array[10] Of Text[250];
        CustText: array[10] Of Text[250];
        BranchCode: Text[50];
        SplitDate: Array[3] of Text[20];
        AmtText: Text[1024];
        TempAmt: Decimal;
        CustCode: Code[20];
        CurrencyCode: Code[10];
        CurrencyFactor: Decimal;
        PostingDescription: Text[250];
        CVBufferEntry: Record "CV Ledger Entry Buffer";
        OK: Boolean;
        BankName: Text[250];
        BankBranchNo: Code[30];
        VendorBankAccountName: Text[250];
        JournalDescriptionThai: Text[250];
        JournalDescriptionEng: Text[250];
        GenJournalBatchName: Record "Gen. Journal Batch";
        HaveWHT: Boolean;
        HaveItemVAT: Boolean;
        HaveBankAccount: Boolean;
        HaveApply: Boolean;
        haveCheque: Boolean;

        groupping: Boolean;
        AccountName: text[100];
        glAccount: Record "G/L Account";
        UserName: Code[50];
        gvGenLine: Record "Posted Gen. Journal Line";

}
