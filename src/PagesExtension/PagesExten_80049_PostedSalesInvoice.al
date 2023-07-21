pageextension 80049 "YVS Posted Sales Invoice" extends "Posted Sales Invoice"
{
    actions
    {
        addlast(Reporting)
        {
            action("AR Voucher")
            {
                Caption = 'AR Voucher';
                Image = PrintVoucher;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the AR Voucher action.';
                trigger OnAction()
                var
                    ARVoucher: Report "YVS AR Voucher (Post)";
                    SalesHeader: Record "Sales Invoice Header";
                begin
                    SalesHeader.reset();
                    SalesHeader.Copy(Rec);
                    ARVoucher."SetGLEntry"(SalesHeader);
                    ARVoucher.RunModal();
                end;
            }
            action("Print_Sales_Invoice")
            {
                ApplicationArea = All;
                Caption = 'Sales Invoice';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Sales Invoice action.';
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Invoice Header";
                begin
                    RecSalesHeader.RESET();
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"YVS Sales Invoice (Post)", TRUE, TRUE, RecSalesHeader);
                end;
            }
            action("Print_DebitNote")
            {
                ApplicationArea = All;
                Caption = 'Debit Note';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Debit Note action.';
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Invoice Header";
                begin
                    RecSalesHeader.RESET();
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"YVS Debit Note (Post)", TRUE, TRUE, RecSalesHeader);
                end;
            }
        }
    }
}
