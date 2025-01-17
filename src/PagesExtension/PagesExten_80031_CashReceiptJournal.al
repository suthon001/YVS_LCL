/// <summary>
/// PageExtension Receipt Journal (ID 80031) extends Record Cash Receipt Journal.
/// </summary>
pageextension 80031 "YVS Receipt Journal" extends "Cash Receipt Journal"
{
    PromotedActionCategories = 'New,Process,Print,Approve,Page,Post/Print,Line,Account';
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
                ToolTip = 'Specifies the value of the Require Screen Detail field.';
                Visible = CheckDisableLCL;
            }

        }
        addafter(Description)
        {
            field("YVS Journal Description"; Rec."YVS Journal Description")
            {
                ApplicationArea = all;
                Caption = 'Journal Description';
                ToolTip = 'Specifies the value of the Journal Description field.';
                Visible = CheckDisableLCL;
            }

            field("YVS Pay Name"; Rec."YVS Pay Name")
            {
                ApplicationArea = all;
                Caption = 'Pay Name';
                ToolTip = 'Specifies the value of the Pay Name field.';
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
        // modify("VAT Bus. Posting Group")
        // {
        //     Visible = true;
        // }
        // modify("VAT Prod. Posting Group")
        // {
        //     Visible = true;
        // }
        // modify("Document Date")
        // {
        //     Visible = true;
        // }
        //  movebefore(Amount; "Currency Code")
        //  moveafter(Description; Amount)

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
                PromotedCategory = Category6;
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


        addlast(Reporting)
        {
            action("Receipt Voucher")
            {
                Caption = 'Receipt Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                Visible = CheckDisableLCL;
                ToolTip = 'Executes the Receipt Voucher action.';
                trigger OnAction()
                var
                    GenJournalLIne: Record "Gen. Journal Line";
                begin
                    GenJournalLIne.reset();
                    GenJournalLIne.SetRange("Journal Template Name", rec."Journal Template Name");
                    GenJournalLIne.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    GenJournalLIne.SetRange("Document No.", rec."Document No.");
                    REPORT.RunModal(REPORT::"YVS Receive Voucher", true, false, GenJournalLIne);
                end;
            }
            action("Print_Receipt_Tax")
            {
                ApplicationArea = All;
                Caption = 'Receipt Invoice (Apply)';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Visible = CheckDisableLCL;
                ToolTip = 'Executes the Receipt Invoice (Apply) action.';
                trigger OnAction()
                var
                    RecCustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    RecCustLedgEntry.RESET();
                    RecCustLedgEntry.SETFILTER("Applies-to ID", rec."Document No.");
                    REPORT.RUN(REPORT::"YVS Receipt Tax Invoice", TRUE, TRUE, RecCustLedgEntry);
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
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = CheckDisableLCL;
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
                    if Rec."YVS Require Screen Detail" IN [Rec."YVS Require Screen Detail"::VAT, Rec."YVS Require Screen Detail"::CHEQUE, Rec."YVS Require Screen Detail"::WHT] then begin
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
                                                if rec."YVS Ref. Billing & Receipt No." <> '' then begin
                                                    rec."YVS WHT Document No." := rec."YVS Ref. Receipt WHT No.";
                                                    rec."YVS WHT Date" := rec."YVS Ref. Receipt WHT Date";
                                                    rec."YVS WHT Amount" := abs(rec.Amount);
                                                end;
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

    }


    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
        if gvDocument <> '' then
            rec.SetRange("Document No.", gvDocument);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        PurchaseBilling: Record "YVS Billing Receipt Header";
    begin
        if CheckDisableLCL then
            if rec."YVS Ref. Billing & Receipt No." <> '' then
                if PurchaseBilling.GET(PurchaseBilling."Document Type"::"Sales Receipt", rec."YVS Ref. Billing & Receipt No.") then begin
                    PurchaseBilling."Status" := PurchaseBilling."Status"::Released;
                    PurchaseBilling."Create to Journal" := false;
                    PurchaseBilling.Modify();
                end;
    end;
    /// <summary>
    /// SetDocumnet.
    /// </summary>
    /// <param name="pDocument">code[20].</param>
    procedure SetDocumnet(pDocument: code[20])
    begin
        gvDocument := pDocument;
    end;



    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";
        gvDocument: Code[20];
}