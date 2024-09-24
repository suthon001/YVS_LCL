/// <summary>
/// Page YVS Sales Vat Card (ID 80011).
/// </summary>
page 80011 "YVS Sales Vat Card"
{

    PageType = Document;
    SourceTable = "YVS Tax & WHT Header";
    PromotedActionCategories = 'New,Process,Print,Approve,Release,Posting,Prepare,Request Approval,Approval,Print/Send,Navigate';
    Caption = 'Sales Vat Card';
    RefreshOnActivate = true;
    UsageCategory = None;
    layout
    {
        area(content)
        {
            group("General")
            {
                Caption = 'General';
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Document No. field.';
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("End date of Month"; Rec."End date of Month")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End date of Month field.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Year-Month"; Rec."Year-Month")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Year-Month field.';
                }
                field("Month No."; Rec."Month No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Month No field.';
                }
                field("Month Name"; Rec."Month Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Month Name field.';
                }
                field("Year No."; Rec."Year No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Year No field.';
                }
                field("Vat Option"; Rec."Vat Option")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vat Option field.';
                }
                field("Vat Bus. Post. Filter"; VatBusFilter)
                {
                    Caption = 'Vat Business Posing Group Filter';
                    TableRelation = "VAT Business Posting Group".Code;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vat Business Posing Group Filter field.';
                    trigger OnValidate()
                    begin

                        CurrPage."SalesVatSubpage".Page."SetVatFilter"(VatBusFilter, VatProdFilter, DateFilter);
                        CurrPage."SalesVatSubpage".Page."SumAmount"(TotaBaseAmt, TotalVatAmt);
                    end;

                }
                field(VatProdFilter; VatProdFilter)
                {
                    Caption = 'Vat Prod. Posing Group Filter';
                    TableRelation = "VAT Product Posting Group".Code;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vat Prod. Posing Group Filter field.';
                    trigger OnValidate()
                    begin

                        CurrPage."SalesVatSubpage".Page."SetVatFilter"(VatBusFilter, VatProdFilter, DateFilter);
                        CurrPage."SalesVatSubpage".Page."SumAmount"(TotaBaseAmt, TotalVatAmt);
                    end;

                }
                field("Date Filter"; DateFilter)
                {
                    Caption = 'Date Filter';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date Filter field.';
                    trigger OnValidate()
                    var
                        ApplicationManagement: Codeunit "Filter Tokens";
                        GLAcc: Record "G/L Account";
                    begin
                        ApplicationManagement.MakeDateFilter(DateFilter);
                        GLAcc.SETFILTER("Date Filter", DateFilter);
                        DateFilter := GLAcc.GETFILTER("Date Filter");

                        CurrPage."SalesVatSubpage".Page."SetVatFilter"(VatBusFilter, VatProdFilter, DateFilter);
                        CurrPage."SalesVatSubpage".Page."SumAmount"(TotaBaseAmt, TotalVatAmt);
                    end;
                }

                field("Total Base Amount"; TotaBaseAmt)
                {
                    Caption = 'Total Base Amount';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Total Base Amount field.';
                }
                field("Total Vat Amount"; TotalVatAmt)
                {
                    Caption = 'Total Vat Amount';
                    Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Total Vat Amount field.';
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            part("SalesVatSubpage"; "YVS Sales Vat Subpage")
            {
                SubPageView = sorting("Tax Type", "Document No.", "Entry No.");
                SubPageLink = "Tax Type" = field("Tax Type"), "Document No." = field("Document No.");
                ApplicationArea = all;
                UpdatePropagation = Both;
                Caption = 'Sales Vat Subpage';
                Editable = rec.Status = rec.Status::Open;
            }

        }

    }
    actions
    {
        area(Processing)
        {
            group("ReleaseReOpen")
            {
                Caption = 'Release&ReOpen';
                action("Release")
                {
                    Caption = 'Release';
                    Image = ReleaseDoc;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Release action.';
                    trigger OnAction()

                    begin
                        if rec.Status = rec.Status::Released then
                            exit;
                        rec.Status := rec.Status::Released;
                        rec.Modify();
                    end;
                }
                action("Open")
                {
                    Caption = 'Open';
                    Image = ReOpen;
                    ApplicationArea = all;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Open action.';
                    trigger OnAction()
                    var

                    begin
                        if rec.Status = rec.Status::Open then
                            exit;
                        rec.Status := rec.Status::Open;
                        rec.Modify();
                    end;
                }
            }
        }
        area(Reporting)
        {
            action("Sales Vat Report")
            {
                Caption = 'รายงานภาษีขาย';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = PrintVAT;
                ToolTip = 'Executes the รายงานภาษีขาย action.';
                trigger OnAction()
                var
                    TaxReportHeader: Record "YVS Tax & WHT Header";
                    ReportSalesVat: Report "YVS Sales Vat";
                begin

                    Clear(ReportSalesVat);
                    TaxReportHeader.Reset();
                    TaxReportHeader.SetRange("Tax Type", Rec."Tax Type");
                    TaxReportHeader.SetRange("Document No.", Rec."Document No.");
                    TaxReportHeader.FindFirst();
                    ReportSalesVat.SetTableView(TaxReportHeader);
                    ReportSalesVat."SetFilter"(vatBusFilter, VatProdFilter, DateFilter);
                    ReportSalesVat.Run();
                    Clear(ReportSalesVat);
                end;
            }
        }

    }
    /// <summary> 
    /// Description for GetDataFromReport.
    /// </summary>
    /// <param name="SetVatBus">Parameter of type Code[250].</param>
    /// <param name="SetDate">Parameter of type Text[250].</param>
    procedure GetDataFromReport(var SetVatBus: Code[250]; var SetDate: Text)
    begin
        SetVatBus := VatBusFilter;
        SetDate := DateFilter;
    end;

    trigger OnOpenPage()
    begin
        Rec.CalcFields("Total Base Amount", "Total VAT Amount");
        TotaBaseAmt := Rec."Total Base Amount";
        TotalVatAmt := Rec."Total VAT Amount";

    end;

    var

        TotaBaseAmt: Decimal;
        TotalVatAmt: Decimal;

    protected var
        VatBusFilter, VatProdFilter : Code[250];
        DateFilter: Text;






}
