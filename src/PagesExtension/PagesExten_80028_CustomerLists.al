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
        modify("Credit Limit (LCY)")
        {
            Visible = CheckDisableLCL;
        }
        modify("Payments (LCY)")
        {
            Visible = not CheckDisableLCL;
        }
        modify(Contact)
        {
            Visible = not CheckDisableLCL;
        }
        modify("Name 2")
        {
            Visible = CheckDisableLCL;
        }
        // moveafter("No."; Name, "Name 2", "Customer Posting Group", "Gen. Bus. Posting Group", "VAT Bus. Posting Group", "Phone No.", "Payment Terms Code", "Location Code", "Responsibility Center",
        // "Credit Limit (LCY)", "Balance (LCY)", "Balance Due (LCY)", "Sales (LCY)")

        addafter("Name 2")
        {

            field(Address; Rec.Address)
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the street and number.';
                Visible = CheckDisableLCL;

            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies additional address information.';
                Visible = CheckDisableLCL;
            }


        }

        addafter("Phone No.")
        {
            field("Fax No."; Rec."Fax No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the customer''s fax number.';
                Visible = CheckDisableLCL;
            }
        }
        addafter("Payment Terms Code")
        {
            field("Shipment Method Code"; Rec."Shipment Method Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies which shipment method to use when you ship items to the customer.';
                Visible = CheckDisableLCL;
            }
        }
        addlast(Control1)
        {
            field("VAT Registration No."; rec."VAT Registration No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the customer''s VAT registration number for customers in EU countries/regions.';
                Visible = CheckDisableLCL;
            }
            field("VAT Branch Code"; rec."YVS VAT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the VAT Branch Code field.';
                Visible = CheckDisableLCL;
            }
            field("Head Office"; rec."YVS Head Office")
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