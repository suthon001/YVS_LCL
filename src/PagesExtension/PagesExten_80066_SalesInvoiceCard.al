/// <summary>
/// PageExtension Sales Invoice Card (ID 80066) extends Record Sales Invoice.
/// </summary>
pageextension 80066 "YVS Sales Invoice Card" extends "Sales Invoice"
{
    layout
    {
        addbefore(Status)
        {
            field("Head Office"; Rec."YVS Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("VAT Branch Code"; Rec."YVS VAT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("YVS Ref. Tax Invoice No."; rec."YVS Ref. Tax Invoice No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Ref. Tax Invoice No. field.';
            }
            field("YVS Ref. Tax Invoice Date"; rec."YVS Ref. Tax Invoice Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Ref. Tax Invoice Amount field.';
            }
            field("YVS Ref. Tax Invoice Amount"; rec."YVS Ref. Tax Invoice Amount")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Ref. Tax Invoice Amount field.';
            }

        }
        modify("Posting Description")
        {
            Visible = true;
        }
        modify("VAT Registration No.")
        {
            Visible = true;
        }
        moveafter("VAT Branch Code"; "VAT Registration No.", "Posting Description")
        modify("No.")
        {
            Visible = true;
            Importance = Promoted;

        }
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Sell-to Customer No.")
        {
            Importance = Standard;
        }
        modify(Control60)
        {
            Visible = true;
        }
        modify(Control85)
        {
            Visible = true;
        }



    }
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
                    ARVoucher: Report "YVS AR Voucher";
                    SalesHeader: Record "Sales Header";
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
                    RecSalesHeader: Record "Sales Header";
                begin
                    RecSalesHeader.RESET();
                    RecSalesHeader.SetRange("Document Type", rec."Document Type");
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"YVS Report Sales Invoice", TRUE, TRUE, RecSalesHeader);
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
                    RecSalesHeader: Record "Sales Header";
                begin
                    RecSalesHeader.RESET();
                    RecSalesHeader.SetRange("Document Type", rec."Document Type");
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"YVS Debit Note", TRUE, TRUE, RecSalesHeader);
                end;
            }
        }
    }
}