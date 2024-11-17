/// <summary>
/// PageExtension YVS Sales Quote Card (ID 80017) extends Record Sales Quote.
/// </summary>
pageextension 80017 "YVS Sales Quote Card" extends "Sales Quote"
{
    layout
    {
        addbefore(Status)
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
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the customer''s VAT registration number for customers.';
                Visible = CheckDisableLCL;
            }
            field("Sales Order No."; Rec."YVS Sales Order No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
            field("Make Order No. Series"; Rec."YVS Make Order No. Series")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Make Order No. Series field.';
                Visible = CheckDisableLCL;
                trigger OnAssistEdit()
                var
                    SalesSetup: Record "Sales & Receivables Setup";
                    Noseriesmgt: Codeunit "No. Series";
                begin
                    SalesSetup.get();
                    SalesSetup.TestField("Order Nos.");
                    Noseriesmgt.LookupRelatedNoSeries(SalesSetup."Order Nos.", Rec."No. Series", Rec."YVS Make Order No. Series");
                end;
            }
        }
        modify("No.")
        {
            Visible = CheckDisableLCL;
        }
        modify("Sell-to Customer No.")
        {
            Importance = Standard;
        }

        modify(Status)
        {
            Importance = Promoted;
        }
        modify("Document Date")
        {
            Importance = Standard;
        }
        modify("Requested Delivery Date")
        {
            Visible = not CheckDisableLCL;
        }

        //moveafter("External Document No."; "Salesperson Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        //moveafter("Make Order No. Series"; "VAT Bus. Posting Group")
        addbefore("VAT Bus. Posting Group")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
                Visible = CheckDisableLCL;
            }
        }
        addbefore("Document Date")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the date when the sales document was posted.';
                Visible = CheckDisableLCL;
            }
        }
        addafter("Sell-to City")
        {
            field("Sell-to Phone No."; Rec."Sell-to Phone No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the telephone number of the contact person that the sales document will be sent to.';
                Visible = CheckDisableLCL;
            }
        }
        addafter(Status)
        {
            field("Completely Shipped"; rec."Completely Shipped")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Caption = 'Completely';
                Visible = CheckDisableLCL;
            }
        }
        modify(Control105)
        {
            Visible = not CheckDisableLCL;
        }

    }
    actions
    {
        modify(Print)
        {
            Visible = false;
        }
        addlast(Reporting)
        {

            action("Print_Sales_Quotes")
            {
                ApplicationArea = All;
                Caption = 'Sales Quote';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Sales Quote action.';
                Visible = CheckDisableLCL;
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Header";
                begin
                    RecSalesHeader.RESET();
                    RecSalesHeader.SetRange("Document Type", rec."Document Type");
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"YVS Report Sales Quotes", TRUE, TRUE, RecSalesHeader);
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