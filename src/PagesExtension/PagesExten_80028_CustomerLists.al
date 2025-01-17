/// <summary>
/// PageExtension YVS ExtenCustomerLists (ID 80028) extends Record Customer List.
/// </summary>
pageextension 80028 "YVS ExtenCustomerLists" extends "Customer List"
{

    layout
    {
        // moveafter("Payments (LCY)"; "Credit Limit (LCY)")
        addafter("Credit Limit (LCY)")
        {
            field(AvalibleCreditAmt; AvalibleCreditAmt)
            {
                Caption = 'Available Credit (LCY)';
                Editable = false;
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Available Credit (LCY) field.';
                Visible = CheckDisableLCL;
            }
        }


        addafter("Name 2")
        {

            field("YVS Address"; Rec.Address)
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the street and number.';
                Visible = CheckDisableLCL;

            }
            field("YVS Address 2"; Rec."Address 2")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies additional address information.';
                Visible = CheckDisableLCL;
            }


        }

        addafter("Phone No.")
        {
            field("YVS Fax No."; Rec."Fax No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the customer''s fax number.';
                Visible = CheckDisableLCL;
            }
        }
        addafter("Payment Terms Code")
        {
            field("YVS Shipment Method Code"; Rec."Shipment Method Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies which shipment method to use when you ship items to the customer.';
                Visible = CheckDisableLCL;
            }
        }
        addlast(Control1)
        {
            field("YVS VAT Registration No."; rec."VAT Registration No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the customer''s VAT registration number for customers in EU countries/regions.';
                Visible = CheckDisableLCL;
            }
            field("YVS VAT Branch Code"; rec."YVS VAT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the VAT Branch Code field.';
                Visible = CheckDisableLCL;
            }
            field("YVS Head Office"; rec."YVS Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Head Office field.';
                Visible = CheckDisableLCL;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if CheckDisableLCL then begin
            AvalibleCreditAmt := 0;
            IF Rec."Credit Limit (LCY)" <> 0 then
                AvalibleCreditAmt := Rec."Credit Limit (LCY)" - Rec.GetTotalAmountLCY();
        end;
    end;

    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";

        AvalibleCreditAmt: Decimal;
}