/// <summary>
/// PageExtension YVS PostedReceiptLines (ID 80038) extends Record Posted Purchase Rcpt. Subform.
/// </summary>
pageextension 80038 "YVS PostedReceiptLines" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        modify("Qty. Rcd. Not Invoiced")
        {
            Visible = CheckDisableLCL;
        }
        modify("Planned Receipt Date")
        {
            Visible = CheckDisableLCL;
        }
        modify("Order Date")
        {
            Visible = CheckDisableLCL;
        }
        modify("Expected Receipt Date")
        {
            Visible = CheckDisableLCL;
        }
        // moveafter(Type; "No.", Description, "Location Code", Quantity, "Unit of Measure Code", "Quantity Invoiced", "Qty. Rcd. Not Invoiced", "Planned Receipt Date",
        //  "Expected Receipt Date", "Order Date", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")

        modify("Description 2")
        {
            Visible = CheckDisableLCL;
        }
        //   moveafter(Description; "Description 2")
        addafter("Description 2")
        {

            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
                Visible = CheckDisableLCL;
            }

        }
        addafter("Gen. Bus. Posting Group")
        {
            field("Gen. Prod. Posting Group"; rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
                Visible = CheckDisableLCL;
            }
            field("VAT Bus. Posting Group"; rec."VAT Bus. Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.';
                Visible = CheckDisableLCL;
            }
            field("VAT Prod. Posting Group"; rec."VAT Prod. Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
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