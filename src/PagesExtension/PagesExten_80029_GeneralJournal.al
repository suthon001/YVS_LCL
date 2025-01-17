/// <summary>
/// PageExtension General Journal (ID 80029) extends Record General Journal.
/// </summary>
pageextension 80029 "YVS General Journal" extends "General Journal"
{
    layout
    {
        modify("Document No.")
        {
            Visible = NOT CheckDisableLCL;
        }
        addafter("Document No.")
        {
            field("YVS Document No."; rec."Document No.")
            {
                ApplicationArea = all;
                Visible = CheckDisableLCL;
                ToolTip = 'Specifies the value of the Document No. field.';
                trigger OnAssistEdit()
                begin
                    if Rec."AssistEdit"(xRec) then
                        CurrPage.Update();
                end;
            }
        }
        addafter("VAT Amount")
        {
            field("YVS Require Screen Detail"; Rec."YVS Require Screen Detail")
            {
                ApplicationArea = all;
                Caption = 'Require Screen Detail';
                ToolTip = 'Specifies the value of the Require Screen Detail field.';
                Visible = CheckDisableLCL;
            }

        }
        // modify("Gen. Bus. Posting Group")
        // {
        //     Visible = true;
        // }
        // modify("Gen. Prod. Posting Group")
        // {
        //     Visible = true;
        // }
        // modify("Gen. Posting Type")
        // {
        //     Visible = true;
        // }
        // modify("Document Date")
        // {
        //     Visible = true;
        // }
        addafter(Description)
        {
            field("YVS Journal Description"; Rec."YVS Journal Description")
            {
                ApplicationArea = All;
                Caption = 'Journal Description';
                ToolTip = 'Specifies the value of the Journal Description field.';
                Visible = CheckDisableLCL;
            }
        }

        //  moveafter("Posting Date"; "Document Date")
    }
    actions
    {
        addafter(Preview)
        {
            action(YVSPreview)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Preview Posting';
                Image = ViewPostedOrder;
                ShortCutKey = 'Ctrl+Alt+F9';
                ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';
                PromotedCategory = Category9;
                Promoted = true;
                PromotedIsBig = true;
                Visible = CheckDisableLCL;
                trigger OnAction()
                var
                    GenJnlPost: Codeunit "Gen. Jnl.-Post";
                    ltGenLine: Record "Gen. Journal Line";
                begin
                    ltGenLine.reset();
                    ltGenLine.SetRange("Journal Template Name", rec."Journal Template Name");
                    ltGenLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    ltGenLine.SetRange("Document No.", rec."Document No.");
                    if ltGenLine.FindFirst() then
                        GenJnlPost.Preview(ltGenLine);
                end;
            }
        }
        modify(Preview)
        {
            Visible = not CheckDisableLCL;
        }

        addfirst(processing)
        {
            action("WHT Certificate")
            {
                ApplicationArea = all;
                Image = InsertFromCheckJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = CheckDisableLCL;
                Caption = 'WHT Certificate';
                ToolTip = 'Executes the WHT Certificate action.';
                trigger OnAction()
                begin
                    // TestField("Require Screen Detail", "Require Screen Detail"::WHT);
                    "InsertWHTCertificate"();
                end;
            }
        }

        addbefore(Reconcile)
        {
            action("Show Detail")
            {
                Caption = 'Show Detail VAT & Cheque & WHT';
                Image = LineDescription;
                ApplicationArea = all;
                Promoted = true;
                Visible = CheckDisableLCL;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Show Detail VAT & Cheque & WHT action.';
                trigger OnAction()
                var
                    ShowDetailCheque: Page "YVS ShowDetail Cheque";
                    ShowDetailVAT: Page "YVS ShowDetail Vat";
                    GenLineDetail: Record "Gen. Journal Line";
                    GenLine2: Record "Gen. Journal Line";
                    ShowDetailWHT: Page "YVS ShowDetailWHT";
                    Cust: Record Customer;
                begin
                    Rec.TestField("YVS Require Screen Detail");
                    Rec.TestField("Document No.");
                    CLEAR(ShowDetailVAT);
                    CLEAR(ShowDetailCheque);
                    if Rec."YVS Require Screen Detail" IN [Rec."YVS Require Screen Detail"::VAT, Rec."YVS Require Screen Detail"::WHT] then begin
                        GenLineDetail.reset();
                        GenLineDetail.SetRange("Journal Template Name", Rec."Journal Template Name");
                        GenLineDetail.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        GenLineDetail.SetRange("Line No.", Rec."Line No.");
                        case rec."YVS Require Screen Detail" OF
                            rec."YVS Require Screen Detail"::CHEQUE:
                                begin
                                    ShowDetailCheque.SetTableView(GenLineDetail);
                                    ShowDetailCheque.RunModal();
                                    CLEAR(ShowDetailCheque);
                                end;

                            rec."YVS Require Screen Detail"::VAT:
                                begin
                                    ShowDetailVAT.SetTableView(GenLineDetail);
                                    ShowDetailVAT.RunModal();
                                    CLEAR(ShowDetailVAT);
                                end;
                            rec."YVS Require Screen Detail"::WHT:
                                begin
                                    if Rec."YVS WHT Cust/Vend No." = '' then begin
                                        GenLine2.reset();
                                        GenLine2.SetRange("Journal Template Name", Rec."Journal Template Name");
                                        GenLine2.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                                        GenLine2.SetRange("Document No.", Rec."Document No.");
                                        GenLine2.SetRange("Account Type", GenLine2."Account Type"::Customer);
                                        if GenLine2.FindFirst() then
                                            if Cust.get(GenLine2."Account No.") then begin
                                                Rec."YVS WHT Cust/Vend No." := Cust."No.";
                                                Rec."YVS WHT Name" := Cust.Name;
                                                Rec."YVS WHT Name 2" := Cust."Name 2";
                                                Rec."YVS WHT Address" := Cust.Address;
                                                Rec."YVS WHT Address 2" := Cust."Address 2";
                                                Rec."YVS WHT Registration No." := Cust."VAT Registration No.";
                                                Rec."YVS WHT Post Code" := Cust."Post Code";
                                                Rec."YVS WHT City" := Cust.City;
                                                Rec."YVS WHT County" := Cust.County;
                                                Rec.Modify();
                                                Commit();
                                            end;
                                    end;
                                    ShowDetailWHT.SetTableView(GenLineDetail);
                                    ShowDetailWHT.RunModal();
                                    Clear(ShowDetailWHT);
                                end;

                        end;
                    end else
                        MESSAGE('Nothing to Show Detail');
                end;
            }
        }
        addlast(Reporting)
        {
            action("Journal Voucher")
            {
                Caption = 'Journal Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                Visible = CheckDisableLCL;
                PromotedIsBig = true;
                ToolTip = 'Executes the Journal Voucher action.';
                trigger OnAction()
                var
                    GenJournalLIne: Record "Gen. Journal Line";
                begin
                    GenJournalLIne.reset();
                    GenJournalLIne.SetRange("Journal Template Name", rec."Journal Template Name");
                    GenJournalLIne.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    GenJournalLIne.SetRange("Document No.", rec."Document No.");
                    REPORT.RunModal(REPORT::"YVS Journal Voucher", true, false, GenJournalLIne);
                end;
            }
        }

    }
    /// <summary>
    /// InsertWHTCertificate.
    /// </summary>
    procedure "InsertWHTCertificate"()
    var
        GeneralSetup: Record "General Ledger Setup";
        WHTHeader: Record "YVS WHT Header";
        NosMgt: Codeunit "No. Series";
        GenJnlLine: Record "Gen. Journal Line";
        whtBusPostingGroup: Record "YVS WHT Business Posting Group";
        Vendor: Record Vendor;
        Customer: Record Customer;
        WHTDocNo: Code[30];
        PageWHTCer: Page "YVS WHT Certificate";
        GenJnlLine3: Record "Gen. Journal Line";
    begin
        if rec."YVS WHT Document No." = '' then begin
            GenJnlLine3.Reset();
            GenJnlLine3.SetRange("Journal Template Name", rec."Journal Template Name");
            GenJnlLine3.SetRange("Journal Batch Name", rec."Journal Batch Name");
            GenJnlLine3.SetRange("Document No.", rec."Document No.");
            GenJnlLine3.SetFilter("YVS WHT Document No.", '<>%1', '');
            if not GenJnlLine3.IsEmpty then
                if not Confirm('This document already have wht certificate do you want to create more wht certificate ?') then
                    exit;
        end;
        GeneralSetup.GET();
        GeneralSetup.TESTFIELD("YVS WHT Document Nos.");
        IF rec."YVS WHT Document No." = '' THEN BEGIN
            IF NOT CONFIRM('Do you want to create wht certificated') THEN
                EXIT;

            GenJnlLine.RESET();
            GenJnlLine.SETRANGE("Journal Template Name", rec."Journal Template Name");
            GenJnlLine.SETRANGE("Journal Batch Name", rec."Journal Batch Name");
            GenJnlLine.SETFILTER("Document No.", '%1', rec."Document No.");
            GenJnlLine.SETFILTER("Account Type", '%1|%2|%3', GenJnlLine."Account Type"::Vendor, GenJnlLine."Account Type"::Customer, GenJnlLine."Account Type"::"G/L Account");
            IF GenJnlLine.FindFirst() THEN BEGIN
                WHTHeader.INIT();
                WHTHeader."WHT No." := NosMgt.GetNextNo(GeneralSetup."YVS WHT Document Nos.", rec."Posting Date", TRUE);
                WHTDocNo := WHTHeader."WHT No.";
                WHTHeader."Gen. Journal Template Code" := rec."Journal Template Name";
                WHTHeader."Gen. Journal Batch Code" := rec."Journal Batch Name";
                WHTHeader."Gen. Journal Document No." := rec."Document No.";
                WHTHeader."WHT Date" := rec."Document Date";
                IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN BEGIN
                    IF Vendor.GET(GenJnlLine."Account No.") THEN BEGIN
                        if NOT whtBusPostingGroup.GET(Vendor."YVS WHT Business Posting Group") then
                            whtBusPostingGroup.init();
                        WHTHeader."WHT Business Posting Group" := Vendor."YVS WHT Business Posting Group";
                        WHTHeader."WHT Type" := whtBusPostingGroup."WHT Type";
                        WHTHeader."WHT Source Type" := WHTHeader."WHT Source Type"::Vendor;
                        WHTHeader.validate("WHT Source No.", Vendor."No.");
                    END;
                END ELSE
                    IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN
                        IF Customer.GET(GenJnlLine."Account No.") THEN BEGIN
                            if NOT whtBusPostingGroup.GET(Customer."YVS WHT Business Posting Group") then
                                whtBusPostingGroup.init();
                            WHTHeader."WHT Business Posting Group" := Customer."YVS WHT Business Posting Group";
                            WHTHeader."WHT Type" := whtBusPostingGroup."WHT Type";
                            WHTHeader."WHT Source Type" := WHTHeader."WHT Source Type"::Customer;
                            WHTHeader.validate("WHT Source No.", Customer."No.");
                        END;
            END;
            OnbeforInsertWhtHeader(WHTHeader, rec);
            WHTHeader.INSERT();
            rec.Modify();
        END ELSE
            WHTDocNo := rec."YVS WHT Document No.";

        commit();
        CLEAR(PageWHTCer);
        WHTHeader.reset();
        WHTHeader.SetRange("WHT No.", WHTDocNo);
        PageWHTCer.SetTableView(WHTHeader);
        PageWHTCer.RunformJournal(true);
        if PageWHTCer.RunModal() IN [Action::OK] then
            CurrPage.Update();
        CLEAR(PageWHTCer);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        WHTEader: Record "YVS WHT Header";
    begin
        if CheckDisableLCL then begin
            WHTEader.reset();
            WHTEader.SetRange("Gen. Journal Template Code", rec."Journal Template Name");
            WHTEader.SetRange("Gen. Journal Batch Code", rec."Journal Batch Name");
            WHTEader.SetRange("Gen. Journal Line No.", rec."Line No.");
            if WHTEader.FindFirst() then
                WHTEader.Delete(True);
        end;
    end;

    [IntegrationEvent(false, false)]
    /// <summary>
    /// OnbeforInsertWhtHeader.
    /// </summary>
    /// <param name="WHTHeader">VAR Record "YVS WHT Header".</param>
    /// <param name="GenLine">Record "Gen. Journal Line".</param>
    procedure OnbeforInsertWhtHeader(var WHTHeader: Record "YVS WHT Header"; GenLine: Record "Gen. Journal Line")
    begin

    end;

    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";
}