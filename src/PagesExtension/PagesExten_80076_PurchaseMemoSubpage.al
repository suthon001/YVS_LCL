/// <summary>
/// PageExtension YVS Purch. Credit Memo Subpage (ID 80076) extends Record Purch. Cr. Memo Subform.
/// </summary>
pageextension 80076 "YVS Purch. Credit Memo Subpage" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        modify("Description 2")
        {
            Visible = true;
        }
        moveafter(Description; "Description 2")

        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }

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