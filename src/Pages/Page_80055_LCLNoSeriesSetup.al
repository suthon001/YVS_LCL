/// <summary>
/// Page YVS LCL No. Series Setup (ID 80055).
/// </summary>
page 80055 "YVS LCL No. Series Setup"
{
    ApplicationArea = All;
    Caption = 'LCL No. Series Setup';
    PageType = CardPart;
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                grid(NoSeriesDeail)
                {
                    GridLayout = Rows;
                    ShowCaption = false;
                    group(GroupNoSeries)
                    {
                        ShowCaption = false;
                        Group(AssignToSetupDetail)
                        {
                            ShowCaption = false;
                            grid(AssignToSetupGrid)
                            {
                                ShowCaption = false;
                                field(AssignToSetup; AssignToSetup)
                                {
                                    Caption = 'Assign to Table Setup';
                                    TableRelation = "No. Series".Code;
                                    ToolTip = 'Specifies the value of the Assign To Setup field.';
                                }

                            }
                        }
                        Group(PVATDetail)
                        {
                            ShowCaption = false;
                            grid(g2PVAT)
                            {
                                ShowCaption = false;
                                field(PVAT; PVAT)
                                {
                                    Caption = 'Purchase Vat Nos.';
                                    TableRelation = "No. Series".Code;
                                    ToolTip = 'Specifies the value of the Purchase Vat Nos. field.';
                                }
                                field(PVATStartDate; PVATStartDate)
                                {
                                    Caption = 'Starting No.';
                                    ToolTip = 'Specifies the value of the Starting No. field.';
                                }
                                field(PVATText; PVATText)
                                {
                                    Caption = 'Description';
                                    ToolTip = 'Specifies the value of the Description field.';

                                }
                            }
                        }

                        Group(SVATDetail)
                        {
                            ShowCaption = false;
                            grid(g2SVAT)
                            {
                                ShowCaption = false;
                                field(SVAT; SVAT)
                                {
                                    Caption = 'Sales Vat Nos.';
                                    TableRelation = "No. Series".Code;
                                    ToolTip = 'Specifies the value of the Sales Vat Nos. field.';
                                }
                                field(SVATStartDate; SVATStartDate)
                                {
                                    Caption = 'Starting No.';
                                    ToolTip = 'Specifies the value of the Starting No. field.';
                                }
                                field(SVATText; SVATText)
                                {
                                    Caption = 'Description';
                                    ToolTip = 'Specifies the value of the Description field.';

                                }
                            }
                        }
                        Group(SalesBDetail)
                        {
                            ShowCaption = false;
                            grid(g2SalesB)
                            {
                                ShowCaption = false;
                                field(SalesBilling; SalesBilling)
                                {
                                    Caption = 'Sales Billing Nos.';
                                    TableRelation = "No. Series".Code;
                                    ToolTip = 'Specifies the value of the Sales Billing Nos. field.';
                                }
                                field(SalesBillingStartDate; SalesBillingStartDate)
                                {
                                    Caption = 'Starting No.';
                                    ToolTip = 'Specifies the value of the Starting No. field.';
                                }
                                field(SalesBillingText; SalesBillingText)
                                {
                                    Caption = 'Description';
                                    ToolTip = 'Specifies the value of the Description field.';

                                }
                            }
                        }
                        Group(SalesRDetail)
                        {
                            ShowCaption = false;
                            grid(g2SalesR)
                            {
                                ShowCaption = false;
                                field(SalesReceipt; SalesReceipt)
                                {
                                    Caption = 'Sales Receipt Nos.';
                                    TableRelation = "No. Series".Code;
                                    ToolTip = 'Specifies the value of the Sales Receipt Nos. field.';
                                }
                                field(SalesReceiptStartDate; SalesReceiptStartDate)
                                {
                                    Caption = 'Starting No.';
                                    ToolTip = 'Specifies the value of the Starting No. field.';
                                }
                                field(SalesReceiptText; SalesReceiptText)
                                {
                                    Caption = 'Description';
                                    ToolTip = 'Specifies the value of the Description field.';

                                }
                            }
                        }
                    }
                }
            }
        }
    }
    trigger OnOpenPage()
    begin


        PVAT := 'P-VAT';
        PVATText := 'เลขที่รายงานภาษีซื้อ (Purchase VAT)';
        PVATStartDate := 'PVAT' + format(Today(), 0, '<Year,2><Month,2>') + '-00001';
        SVAT := 'S-VAT';
        SVATText := 'เลขที่รายงานภาษีขาย (Sales VAT)';
        SVATStartDate := 'SVAT' + format(Today(), 0, '<Year,2><Month,2>') + '-00001';
        SalesBilling := 'S-BILL';
        SalesBillingText := 'ใบวางบิล';
        SalesBillingStartDate := 'SBL' + format(Today(), 0, '<Year,2><Month,2>') + '-00001';
        SalesReceipt := 'S-RECEIPT';
        SalesReceiptText := 'ใบเสร็จรับเงิน/ใบกำกับภาษี';
        SalesReceiptStartDate := 'SRC' + format(Today(), 0, '<Year,2><Month,2>') + '-00001';
        AssignToSetup := true;
    end;
    /// <summary>
    /// InserttoRecord.
    /// </summary>
    procedure InserttoRecord()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        PurchaseSetup: Record "Purchases & Payables Setup";
    begin

        if SVAT <> '' then
            InsertToNoSeries(SVAT, SVATText, SVATStartDate);
        if PVAT <> '' then
            InsertToNoSeries(PVAT, PVATText, PVATStartDate);
        if SalesBilling <> '' then
            InsertToNoSeries(SalesBilling, SalesBillingText, SalesBillingStartDate);
        if SalesReceipt <> '' then
            InsertToNoSeries(SalesReceipt, SalesReceiptText, SalesReceiptStartDate);

        if AssignToSetup then begin
            SalesSetup.GET();
            SalesSetup."YVS Sales VAT Nos." := SVAT;
            SalesSetup."YVS Sales Billing Nos." := SalesBilling;
            SalesSetup."YVS Sale Receipt Nos." := SalesReceipt;
            SalesSetup.Modify();
            PurchaseSetup.GET();
            PurchaseSetup."YVS Purchase VAT Nos." := PVAT;
            PurchaseSetup."YVS Purchase Request Nos." := '';
            PurchaseSetup.Modify();
        end;
    end;

    local procedure InsertToNoSeries(pCode: code[20]; pDesc: Text[100]; pStartDate: Code[20])
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if not NoSeries.GET(pCode) then begin
            NoSeries.Init();
            NoSeries.Code := pCode;
            NoSeries.Description := pDesc;
            NoSeries."Default Nos." := true;
            NoSeries.Insert();
            if pStartDate <> '' then begin
                NoSeriesLine.Init();
                NoSeriesLine."Series Code" := pCode;
                NoSeriesLine."Line No." := 10000;
                NoSeriesLine."Starting Date" := CalcDate('<-CM>', Today());
                NoSeriesLine.Insert();
                NoSeriesLine.Validate("Starting No.", pStartDate);
                NoSeriesLine."Increment-by No." := 1;
                NoSeriesLine.Open := true;
                NoSeriesLine.Modify();
            end;
        end;
    end;

    var
        PVAT, SVAT, SalesBilling, SalesReceipt : Code[20];
        PVATStartDate, SVATStartDate, SalesBillingStartDate, SalesReceiptStartDate : code[20];
        PVATText, SVATText, SalesBillingText, SalesReceiptText : text[100];
        AssignToSetup: Boolean;
}
