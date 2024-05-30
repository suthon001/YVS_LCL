/// <summary>
/// PageExtension ExtenPostPostedGenLine (ID 80002) extends Record Posted General Journal.
/// </summary>
pageextension 80002 "YVS ExtenPostPostedGenLine" extends "Posted General Journal"
{
    PromotedActionCategories = 'New,Process,Print,Navigate,Show Detail';
    layout
    {
        addafter(Description)
        {
            field("External Document No."; rec."External Document No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the External Document No. field.';
            }
            field("Require Screen Detail"; Rec."YVS Require Screen Detail")
            {
                ApplicationArea = all;
                Caption = 'Require Screen Detail';
                ToolTip = 'Specifies the value of the Require Screen Detail field.';
                Visible = CheckDisableLCL;
            }
        }
    }
    actions
    {

        addlast(Reporting)
        {
            action("Posted Voucher")
            {
                Caption = 'Posted Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                Visible = CheckDisableLCL;
                ToolTip = 'Executes the Posted Voucher action.';
                trigger OnAction()
                var
                    PostedGenLine: Record "Posted Gen. Journal Line";
                    GenjournalTemp: Record "Gen. Journal Template";
                begin
                    GenjournalTemp.GET(rec."Journal Template Name");
                    PostedGenLine.reset();
                    PostedGenLine.SetRange("Journal Template Name", rec."Journal Template Name");
                    PostedGenLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    PostedGenLine.SetRange("Document No.", rec."Document No.");
                    if GenjournalTemp.Type = GenjournalTemp.Type::Payments then
                        REPORT.RunModal(REPORT::"YVS Payment Voucher (Post)", true, false, PostedGenLine);
                    if GenjournalTemp.Type = GenjournalTemp.Type::General then
                        REPORT.RunModal(REPORT::"YVS Journal Voucher (Post)", true, false, PostedGenLine);
                    if GenjournalTemp.Type = GenjournalTemp.Type::"Cash Receipts" then
                        REPORT.RunModal(REPORT::"YVS Receive Voucher (Post)", true, false, PostedGenLine);
                    if GenjournalTemp.Type = GenjournalTemp.Type::Assets then
                        REPORT.RunModal(REPORT::"YVS FA G/L Journal Voucher (P)", true, false, PostedGenLine);

                end;
            }
        }
        addafter(CopySelected)
        {
            action("Show Detail")
            {
                Caption = 'Show Details';
                Image = LineDescription;
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                Visible = CheckDisableLCL;
                ToolTip = 'Executes the Show Details action.';
                trigger OnAction()
                var
                    ShowDetailCheque: Page "YVS Posted ShowDetail Cheque";
                    ShowDetailVAT: Page "YVS Posted ShowDetail Vat";
                    ShowDetailWHT: Page "YVS PostedShowDetailWHT";
                    GenLineDetail: Record "Posted Gen. Journal Line";
                    WHTCertificates: Page "YVS WHT Certificate";
                    WHTCertificate: Record "YVS WHT Header";

                begin
                    Rec.TestField("YVS Require Screen Detail");
                    Rec.TestField("Document No.");
                    CLEAR(ShowDetailVAT);
                    CLEAR(ShowDetailCheque);
                    CLEAR(WHTCertificates);
                    if Rec."YVS Require Screen Detail" IN [Rec."YVS Require Screen Detail"::VAT, Rec."YVS Require Screen Detail"::CHEQUE] then begin
                        GenLineDetail.reset();
                        GenLineDetail.SetRange("Journal Template Name", Rec."Journal Template Name");
                        GenLineDetail.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        GenLineDetail.SetRange("Line No.", Rec."Line No.");
                        if Rec."YVS Require Screen Detail" = Rec."YVS Require Screen Detail"::CHEQUE then begin
                            ShowDetailCheque.SetTableView(GenLineDetail);
                            ShowDetailCheque.RunModal();
                            CLEAR(ShowDetailCheque);
                        end else
                            if Rec."YVS Require Screen Detail" = Rec."YVS Require Screen Detail"::VAT then begin
                                ShowDetailVAT.SetTableView(GenLineDetail);
                                ShowDetailVAT.RunModal();
                                CLEAR(ShowDetailVAT);
                            end;
                    end else
                        if Rec."YVS Require Screen Detail" = Rec."YVS Require Screen Detail"::WHT then begin
                            if rec."YVS Template Source Type" = rec."YVS Template Source Type"::"Cash Receipts" then begin
                                ShowDetailWHT.SetTableView(GenLineDetail);
                                ShowDetailWHT.RunModal();
                                Clear(ShowDetailWHT);
                            end else begin
                                WHTCertificate.reset();
                                WHTCertificate.SetRange("WHT No.", Rec."YVS WHT Document No.");
                                WHTCertificate.SetRange("Posted", true);
                                WHTCertificates.SetTableView(WHTCertificate);
                                WHTCertificates.Editable := false;
                                WHTCertificates.RunModal();
                                CLEAR(WHTCertificates);
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
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";
}