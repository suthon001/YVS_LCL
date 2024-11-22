/// <summary>
/// PageExtension YVS Purchase Order Card (ID 80069) extends Record Purchase Order.
/// </summary>
pageextension 80069 "YVS Purchase Order Card" extends "Purchase Order"
{

    layout
    {

        addbefore(Status)
        {
            field("Head Office"; Rec."YVS Head Office")
            {
                ApplicationArea = all;
                Caption = 'Head Office';
                ToolTip = 'Specifies the value of the Head Office field.';
                Editable = Rec.Status = Rec.Status::Open;
                Visible = CheckDisableLCL;
            }
            field("VAT Branch Code"; Rec."YVS VAT Branch Code")
            {
                ApplicationArea = all;
                Caption = 'VAT Branch Code';
                ToolTip = 'Specifies the value of the VAT Branch Code field.';
                Editable = Rec.Status = Rec.Status::Open;
                Visible = CheckDisableLCL;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
                Caption = 'VAT Registration No.';
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
                Editable = Rec.Status = Rec.Status::Open;
                Visible = CheckDisableLCL;
            }
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
                    ToolTip = 'Specifies the value of the Receiving No. Series field.';
                }
                field("Receiving No."; rec."Receiving No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Receiving No. field.';
                }
            }
        }
        //  moveafter("Posting DateVYS"; "Vendor Invoice No.", "Vendor Shipment No.", "Document Date")

        addbefore("Pay-to Name")
        {
            field("Pay-to Vendor No."; rec."Pay-to Vendor No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the number of the vendor that you received the invoice from.';
            }
        }



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
                Visible = CheckDisableLCL;
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
        if CheckDisableLCL then begin
            CheckbeforDelete := true;
            "OnBeforDeletePurchaseHeader"(CheckbeforDelete);
            if CheckbeforDelete then begin
                PurchaseReceipt.reset();
                PurchaseReceipt.SetRange("Order No.", Rec."No.");
                if not PurchaseReceipt.IsEmpty() then
                    ERROR('Cannot Delete this document has been Posted');
            end;
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

    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";

}