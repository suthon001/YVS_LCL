/// <summary>
/// PageExtension YVS VatPostingSetup (ID 80050) extends Record VAT Posting Setup Card.
/// </summary>
pageextension 80050 "YVS VatPostingSetup" extends "VAT Posting Setup Card"
{
    layout
    {
        addlast(General)
        {
            field("YVS Allow to Purch. Vat"; rec."YVS Allow to Purch. Vat")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Generate Purch. Vat Report field.';
                Visible = CheckDisableLCL;
            }
            field("YVS Allow to Sales Vat"; rec."YVS Allow to Sales Vat")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Generate Sales Vat Report field.';
                Visible = CheckDisableLCL;
            }
        }
        modify("Unrealized VAT Type")
        {
            Visible = true;
        }
        modify("Sales VAT Unreal. Account")
        {
            Visible = true;
        }
        modify("Purch. VAT Unreal. Account")
        {
            Visible = true;
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