/// <summary>
/// PageExtension itemLists (ID 80032) extends Record Item List.
/// </summary>
pageextension 80032 "YVS itemLists" extends "Item List"

{
    layout
    {
        modify("Item Tracking Code")
        {
            Visible = CheckDisableLCL;
        }
        modify(Type)
        {
            Visible = CheckDisableLCL;
        }
        modify("Costing Method")
        {
            Visible = CheckDisableLCL;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = CheckDisableLCL;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = CheckDisableLCL;
        }
        modify("Default Deferral Template Code")
        {
            Visible = not CheckDisableLCL;
        }
        modify("Cost is Adjusted")
        {
            Visible = not CheckDisableLCL;
        }
        modify("Substitutes Exist")
        {
            Visible = not CheckDisableLCL;
        }
        modify("Sales Unit of Measure")
        {
            Visible = CheckDisableLCL;
        }
        modify("Purch. Unit of Measure")
        {
            Visible = CheckDisableLCL;
        }
        // moveafter("No."; Description, "Base Unit of Measure", "Unit Cost", Type, "Item Tracking Code", "Inventory Posting Group", "Gen. Prod. Posting Group", "VAT Prod. Posting Group"
        //  , "Costing Method", "Assembly BOM", "Replenishment System", "Production BOM No.", "Routing No.", "Unit Price", "Sales Unit of Measure", "Purch. Unit of Measure", "Vendor No.", "Search Description")




    }
    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";
}