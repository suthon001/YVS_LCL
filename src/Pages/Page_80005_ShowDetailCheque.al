/// <summary>
/// Page YVS ShowDetail Cheque (ID 80005).
/// </summary>
page 80005 "YVS ShowDetail Cheque"
{
    Caption = 'Show Cheque';
    SourceTable = "Gen. Journal Line";
    SourceTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
    InsertAllowed = false;
    DeleteAllowed = false;
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
                group("Pay Information")
                {
                    ShowCaption = false;
                    field("Document No."; Rec."Document No.")
                    {
                        ApplicationArea = all;
                        Editable = false;
                        ToolTip = 'Specifies a document number for the journal line.';
                    }
                    field("Bank Code"; Rec."YVS Bank Code")
                    {
                        ApplicationArea = all;
                        CaptionClass = Caption_PayBankCode;
                        ToolTip = 'Specifies the value of the Bank Code field.';
                        ShowMandatory = true;
                        trigger OnValidate()
                        begin
                            setCustomerVendor();
                            CurrPage.Update();
                        end;

                    }
                    field("Bank Account No."; Rec."YVS Bank Account No.")
                    {
                        ApplicationArea = all;
                        CaptionClass = Caption_PayBankAccount;
                        ToolTip = 'Specifies the value of the Bank Account No. field.';
                    }
                    field("Bank Name"; Rec."YVS Bank Name")
                    {
                        ApplicationArea = all;
                        CaptionClass = Caption_PayBankName;
                        ToolTip = 'Specifies the value of the Bank Name field.';
                    }
                    field("YVS Bank Branch No."; rec."YVS Bank Branch No.")
                    {
                        CaptionClass = Caption_PayBankBranch;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the BankAccBranch field.';
                    }


                }
                group("Cheque Information")
                {
                    field("Customer/Vendor No."; Rec."YVS Customer/Vendor No.")
                    {
                        ApplicationArea = all;
                        CaptionClass = Caption_CustVendNo;
                        ToolTip = 'Specifies the value of the Customer/Vendor No. field.';
                        ShowMandatory = true;
                    }
                    field("Pay Name"; Rec."YVS Pay Name")
                    {
                        ApplicationArea = all;
                        CaptionClass = Cpation_CustVendName;
                        ToolTip = 'Specifies the value of the Pay Name field.';
                    }

                    field("Bank Branch No."; Rec."YVS Bank Branch No.")
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Bank Branch No. field.';
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
    trigger OnOpenPage()
    begin
        SetDefaultData();
    end;


    local procedure SetDefaultData()

    begin
        if rec."YVS Template Source Type" = rec."YVS Template Source Type"::"Cash Receipts" then begin
            Caption_CustVendNo := 'Customer No.';
            Cpation_CustVendName := 'Customer Name';
            Caption_PayBankCode := 'Pay-in Bank Code';
            Caption_PayBankAccount := 'Pay-in Bank Account No.';
            Caption_PayBankName := 'Pay-in Bank Name';
            Caption_PayBankBranch := 'Pay-in Bank Branch No.';
        end else
            if rec."YVS Template Source Type" = rec."YVS Template Source Type"::Payments then begin
                Caption_CustVendNo := 'Vendor No.';
                Cpation_CustVendName := 'Vendor Name';
                Caption_PayBankCode := 'Pay-from Bank Code';
                Caption_PayBankAccount := 'Pay-from Bank Account No.';
                Caption_PayBankName := 'Pay-from Bank Name';
                Caption_PayBankBranch := 'Pay-from Bank Branch No.';

            end;
    end;

    local procedure setCustomerVendor()
    var
        RecGenJnlLine: Record "Gen. Journal Line";
    begin
        if rec."YVS Template Source Type" = rec."YVS Template Source Type"::"Cash Receipts" then begin

            RecGenJnlLine.RESET();
            RecGenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
            RecGenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
            RecGenJnlLine.SetRange("Document No.", Rec."Document No.");
            RecGenJnlLine.SetRange("Account Type", Rec."Account Type"::Customer);
            if RecGenJnlLine.FindFirst() Then begin
                Rec.Validate("YVS Customer/Vendor No.", RecGenJnlLine."Account No.");
                Rec.Modify(true);
            end;
        end else
            if rec."YVS Template Source Type" = rec."YVS Template Source Type"::Payments then begin
                RecGenJnlLine.RESET();
                RecGenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                RecGenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                RecGenJnlLine.SetRange("Document No.", Rec."Document No.");
                RecGenJnlLine.SetRange("Account Type", Rec."Account Type"::Vendor);
                if RecGenJnlLine.FindFirst() Then begin
                    Rec.Validate("YVS Customer/Vendor No.", RecGenJnlLine."Account No.");
                    Rec.Modify(true);
                end;
            end;

    end;

    var
        Caption_CustVendNo: Text[100];
        Cpation_CustVendName: Text[100];
        Caption_PayBankCode: Text[100];
        Caption_PayBankAccount: Text[100];
        Caption_PayBankName: Text[100];
        Caption_PayBankBranch: Text[100];

}