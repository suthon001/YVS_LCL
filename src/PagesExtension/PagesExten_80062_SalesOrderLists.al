/// <summary>
/// PageExtension YVS Sales Order Lists (ID 80062) extends Record Sales Order List.
/// </summary>
pageextension 80062 "YVS Sales Order Lists" extends "Sales Order List"
{

    layout
    {
        modify("Bill-to Customer No.")
        {
            Visible = true;
        }
        modify("Salesperson Code")
        {
            Visible = false;
        }
        modify("Ship-to Name")
        {
            Visible = false;
        }
        modify("Sell-to Customer Name")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Completely Shipped")
        {
            Visible = false;
        }
        modify("Quote No.")
        {
            Visible = true;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Amt. Ship. Not Inv. (LCY)")
        {
            Visible = false;
        }
        modify("Amt. Ship. Not Inv. (LCY) Base")
        {
            Visible = false;
        }
        modify("Your Reference")
        {
            Visible = true;
        }
        moveafter("No."; Status, "Posting Date", "Sell-to Customer No.", "Bill-to Customer No.",
        "Sell-to Customer Name", "External Document No.", "Document Date", "Due Date", "Quote No.", "Your Reference", Amount, "Amount Including VAT")


        addafter("Amount Including VAT")
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
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
        }

    }
}