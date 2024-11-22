/// <summary>
/// PageExtension YVS Sales Order Lists (ID 80062) extends Record Sales Order List.
/// </summary>
pageextension 80062 "YVS Sales Order Lists" extends "Sales Order List"
{

    layout
    {

        //  moveafter("No."; Status, "Posting Date", "Sell-to Customer No.", "Bill-to Customer No.",
        //   "Sell-to Customer Name", "External Document No.", "Document Date", "Due Date", "Quote No.", "Your Reference", Amount, "Amount Including VAT")


        addafter("Amount Including VAT")
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
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
        }

    }
    actions
    {
        addlast(Reporting)
        {

            action("Print_Sales_Order")
            {
                ApplicationArea = All;
                Caption = 'Sales Order';
                Image = PrintReport;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Sales Order action.';
                Visible = CheckDisableLCL;
                trigger OnAction()
                var
                    RecSalesHeader: Record "Sales Header";
                begin
                    RecSalesHeader.RESET();
                    RecSalesHeader.SetRange("Document Type", rec."Document Type");
                    RecSalesHeader.SetRange("No.", rec."No.");
                    Report.Run(Report::"YVS Report Sales Order", TRUE, TRUE, RecSalesHeader);
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