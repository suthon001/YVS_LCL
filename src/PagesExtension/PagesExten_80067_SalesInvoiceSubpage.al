/// <summary>
/// PageExtension Sales Invoice Subpage (ID 80067) extends Record Sales Invoice Subform.
/// </summary>
pageextension 80067 "YVS Sales Invoice Subpage" extends "Sales Invoice Subform"
{
    layout
    {

        //  moveafter("Location Code"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group")
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

        // moveafter("VAT Bus. Posting Group"; "VAT Prod. Posting Group")
    }
    trigger OnDeleteRecord(): Boolean
    var
        YVSFunctionCenter: Codeunit "YVS Function Center";
    begin
        if CheckDisableLCL then
            if rec."Shipment No." <> '' then
                YVSFunctionCenter.SetDefualtGetInvoiceSales(rec."Shipment No.", Rec."Shipment Line No.");
    end;

    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";
}