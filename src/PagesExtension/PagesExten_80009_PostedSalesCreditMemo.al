/// <summary>
/// PageExtension YVS Posted Sales Credit Memo (ID 80009) extends Record Posted Sales Credit Memo.
/// </summary>
pageextension 80009 "YVS Posted Sales Credit Memo" extends "Posted Sales Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field("Head Office"; Rec."YVS Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
            field("VAT Branch Code"; Rec."YVS VAT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
        }
        modify("VAT Registration No.")
        {
            Visible = NOT CheckDisableLCL;
        }
        moveafter("VAT Branch Code"; "VAT Registration No.")
        modify("No.")
        {
            Visible = NOT CheckDisableLCL;
        }
        addafter("Applies-to Doc. No.")
        {
            field("YVS Applies-to ID"; rec."YVS Applies-to ID")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Applies-to ID. field.';
                Visible = CheckDisableLCL;
            }
            field("YVS Ref. Tax Invoice Date"; rec."YVS Ref. Tax Invoice Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Ref. Tax Invoice Amount field.';
                Visible = CheckDisableLCL;
            }
            field("YVS Ref. Tax Invoice Amount"; rec."YVS Ref. Tax Invoice Amount")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Ref. Tax Invoice Amount field.';
                Visible = CheckDisableLCL;
            }
        }
        moveafter("External Document No."; "Salesperson Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")

    }
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
                Visible = CheckDisableLCL;
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
                Visible = CheckDisableLCL;
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
    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";

}
