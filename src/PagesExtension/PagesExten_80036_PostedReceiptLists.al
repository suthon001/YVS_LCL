/// <summary>
/// PageExtension PostedReceiptList (ID 80036) extends Record Posted Purchase Receipts.
/// </summary>
pageextension 80036 "YVS PostedReceiptList" extends "Posted Purchase Receipts"
{

    layout
    {
        modify("Pay-to Name")
        {
            Visible = not CheckDisableLCL;
        }
        modify("Pay-to Vendor No.")
        {
            Visible = not CheckDisableLCL;
        }
        modify("No. Printed")
        {
            Visible = not CheckDisableLCL;
        }
        modify("Location Code")
        {
            Visible = not CheckDisableLCL;
        }
        moveafter("no."; "Posting Date", "Document Date", "Buy-from Vendor No.", "Pay-to Vendor No.", "Buy-from Vendor Name", "Pay-to Name")
        addafter("Document Date")
        {
            field("Expected Receipt Date"; Rec."Expected Receipt Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date.';
                Visible = CheckDisableLCL;
            }
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the line number of the order that created the entry.';
                Visible = CheckDisableLCL;
            }
            field("Vendor Order No."; Rec."Vendor Order No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the vendor''s order number.';
                Visible = CheckDisableLCL;
            }
            field("Vendor Shipment No."; Rec."Vendor Shipment No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the vendor''s shipment number. It is inserted in the corresponding field on the source document during posting.';
                Visible = CheckDisableLCL;
            }
            field("YVS Vendor Invoice No."; rec."YVS Vendor Invoice No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Vendor Invoice No. field.';
                Visible = CheckDisableLCL;
            }
        }
        addafter("Pay-to Name")
        {
            field("Currency Code"; Rec."Currency Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Currency Code field.';
                Visible = CheckDisableLCL;
            }
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Your Reference field.';
                Visible = CheckDisableLCL;
            }
            field("Head Office"; Rec."YVS Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Head Office field.';
                Visible = CheckDisableLCL;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
                Visible = CheckDisableLCL;
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