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
            }

        }
        modify("VAT Registration No.")
        {
            Visible = true;
            Editable = true;
        }
        moveafter("VAT Branch Code"; "VAT Registration No.")
        modify("No.")
        {
            Visible = true;
        }
        modify("Sell-to Customer No.")
        {
            Visible = true;
            ApplicationArea = all;
            Importance = Promoted;

        }


        modify("Salesperson Code")
        {
            Visible = true;
            Importance = Standard;
        }
        modify(Status)
        {
            Importance = Promoted;
        }
        modify("Work Description")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Importance = Standard;
        }


        moveafter("Due Date"; "Shipment Date")
        moveafter("External Document No."; "Salesperson Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        modify(Control123)
        {
            Visible = true;
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