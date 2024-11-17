/// <summary>
/// PageExtension Sales Quotes Subpage (ID 80018) extends Record Sales Quote Subform.
/// </summary>
pageextension 80018 "YVS Sales Quotes Subpage" extends "Sales Quote Subform"
{
    layout
    {
        modify("Description 2")
        {
            Visible = CheckDisableLCL;
        }
        // moveafter(Description; "Description 2", "Location Code")

        modify("Tax Group Code")
        {
            Visible = not CheckDisableLCL;

        }
        modify("Tax Area Code")
        {
            Visible = not CheckDisableLCL;

        }

        modify("Line Discount Amount")
        {
            Visible = CheckDisableLCL;
        }

        modify("Qty. to Assemble to Order")
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
        // moveafter("Location Code"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group")
        // moveafter(Quantity; "Unit of Measure Code", "Unit Price", "Line Discount %", "Line Discount Amount", "Line Amount", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
        // ShortcutDimCode3, ShortcutDimCode4, ShortcutDimCode5, ShortcutDimCode6, ShortcutDimCode7, ShortcutDimCode8)


    }
    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";
}