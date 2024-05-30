/// <summary>
/// PageExtension YVS Purchase Invoice Subpage (ID 80073) extends Record Purch. Invoice Subform.
/// </summary>
pageextension 80073 "YVS Purchase Invoice Subpage" extends "Purch. Invoice Subform"
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

        addlast(PurchDetailLine)
        {
            field("Tax Invoice Date"; Rec."YVS Tax Invoice Date")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
            field("Tax Invoice No."; Rec."YVS Tax Invoice No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
            field("Tax Vendor No."; Rec."YVS Tax Vendor No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
            field("Tax Invoice Name"; Rec."YVS Tax Invoice Name")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
            field("Tax Invoice Base"; Rec."YVS Tax Invoice Base")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }

            field("Head Office"; Rec."YVS Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
            field("VAT Branch Code"; Rec."YVS VAT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
            field("Vat Registration No."; Rec."YVS Vat Registration No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
                Visible = CheckDisableLCL;
            }
        }


        modify("Tax Area Code")
        {
            Visible = not CheckDisableLCL;
        }
        modify("Tax Group Code")
        {
            Visible = not CheckDisableLCL;
        }
        // modify(Quantity)
        // {
        //     trigger OnAfterValidate()
        //     var
        //         YVSEnventCenter: Codeunit "YVS EventFunction";
        //     begin
        //         YVSEnventCenter.CheckRemainingPurchaseInvoice(Rec);
        //     end;
        // }

    }
    trigger OnDeleteRecord(): Boolean
    var
        YVSFunctionCenter: Codeunit "YVS Function Center";

    begin
        if CheckDisableLCL then
            if rec."Receipt No." <> '' then
                YVSFunctionCenter.SetDefualtGetInvoicePurch(rec."Receipt No.", Rec."Receipt Line No.");
    end;

    trigger OnOpenPage()
    begin
        CheckDisableLCL := FuncenterYVS.CheckDisableLCL();
    end;

    var
        CheckDisableLCL: Boolean;
        FuncenterYVS: Codeunit "YVS Function Center";

}