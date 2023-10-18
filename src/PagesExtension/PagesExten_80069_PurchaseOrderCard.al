/// <summary>
/// PageExtension YVS Purchase Order Card (ID 80069) extends Record Purchase Order.
/// </summary>
pageextension 80069 "YVS Purchase Order Card" extends "Purchase Order"
{

    layout
    {
        modify("Payment Discount %")
        {
            Visible = false;
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify("Pmt. Discount Date")
        {
            Visible = false;
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify("Promised Receipt Date")
        {
            Visible = false;
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify("VAT Reporting Date")
        {
            Visible = false;
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify("Responsibility Center")
        {
            Visible = false;
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify("Order Address Code")
        {
            Visible = false;
            Editable = Rec.Status = Rec.Status::Open;
        }
        addbefore(Status)
        {
            field("Head Office"; Rec."YVS Head Office")
            {
                ApplicationArea = all;
                Caption = 'Head Office';
                ToolTip = 'Specifies the value of the Head Office field.';
                Editable = Rec.Status = Rec.Status::Open;
            }
            field("VAT Branch Code"; Rec."YVS VAT Branch Code")
            {
                ApplicationArea = all;
                Caption = 'VAT Branch Code';
                ToolTip = 'Specifies the value of the VAT Branch Code field.';
                Editable = Rec.Status = Rec.Status::Open;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
                Editable = Rec.Status = Rec.Status::Open;
            }
        }
        modify("No.")
        {
            Visible = true;
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify("Buy-from Vendor No.")
        {
            Visible = true;
            Importance = Standard;
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify("Buy-from Vendor Name")
        {
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify("Currency Code")
        {
            Editable = Rec.Status = Rec.Status::Open;
        }

        addlast(General)
        {
            group(ForReciving)
            {
                Caption = 'For Receiving';
                field("Posting DateVYS"; rec."Posting Date")
                {
                    ApplicationArea = all;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the date when the posting of the purchase document will be recorded.';
                }
                field("Receiving No. Series"; rec."Receiving No. Series")
                {
                    ApplicationArea = all;
                    Caption = 'Receiving No.';
                    ToolTip = 'Specifies the value of the Receiving No. Series field.';
                }
                field("Receiving No."; rec."Receiving No.")
                {
                    ApplicationArea = all;
                    Caption = 'Receiving No.';
                    ToolTip = 'Specifies the value of the Receiving No. field.';
                }
            }
        }
        moveafter("Posting DateVYS"; "Vendor Invoice No.", "Vendor Shipment No.")
        modify("Invoice Details")
        {
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify("Shipping and Payment")
        {
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify("Foreign Trade")
        {
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify(Prepayment)
        {
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify("Expected Receipt Date")
        {
            Visible = true;
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify("Location Code")
        {
            Visible = true;
            Editable = Rec.Status = Rec.Status::Open;
        }
        addbefore("Pay-to Name")
        {
            field("Pay-to Vendor No."; rec."Pay-to Vendor No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the number of the vendor that you received the invoice from.';
            }
        }
        modify("Buy-from")
        {
            Editable = Rec.Status = Rec.Status::Open;
        }

        modify("Assigned User ID")
        {
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify("Order Date")
        {
            Editable = Rec.Status = Rec.Status::Open;
        }
        modify("Purchaser Code") { Editable = Rec.Status = Rec.Status::Open; }
        modify("Your Reference")
        {
            Editable = Rec.Status = Rec.Status::Open;
        }

        modify("Due Date") { Editable = Rec.Status = Rec.Status::Open; }
        modify("Document Date") { Editable = Rec.Status = Rec.Status::Open; }
        modify("Posting Date") { Editable = Rec.Status = Rec.Status::Open; }
        modify("Buy-from Contact") { Editable = Rec.Status = Rec.Status::Open; }
        modify("Buy-from Contact No.") { Editable = Rec.Status = Rec.Status::Open; }
        modify("Shortcut Dimension 1 Code") { Editable = Rec.Status = Rec.Status::Open; }
        modify("Shortcut Dimension 2 Code") { Editable = Rec.Status = Rec.Status::Open; }
        moveafter("Purchaser Code"; "Currency Code")
        moveafter("Currency Code"; "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        movebefore(Status; "Expected Receipt Date", "Location Code")
        moveafter("Posting Date"; "Document Date", "Due Date")

    }
    actions
    {

        addlast(Reporting)
        {
            action("Purchase Order")
            {
                Caption = 'Purchase Order';
                Image = PrintReport;
                ApplicationArea = all;
                PromotedCategory = Report;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Purchase Order action.';
                trigger OnAction()
                var

                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.reset();
                    PurchaseHeader.SetRange("Document Type", rec."Document Type");
                    PurchaseHeader.SetRange("No.", rec."No.");
                    REPORT.RunModal(REPORT::"YVS PurchaseOrder", true, true, PurchaseHeader);
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    var
        PurchaseReceipt: Record "Purch. Rcpt. Header";
        CheckbeforDelete: Boolean;
    begin
        CheckbeforDelete := true;
        "OnBeforDeletePurchaseHeader"(CheckbeforDelete);
        if CheckbeforDelete then begin
            PurchaseReceipt.reset();
            PurchaseReceipt.SetRange("Order No.", Rec."No.");
            if not PurchaseReceipt.IsEmpty() then
                ERROR('Cannot Delete this document has been Posted');
        end;
    end;

    [IntegrationEvent(false, false)]
    /// <summary> 
    /// Description for OnBeforDeletePurchaseHeader.
    /// </summary>
    /// <param name="CheckDelete">Parameter of type Boolean.</param>
    procedure "OnBeforDeletePurchaseHeader"(var CheckDelete: Boolean)
    begin
    end;


}