/// <summary>
/// PageExtension Purchase Quotes Subpage (ID 80013) extends Record Purchase Quote Subform.
/// </summary>
pageextension 80013 "YVS Purchase Quotes Subpage" extends "Purchase Quote Subform"
{
    layout
    {
        modify("Description 2")
        {
            Visible = NOT CheckDisableLCL;
        }
        modify(Type)
        {
            Importance = Standard;
            ApplicationArea = all;
            Visible = CheckDisableLCL;
        }
        modify(FilteredTypeField)
        {
            Visible = NOT CheckDisableLCL;
        }
        modify("Qty. to Assign") { Visible = NOT CheckDisableLCL; }
        modify("Qty. Assigned") { Visible = NOT CheckDisableLCL; }
        modify("Expected Receipt Date") { Visible = NOT CheckDisableLCL; }
        modify("Item Reference No.") { Visible = NOT CheckDisableLCL; }
        modify("VAT Bus. Posting Group") { Visible = NOT CheckDisableLCL; }
        modify("VAT Prod. Posting Group") { Visible = NOT CheckDisableLCL; }
        modify("Gen. Bus. Posting Group") { Visible = NOT CheckDisableLCL; }
        modify("Gen. Prod. Posting Group") { Visible = NOT CheckDisableLCL; }
        //  moveafter(Description; "Description 2")
        // movefirst(Control1; Type, "No.", Description, "Description 2", "Location Code", "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group", Quantity, "Unit of Measure Code", "Direct Unit Cost", "Line Discount %", "Line Discount Amount", "Line Amount",
        // "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", ShortcutDimCode3, ShortcutDimCode4, ShortcutDimCode5, ShortcutDimCode6, ShortcutDimCode7, ShortcutDimCode8)
        addafter(Quantity)
        {
            field("YVS Qty. to Cancel"; rec."YVS Qty. to Cancel")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Qty. to Cancel field.';
                Visible = CheckDisableLCL;
            }
        }
        addafter("Location Code")
        {
            field("Bin Code"; rec."Bin Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Bin Code field.';
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