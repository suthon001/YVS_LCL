/// <summary>
/// PageExtension SalesReturnOrder Lines (ID 80034) extends Record Sales Return Order Subform.
/// </summary>
pageextension 80034 "YVS SalesReturnOrder Lines" extends "Sales Return Order Subform"
{
    layout
    {
        modify("Tax Group Code")
        {
            Visible = not CheckDisableLCL;
        }
        modify("Qty. to Assign")
        {
            Visible = not CheckDisableLCL;
        }
        modify("Qty. Assigned")
        {
            Visible = not CheckDisableLCL;
        }
        modify("Description 2")
        {
            Visible = CheckDisableLCL;
        }
        modify("Location Code")
        {
            Visible = CheckDisableLCL;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = CheckDisableLCL;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = CheckDisableLCL;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = CheckDisableLCL;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = CheckDisableLCL;
        }
        moveafter(Type; "No.", Description, "Description 2", "Location Code", "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Return Reason Code", Quantity,
        "Reserved Quantity", "Unit of Measure Code", "Unit Price", "Line Discount %", "Line Discount Amount", "Line Amount", "Return Qty. to Receive", "Return Qty. Received", "Quantity Invoiced",
         "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", ShortcutDimCode3, ShortcutDimCode4, ShortcutDimCode5, ShortcutDimCode6, ShortcutDimCode7, ShortcutDimCode8)

        addafter("Line Amount")
        {
            field("Qty. to Cancel"; Rec."YVS Qty. to Cancel")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
            field("Outstanding Quantity"; Rec."Outstanding Quantity")
            {
                ApplicationArea = all;
                Editable = false;
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