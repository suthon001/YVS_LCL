/// <summary>
/// PageExtension YVS PostedReceiptLines (ID 80038) extends Record Posted Purchase Rcpt. Subform.
/// </summary>
pageextension 80038 "YVS PostedReceiptLines" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {

        // moveafter(Type; "No.", Description, "Location Code", Quantity, "Unit of Measure Code", "Quantity Invoiced", "Qty. Rcd. Not Invoiced", "Planned Receipt Date",
        //  "Expected Receipt Date", "Order Date", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")


        //   moveafter(Description; "Description 2")
        addafter("Description 2")
        {

            field("YVS Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
                Visible = CheckDisableLCL;
            }
            field("YVS Gen. Prod. Posting Group"; rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
                Visible = CheckDisableLCL;
            }
            field("YVS VAT Bus. Posting Group"; rec."VAT Bus. Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.';
                Visible = CheckDisableLCL;
            }
            field("YVS VAT Prod. Posting Group"; rec."VAT Prod. Posting Group")
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