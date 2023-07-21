/// <summary>
/// Page YVS Sales Vat Subpage (ID 80012).
/// </summary>
page 80012 "YVS Sales Vat Subpage"
{

    PageType = ListPart;
    SourceTable = "YVS Tax & WHT Line";
    Caption = 'Sales Vat Subpage';
    InsertAllowed = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater("General")
            {
                Caption = 'General';
                field("Send to Report"; Rec."Send to Report")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Send to Report field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Voucher No."; Rec."Voucher No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Voucher No. field.';
                }
                field("Tax Invoice Date"; Rec."Tax Invoice Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Invoice Date field.';
                }
                field("Tax Invoice No."; Rec."Tax Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Invoice No. field.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Tax Invoice Name"; Rec."Tax Invoice Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tax Invoice Name field.';
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Address"; Rec."Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address 2 field.';
                }
                field("City"; Rec."City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the City field.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Code field.';
                }
                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Head Office field.';
                }
                field("VAT Branch Code"; Rec."VAT Branch Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Branch Code field.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Base Amount field.';
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Amount field.';

                }
                field("Cust. Amount"; Rec."Cust. Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cust. Amount field.';
                    Caption = 'Amount';

                }

                field("VAT Business Posting Group"; Rec."VAT Business Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Business Posting Group field.';
                }
                field("VAT Product Posting Group"; Rec."VAT Product Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Product Posting Group field.';
                }
            }

        }
    }
    actions
    {
        area(Processing)
        {
            group("Function")
            {
                Caption = 'Function';
                action("Generate Vat Entry")
                {
                    Caption = 'Generate Vat Entry';
                    Image = GetEntries;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Generate Vat Entry action.';
                    trigger OnAction()
                    begin
                        Rec."GetVatData"();
                        CurrPage.Update();
                    end;

                }

                action("Move Month")
                {
                    Caption = 'Move Month';
                    Image = MoveToNextPeriod;
                    ApplicationArea = all;
                    ToolTip = 'Executes the Move Month action.';
                    trigger OnAction()
                    var
                        MoveMonthPage: Page "YVS Tax Move Month";
                        TaxReportHeader: Record "YVS Tax & WHT Header";
                        TaxReportLine: Record "YVS Tax & WHT Line";

                    begin
                        TaxReportHeader.get(Rec."Tax Type", Rec."Document No.");
                        TaxReportLine.reset();
                        TaxReportLine.Copy(Rec);
                        CurrPage.SetSelectionFilter(TaxReportLine);
                        Clear(MoveMonthPage);
                        MoveMonthPage.Editable := false;
                        MoveMonthPage.LookupMode := true;
                        MoveMonthPage."SetData"(Rec."Tax Type", TaxReportHeader."End date of Month", TaxReportLine);
                        MoveMonthPage.RunModal();
                        Clear(MoveMonthPage);
                    end;
                }
            }
        }
    }
    /// <summary> 
    /// Description for SetVatBusFilter.
    /// </summary>
    /// <param name="VatBus">Parameter of type Code[250].</param>
    /// <param name="Vatprod">Code[250].</param>
    /// <param name="DateFilter">Parameter of type Text.</param>
    procedure "SetVatFilter"(VatBus: Code[250]; Vatprod: Code[250]; DateFilter: Text)
    begin
        Rec.SETFILTER("VAT Business Posting Group", VatBus);
        rec.SetFilter("VAT Product Posting Group", Vatprod);
        Rec.SETFILTER("Tax Invoice Date", DateFilter);
        CurrPage.Update();
    end;

    /// <summary> 
    /// Description for SumAmount.
    /// </summary>
    /// <param name="BaseAmount">Parameter of type Decimal.</param>
    /// <param name="VatAmount">Parameter of type Decimal.</param>
    procedure "SumAmount"(var BaseAmount: Decimal; var VatAmount: Decimal)
    var
        TaxReportLine: Record "YVS Tax & WHT Line";
    begin
        TaxReportLine.reset();
        TaxReportLine.CopyFilters(rec);
        if TaxReportLine.FindFirst() then begin
            TaxReportLine.CalcSums("Base Amount", "VAT Amount");
            BaseAmount := TaxReportLine."Base Amount";
            VatAmount := TaxReportLine."VAT Amount";
        end else begin
            BaseAmount := 0;
            VatAmount := 0;
        end;
    end;

}
