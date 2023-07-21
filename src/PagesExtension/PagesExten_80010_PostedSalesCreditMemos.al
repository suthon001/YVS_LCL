/// <summary>
/// PageExtension YVS Posted Sales Credit Memos (ID 80010) extends Record Posted Sales Credit Memos.
/// </summary>
pageextension 80010 "YVS Posted Sales Credit Memos" extends "Posted Sales Credit Memos"
{
    actions
    {
        addlast(Reporting)
        {
            action("AR CN Voucher")
            {
                Caption = 'AR CN Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the AR CN Voucher action.';
                trigger OnAction()
                var
                    ARCNVoucher: Report "YVS AR CN Voucher (Post)";
                    SalesHeader: Record "Sales Cr.Memo Header";
                begin
                    SalesHeader.reset();
                    SalesHeader.Copy(Rec);
                    ARCNVoucher."SetGLEntry"(SalesHeader);
                    ARCNVoucher.RunModal();
                end;
            }
            action("Print_Sales_CreditMemo")
            {
                ApplicationArea = All;
                Caption = 'Sales Credit Memo';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Sales Credit Memo action.';
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Cr.Memo Header";
                begin
                    RecSalesHeader.RESET();

                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"YVS Sales Credit Memo (Post)", TRUE, TRUE, RecSalesHeader);
                end;
            }
        }
    }
}