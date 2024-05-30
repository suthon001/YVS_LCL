/// <summary>
/// PageExtension Sales Invoice Subpage (ID 80067) extends Record Sales Invoice Subform.
/// </summary>
pageextension 80067 "YVS Sales Invoice Subpage" extends "Sales Invoice Subform"
{
    layout
    {
        modify("Description 2")
        {
            Visible = true;
        }
        moveafter(Description; "Description 2")

        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
        moveafter("Location Code"; "Gen. Bus. Posting Group", "Gen. Prod. Posting Group", "VAT Bus. Posting Group", "VAT Prod. Posting Group")
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
        modify("Depr. until FA Posting Date")
        {
            Visible = CheckDisableLCL;
        }
        moveafter(Quantity; "Depr. until FA Posting Date")

        modify("Tax Group Code")
        {
            Visible = not CheckDisableLCL;
        }
        modify("Tax Area Code")
        {
            Visible = not CheckDisableLCL;
        }
        // modify(Quantity)
        // {
        //     trigger OnAfterValidate()
        //     var
        //         YVSEnventCenter: Codeunit "YVS EventFunction";
        //     begin
        //         YVSEnventCenter.CheckRemainingSalesInvoice(Rec);
        //     end;
        // }
        moveafter("VAT Bus. Posting Group"; "VAT Prod. Posting Group")
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