/// <summary>
/// PageExtension YVS Depreciation Books Subform (ID 80086) extends Record FA Depreciation Books Subform.
/// </summary>
pageextension 80086 "YVS Depreciation Books Subform" extends "FA Depreciation Books Subform"
{
    layout
    {
        modify("Straight-Line %")
        {
            Visible = true;
        }
        addafter("No. of Depreciation Years")
        {
            field("YVS No. of Years"; Rec."YVS No. of Years")
            {
                ApplicationArea = all;
                Caption = 'No. of Depreciation Years.';
                ToolTip = 'Specifies the value of the No. of Years field.';
            }
        }
        modify("No. of Depreciation Years")
        {
            Visible = false;
        }
        addafter("YVS No. of Years")
        {
            field("YVS Acquisition Cost"; Rec."Acquisition Cost")
            {
                ApplicationArea = all;
                Caption = 'Acquisition Cost';
                ToolTip = 'Specifies the total acquisition cost for the fixed asset.';
            }
            field("YVS Depreciation"; Rec.Depreciation)
            {
                ApplicationArea = all;
                Caption = 'Depreciation';
                ToolTip = 'Specifies the total depreciation for the fixed asset.';
            }
        }
        addafter(BookValue)
        {
            field("YVS Salvage Value"; Rec."Salvage Value")
            {
                ApplicationArea = all;
                Caption = 'Salvage Value';
                ToolTip = 'Specifies the estimated residual value of a fixed asset when it can no longer be used.';
            }
            field("YVS Proceeds on Disposal"; Rec."Proceeds on Disposal")
            {
                ApplicationArea = all;
                Caption = 'Proceeds on Disposal';
                ToolTip = 'Specifies the total proceeds on disposal for the fixed asset.';
            }
            field("YVS Gain/Loss"; Rec."Gain/Loss")
            {
                ApplicationArea = all;
                Caption = 'Gain/Loss';
                ToolTip = 'Specifies the total gain (credit) or loss (debit) for the fixed asset.';
            }

        }
    }
}
