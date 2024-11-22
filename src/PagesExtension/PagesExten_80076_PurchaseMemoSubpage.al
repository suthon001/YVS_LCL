/// <summary>
/// PageExtension YVS Purch. Credit Memo Subpage (ID 80076) extends Record Purch. Cr. Memo Subform.
/// </summary>
pageextension 80076 "YVS Purch. Credit Memo Subpage" extends "Purch. Cr. Memo Subform"
{
    layout
    {


        addafter("VAT Prod. Posting Group")
        {
            field("WHT Product Posting Group"; Rec."YVS WHT Product Posting Group")
            {
                ApplicationArea = All;
                Caption = 'WHT Product Posting Group';
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
        }
    }
    trigger OnDeleteRecord(): Boolean
    var
        YVSFunctionCenter: Codeunit "YVS Function Center";
    begin
        if CheckDisableLCL then
            if rec."Return Shipment No." <> '' then
                YVSFunctionCenter.SetDefualtGetPurchCN(rec."Return Shipment No.", Rec."Return Shipment Line No.");
    end;

    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";
}