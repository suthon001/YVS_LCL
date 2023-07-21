/// <summary>
/// Page YVS PostedShowDetailWHT (ID 80027).
/// </summary>
page 80027 "YVS PostedShowDetailWHT"
{
    Caption = 'Show WHT';
    SourceTable = "Posted Gen. Journal Line";
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("WHT No."; Rec."YVS WHT Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Document No. field.';
                }
                field("WHT Date"; Rec."YVS WHT Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Date field.';
                }
                field("Customer/Vendor"; Rec."YVS WHT Cust/Vend No.")
                {
                    Caption = 'Customer No.';
                    ApplicationArea = All;
                    TableRelation = Customer."No.";
                    ToolTip = 'Specifies the value of the Customer No. field.';

                }
                field("WHT Name"; Rec."YVS WHT Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Name field.';
                }
                field("WHT Name 2"; Rec."YVS WHT Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Name 2 field.';
                }
                field("WHT Address"; Rec."YVS WHT Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Address field.';
                }
                field("WHT Address 2"; Rec."YVS WHT Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Address 2 field.';
                }
                field("WHT City"; Rec."YVS WHT City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT City field.';
                }
                field("WHT County"; Rec."YVS WHT County")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT County field.';
                }
                field("WHT Post Code"; Rec."YVS WHT Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Post Code field.';
                }
                field("WHT Registration No."; Rec."YVS WHT Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Registration No. field.';
                }
                field("WHT Business Posting Group"; Rec."YVS WHT Business Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Business Posting Group field.';
                }
                field("WHT Product Posting Group"; Rec."YVS WHT Product Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Posting Group field.';
                }
                field("WHT Base"; Rec."YVS WHT Base")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Base field.';
                }
                field("WHT %"; Rec."YVS WHT %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT % field.';
                }
                field("WHT Amount"; Rec."YVS WHT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WHT Amount field.';
                }

            }
        }
    }
}