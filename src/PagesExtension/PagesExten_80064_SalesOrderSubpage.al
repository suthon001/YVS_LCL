/// <summary>
/// PageExtension Sales Order Subpage (ID 80064) extends Record Sales Order Subform.
/// </summary>
pageextension 80064 "YVS Sales Order Subpage" extends "Sales Order Subform"
{
    layout
    {

        // moveafter(Type; "No.", Description, "Location Code", Quantity,
        // "Reserved Quantity", "Unit of Measure Code", "Unit Price", "Line Discount %", "Line Discount Amount", "Line Amount",
        // "Qty. to Ship", "Quantity Shipped", "Quantity Invoiced", "Planned Shipment Date", "Shipment Date", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
        // ShortcutDimCode3, ShortcutDimCode4, ShortcutDimCode5, ShortcutDimCode6, ShortcutDimCode7, ShortcutDimCode8)


        addafter("Quantity Invoiced")
        {

            field("Outstanding Quantity"; Rec."Outstanding Quantity")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
        }

        addafter("VAT Prod. Posting Group")
        {
            field("WHT Business Posting Group"; Rec."YVS WHT Business Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
            field("WHT Product Posting Group"; rec."YVS WHT Product Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
        }
        addafter("Quantity Invoiced")
        {
            field("YVS Qty. to Cancel"; rec."YVS Qty. to Cancel")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
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