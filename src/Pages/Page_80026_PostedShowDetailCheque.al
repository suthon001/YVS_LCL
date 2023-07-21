/// <summary>
/// Page YVS Posted ShowDetail Cheque (ID 80026).
/// </summary>
page 80026 "YVS Posted ShowDetail Cheque"
{
    Caption = 'Show Cheque';
    SourceTable = "Posted Gen. Journal Line";
    SourceTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
    InsertAllowed = false;
    DeleteAllowed = false;
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
                Caption = 'General';
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies a document number for the journal line.';
                }
                field("Customer/Vendor No."; Rec."YVS Customer/Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Customer/Vendor No. field.';
                }
                field("Bank Account No."; Rec."YVS Bank Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Account No. field.';
                }
                field("Pay Name"; Rec."YVS Pay Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Pay Name field.';
                }
                field("Bank Name"; Rec."YVS Bank Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }

                field("Bank Branch No."; Rec."YVS Bank Branch No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Branch No. field.';
                }

                field("Bank Code"; Rec."YVS Bank Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }
                field("Cheque No."; Rec."YVS Cheque No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cheque No. field.';
                }
                field("Cheque Date"; Rec."YVS Cheque Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cheque Date field.';
                }
            }
        }
    }



}