/// <summary>
/// Report Withholding (ID 80010).
/// </summary>
report 80010 "YVS Withholding"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80010_Withholding.rdl';
    PreviewMode = PrintLayout;
    PdfFontEmbedding = Yes;
    Caption = 'Report Withholding';
    UsageCategory = none;
    dataset
    {
        dataitem("Tax Report Header"; "YVS Tax & WHT Header")
        {
            column(WHTTypeFilter; Rec_WHTBusinessPostingGroup."Description")
            {
            }
            column(Name_CompanyInformation; CompanyInformation.Name)
            {
            }
            column(Address_CompanyInformation; CompanyInformation.Address)
            {
            }
            column(Address2_CompanyInformation; CompanyInformation."Address 2")
            {
            }
            column(VATRegistrationNo_CompanyInformation; CompanyInformation."VAT Registration No.")
            {
            }
            column(YesrPS; YesrPS)
            {
            }
            column(MonthName_TaxReportHeader; "Month Name")
            {
            }
            column(TotalBase; TotalBase) { }
            column(TotalAmt; TotalAmt) { }
            dataitem("Tax Report Line"; "YVS Tax & WHT Line")
            {
                DataItemTableView = sorting("Tax Type", "Document No.", "Entry No.");
                DataItemLink = "Tax Type" = FIELD("Tax Type"),
                               "Document No." = FIELD("Document No.");
                UseTemporary = true;
                column(LineNo; LineNo)
                {
                }
                column(WHTProctCode; "WHT Product Posting Group") { }
                column(TaxInvoiceNo_TaxReportLine; "Tax Invoice No.")
                {
                }
                column(TaxInvoiceDate_TaxReportLine; "Tax Invoice Date")
                {
                }
                column(TaxInvoiceName_TaxReportLine; "Tax Invoice Name")
                {
                }
                column(Establishment_TaxReportLine; "Head Office")
                {
                }
                column(BranchNo_TaxReportLine; "VAT Branch Code")
                {
                }
                column(VATRegistrationNo_TaxReportLine; "VAT Registration No.")
                {
                }
                column(Description_TaxReportLine; "Description")
                {
                }
                column(BaseAmount_TaxReportLine; "Base Amount")
                {
                }
                column(VATAmount_TaxReportLine; "VAT Amount")
                {
                }
                column(TaxType_TaxReportLine; "Tax Type")
                {
                }
                column(WHTDocumentNo_TaxReportLine; "WHT Document No.")
                {
                }
                column(WHTRegistrationID_TaxReportLine; "WHT Registration No.")
                {
                }
                column(WHTPercent_TaxReportLine; "WHT %")
                {
                }
                column(Name_TaxReportLine; "Name")
                {
                }
                column(Address_TaxReportLine; "Address")
                {
                }
                column(Address2_TaxReportLine; "Address 2")
                {
                }
                column(City_TaxReportLine; "City")
                {
                }
                column(PostCode_TaxReportLine; "Post Code")
                {
                }
                column(County_TaxReportLine; "County")
                {
                }
                column(DocumentNo_TaxReportLine; "Voucher No.")
                {
                }
                column(PostingDate_TaxReportLine; "Posting Date")
                {
                }
                column(WHTProduct; WHTProduct)
                {
                }
                column(DocumentNo; DocumentNo)
                {
                }
                column(WHTDocumentNo; WHTDocumentNo)
                {
                }
                column(WHTPercent_1; WHTPercent[1])
                {
                }
                column(TaxType_1; TaxType[1])
                {
                }
                column(BaseAmount_1; BaseAmount[1])
                {
                }
                column(VATAmount_1; VATAmount[1])
                {
                }
                column(WHTPercent_2; WHTPercent[2])
                {
                }
                column(TaxType_2; TaxType[2])
                {
                }
                column(BaseAmount_2; BaseAmount[2])
                {
                }
                column(VATAmount_2; VATAmount[2])
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF Show_DocumentNo THEN BEGIN
                        DocumentNo := "Vendor No.";
                        WHTDocumentNo := "WHT Document No."
                    END
                    ELSE BEGIN
                        DocumentNo := '';
                        WHTDocumentNo := '';
                    END;
                    LineNo += 1;
                    WHTProductPostingGroup.GET("WHT Product Posting Group");
                    WHTProduct := WHTProductPostingGroup."Description";
                    AfterGetWHTProdDescriptionWithholdingWHTProduct(WHTProduct, WHTProductPostingGroup, "Tax Report Header");
                    CLEAR(WHTPercent);
                    CLEAR(TaxType);
                    CLEAR(BaseAmount);
                    CLEAR(VATAmount);


                    WHTPercent[1] := "WHT %";
                    if not WHTProductPostingGroup.GET("WHT Product Posting Group") then
                        WHTProductPostingGroup.init();
                    TaxType[1] := WHTProductPostingGroup."Description";
                    AfterGetWHTProdDescriptionWithholdingTaxType(TaxType, WHTProductPostingGroup, "Tax Report Header");
                    BaseAmount[1] := "Base Amount";
                    VATAmount[1] := "VAT Amount";

                    TaxReportLineFind.RESET();
                    TaxReportLineFind.SETFILTER("Tax Type", '%1', "Tax Type");
                    TaxReportLineFind.SETFILTER("Document No.", '%1', "Document No.");
                    TaxReportLineFind.SETFILTER("WHT Document No.", '%1', "WHT Document No.");
                    TaxReportLineFind.SetFilter("WHT Product Posting Group", '<>%1', "WHT Product Posting Group");
                    IF TaxReportLineFind.FindFirst() THEN begin
                        //  REPEAT
                        //  i += 1;
                        WHTPercent[2] := TaxReportLineFind."WHT %";
                        if not WHTProductPostingGroup.GET(TaxReportLineFind."WHT Product Posting Group") then
                            WHTProductPostingGroup.init();
                        TaxType[2] := WHTProductPostingGroup."Description";
                        AfterGetWHTProdDescriptionWithholdingTaxType2(TaxType, WHTProductPostingGroup, "Tax Report Header");
                        BaseAmount[2] := TaxReportLineFind."Base Amount";
                        VATAmount[2] := TaxReportLineFind."VAT Amount";
                    end;
                    //  UNTIL TaxReportLineFind.NEXT = 0;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("WHT Business Posting Group", WHTBus);
                    if WHTDate <> '' then
                        SetFilter("Posting Date", WHTDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                YesrPS := "Year No." + 543;
                IF NOT Rec_WHTBusinessPostingGroup.GET(WHTBus) THEN
                    Rec_WHTBusinessPostingGroup.Init();

                TaxReportLineFind.RESET();
                TaxReportLineFind.SetCurrentKey("Tax Type", "Document No.", "Entry No.");
                TaxReportLineFind.SETFILTER("Tax Type", '%1', "Tax Type");
                TaxReportLineFind.SETFILTER("Document No.", '%1', "Document No.");
                if TaxReportLineFind.FindSet() then
                    repeat
                        "Tax Report Line".reset();
                        "Tax Report Line".SetRange("Tax Type", TaxReportLineFind."Tax Type");
                        "Tax Report Line".SetRange("Document No.", TaxReportLineFind."Document No.");
                        "Tax Report Line".SetFilter("WHT Document No.", TaxReportLineFind."WHT Document No.");
                        if not "Tax Report Line".FindFirst() then begin
                            "Tax Report Line".Init();
                            "Tax Report Line".TransferFields(TaxReportLineFind);
                            "Tax Report Line".insert();
                        end;
                        TotalBase := TotalBase + TaxReportLineFind."Base Amount";
                        TotalAmt := TotalAmt + TaxReportLineFind."VAT Amount";
                    until TaxReportLineFind.Next() = 0;

                "Tax Report Line".reset();
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field("Show Document No"; Show_DocumentNo)
                    {
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Show_DocumentNo field.';
                        Caption = 'Show Document No.';
                    }
                }
            }
        }


    }



    trigger OnPreReport()
    begin

        CompanyInformation.GET();
        CompanyInformation.CALCFIELDS(Picture);
    end;

    /// <summary> 
    /// Description for SetFilter.
    /// </summary>
    /// <param name="TempWHT">Parameter of type Code[30].</param>
    /// <param name="Tempdate">Parameter of type Text[100].</param>
    procedure "SetFilter"(TempWHT: Code[30]; Tempdate: Text)
    begin
        if Tempdate <> '' then
            "Tax Report Line".SetFilter("Posting Date", Tempdate);
        WHTBus := TempWHT;
        WHTDate := Tempdate;

    end;

    [IntegrationEvent(false, false)]
    local procedure AfterGetWHTProdDescriptionWithholdingWHTProduct(var pWHTDescription: Text[100]; pWHTPostingGroup: Record "YVS WHT Product Posting Group"; pTaxWHTHeader: Record "YVS Tax & WHT Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure AfterGetWHTProdDescriptionWithholdingTaxType(var pWHTDescription: array[2] of Text[100]; pWHTPostingGroup: Record "YVS WHT Product Posting Group"; pTaxWHTHeader: Record "YVS Tax & WHT Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure AfterGetWHTProdDescriptionWithholdingTaxType2(var pWHTDescription: array[2] of Text[100]; pWHTPostingGroup: Record "YVS WHT Product Posting Group"; pTaxWHTHeader: Record "YVS Tax & WHT Header")
    begin
    end;

    var
        CompanyInformation: Record 79;
        LineNo: Integer;
        YesrPS: Integer;
        Rec_WHTBusinessPostingGroup: Record "YVS WHT Business Posting Group";
        WHTProductPostingGroup: Record "YVS WHT Product Posting Group";
        Show_DocumentNo: Boolean;
        WHTProduct: text[100];
        DocumentNo: Code[20];
        WHTDocumentNo: Code[20];
        WHTPercent: array[2] of Decimal;
        TaxType: array[2] of Text[100];
        BaseAmount: array[2] of Decimal;
        VATAmount: array[2] of Decimal;
        TaxReportLineFind: Record "YVS Tax & WHT Line";
        TotalBase, TotalAmt : Decimal;
        WHTBus: Code[100];
        WHTDate: Text;
}

