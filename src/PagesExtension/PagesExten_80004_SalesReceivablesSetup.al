/// <summary>
/// PageExtension ExtenSalesReceSetup (ID 80004) extends Record Sales  Receivables Setup.
/// </summary>
pageextension 80004 "YVS ExtenSales & ReceSetup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast("Number Series")
        {

            field("Sales VAT Nos."; rec."YVS Sales VAT Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Sales VAT Nos. field.';
                Visible = CheckDisableLCL;
            }
            field("YVS Sales Billing Nos."; rec."YVS Sales Billing Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the YVS Sales Billing Nos. field.';
                Visible = CheckDisableLCL;
            }
            field("YVS Sale Receipt Nos."; rec."YVS Sale Receipt Nos.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Sales Receipt Nos. field.';
                Visible = CheckDisableLCL;
            }
        }
        addafter("Number Series")
        {
            group(SalesReceiptInformation)
            {
                Caption = 'Sales Receipt Information';
                Visible = CheckDisableLCL;
                field("YVS Default Prepaid WHT Acc."; rec."YVS Default Prepaid WHT Acc.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Default Prepaid WHT Acc. field.';
                    Visible = CheckDisableLCL;
                }
                field("YVS Default Bank Fee Acc."; rec."YVS Default Bank Fee Acc.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Default Bank Fee Acc. field.';
                    Visible = CheckDisableLCL;
                }
                field("YVS Default Diff Amount Acc."; rec."YVS Default Diff Amount Acc.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Default Diff Amount Acc. field.';
                    Visible = CheckDisableLCL;
                }
                field("YVS Default Cash Rec. Template"; rec."YVS Default Cash Rec. Template")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Default Cash Rec. Template field.';
                    Visible = CheckDisableLCL;
                }
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