/// <summary>
/// PageExtension SalesReturnOrder Lines (ID 80034) extends Record Sales Return Order Subform.
/// </summary>
pageextension 80034 "YVS SalesReturnOrder Lines" extends "Sales Return Order Subform"
{
    layout
    {

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