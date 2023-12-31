/// <summary>
/// PageExtension YVS Sales Quotes Lists (ID 80016) extends Record Sales Quotes.
/// </summary>
pageextension 80016 "YVS Sales Quotes Lists" extends "Sales Quotes"
{
    layout
    {

        modify("Bill-to Customer No.")
        {
            Visible = true;
        }
        modify("Requested Delivery Date")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify(Status)
        {
            Visible = true;
        }
        modify("Sell-to Contact")
        {
            Visible = false;
        }

        moveafter("No."; Status, "Sell-to Customer No.", "Bill-to Customer No.", "Sell-to Customer Name", "External Document No.", "Posting Date", "Document Date", "Due Date",
        "Quote Valid Until Date", Amount)
        modify("Your Reference")
        {
            Visible = true;
        }
        moveafter("Quote Valid Until Date"; "Your Reference")

        addafter(Amount)
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
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
            field("Sales Order No."; rec."YVS Sales Order No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
        }
        addafter(Status)
        {
            field("Completely Shipped"; rec."Completely Shipped")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Caption = 'Completely';
            }
        }

    }
}