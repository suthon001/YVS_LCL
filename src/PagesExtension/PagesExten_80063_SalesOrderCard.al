/// <summary>
/// PageExtension YVS Sales Order Card (ID 80063) extends Record Sales Order.
/// </summary>
pageextension 80063 "YVS Sales Order Card" extends "Sales Order"
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
            field("Shipping No. Series"; Rec."Shipping No. Series")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }

        }
        modify("VAT Registration No.")
        {
            Visible = CheckDisableLCL;
            Editable = true;
        }
        //  moveafter("VAT Branch Code"; "VAT Registration No.")
        modify("No.")
        {
            Visible = CheckDisableLCL;
        }
        modify("Sell-to Customer No.")
        {
            Visible = CheckDisableLCL;
            ApplicationArea = all;
            Importance = Promoted;

        }


        modify("Salesperson Code")
        {
            Visible = CheckDisableLCL;
            Importance = Standard;
        }
        modify(Status)
        {
            Importance = Promoted;
        }
        modify("Work Description")
        {
            Visible = not CheckDisableLCL;
        }
        modify("Shipment Date")
        {
            Importance = Standard;
        }


        //  moveafter("Due Date"; "Shipment Date")
        //   moveafter("External Document No."; "Salesperson Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        modify(Control123)
        {
            Visible = CheckDisableLCL;
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