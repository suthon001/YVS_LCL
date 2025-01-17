/// <summary>
/// Report WHT PND 53 (ID 80014).
/// </summary>
report 80014 "YVS WHT PND 53"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80014_PND_53.rdl';
    PreviewMode = PrintLayout;
    PdfFontEmbedding = Yes;
    Caption = 'Report PND 53';
    UsageCategory = None;
    dataset
    {
        dataitem("Tax Report Header"; "YVS Tax & WHT Header")
        {
            column(WHTTypeFilter; WHTTypeFilter)
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
            column(VAT_ID_1; VAT_ID[1])
            {
            }
            column(VAT_ID_2; VAT_ID[2])
            {
            }
            column(VAT_ID_3; VAT_ID[3])
            {
            }
            column(VAT_ID_4; VAT_ID[4])
            {
            }
            column(VAT_ID_5; VAT_ID[5])
            {
            }
            column(VAT_ID_6; VAT_ID[6])
            {
            }
            column(VAT_ID_7; VAT_ID[7])
            {
            }
            column(VAT_ID_8; VAT_ID[8])
            {
            }
            column(VAT_ID_9; VAT_ID[9])
            {
            }
            column(VAT_ID_10; VAT_ID[10])
            {
            }
            column(VAT_ID_11; VAT_ID[11])
            {
            }
            column(VAT_ID_12; VAT_ID[12])
            {
            }
            column(VAT_ID_13; VAT_ID[13])
            {
            }
            column(var_VATAddress; var_VATAddress)
            {
            }
            column(Month_No_1; Month_No[1])
            {
            }
            column(Month_No_2; Month_No[2])
            {
            }
            column(Month_No_3; Month_No[3])
            {
            }
            column(Month_No_4; Month_No[4])
            {
            }
            column(Month_No_5; Month_No[5])
            {
            }
            column(Month_No_6; Month_No[6])
            {
            }
            column(Month_No_7; Month_No[7])
            {
            }
            column(Month_No_8; Month_No[8])
            {
            }
            column(Month_No_9; Month_No[9])
            {
            }
            column(Month_No_10; Month_No[10])
            {
            }
            column(Month_No_11; Month_No[11])
            {
            }
            column(Month_No_12; Month_No[12])
            {
            }
            column(var_Amount; var_Amount)
            {
            }
            column(var_WHTAmount; var_WHTAmount)
            {
            }
            column(var_WHTTotalAmount; var_WHTTotalAmount)
            {
            }
            column(var_Send_Type_1; var_Send_Type[1])
            {
            }
            column(var_Send_Type_2; var_Send_Type[2])
            {
            }
            column(var_Send_Type_3; var_Send_Type[3])
            {
            }
            column(var_Send_Option_1; var_Send_Option[1])
            {
            }
            column(var_Send_Option_2; var_Send_Option[2])
            {
            }
            column(var_CountVend; var_CountVend)
            {
            }
            column(Total_Page; PageNo)
            {
            }
            column(Additional_No; Additional_No)
            {
            }
            column(var_CompanyName; var_CompanyName)
            {
            }

            trigger OnAfterGetRecord()

            begin
                // CalcFields("Total Base Amount", "Total VAT Amount");
                var_Amount := 0;
                var_WHTAmount := 0;
                var_WHTTotalAmount := 0;
                TaxReportLine.RESET();
                TaxReportLine.SETFILTER("Tax Type", '%1', "Tax Type");
                TaxReportLine.SETFILTER("Document No.", '%1', "Document No.");
                TaxReportLine.SetRange("Send to Report", true);
                if TaxReportLine.FindFirst() then begin
                    TaxReportLine.CalcSums("Base Amount", "VAT Amount");
                    var_Amount := TaxReportLine."Base Amount";
                    var_WHTAmount := TaxReportLine."VAT Amount";
                    var_WHTTotalAmount := var_WHTAmount;
                end;

                YesrPS := "Year No." + 543;
                Rec_WHTBusinessPostingGroup.reset();
                Rec_WHTBusinessPostingGroup.SetRange("WHT Type", Rec_WHTBusinessPostingGroup."WHT Type"::PND53);
                if Rec_WHTBusinessPostingGroup.FindFirst() then;
                //###### SubString VAT ID #####
                VAT_ID[1] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 1, 1);
                VAT_ID[2] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 2, 1);
                VAT_ID[3] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 3, 1);
                VAT_ID[4] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 4, 1);
                VAT_ID[5] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 5, 1);
                VAT_ID[6] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 6, 1);
                VAT_ID[7] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 7, 1);
                VAT_ID[8] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 8, 1);
                VAT_ID[9] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 9, 1);
                VAT_ID[10] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 10, 1);
                VAT_ID[11] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 11, 1);
                VAT_ID[12] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 12, 1);
                VAT_ID[13] := COPYSTR(Rec_WHTBusinessPostingGroup."VAT Registration No.", 13, 1);

                var_VATAddress := Rec_WHTBusinessPostingGroup."Address" + Rec_WHTBusinessPostingGroup."Address 2";
                var_CompanyName := Rec_WHTBusinessPostingGroup."Name";
                Month_No["Month No."] := '/';

                // TaxReportLine.RESET();
                // TaxReportLine.SETFILTER("Tax Type", '%1', "Tax Type");
                // TaxReportLine.SETFILTER("Document No.", '%1', "Document No.");

                // if DateFilter <> '' then
                //     TaxReportLine.SETFILTER("Posting Date", DateFilter);
                // IF TaxReportLine.FIND('-') THEN
                //     REPEAT

                //         var_Amount := var_Amount + TaxReportLine."Base Amount";
                //         var_WHTAmount := var_WHTAmount + TaxReportLine."VAT Amount";
                //         var_WHTTotalAmount := var_WHTTotalAmount + TaxReportLine."VAT Amount";

                //     UNTIL TaxReportLine.NEXT() = 0;

                RowsPerPage := 5;
                PageNo := 1;
                TaxReportLine.RESET();
                TaxReportLine.SetCurrentKey("Tax Type", "Document No.", "Entry No.");
                TaxReportLine.SETFILTER("Tax Type", '%1', "Tax Type");
                TaxReportLine.SETFILTER("Document No.", '%1', "Document No.");
                TaxReportLine.SetRange("Send to Report", true);
                if TaxReportLine.FindSet() then
                    repeat
                        TaxReportLineTemp.reset();
                        TaxReportLineTemp.SetRange("Tax Type", TaxReportLine."Tax Type");
                        TaxReportLineTemp.SetRange("Document No.", TaxReportLine."Document No.");
                        TaxReportLineTemp.SetFilter("WHT Document No.", TaxReportLine."WHT Document No.");
                        if not TaxReportLineTemp.FindFirst() then begin
                            TaxReportLineTemp.Init();
                            TaxReportLineTemp.TransferFields(TaxReportLine);
                            TaxReportLineTemp.insert();
                        end;
                    until TaxReportLine.Next() = 0;


                TaxReportLineTemp.reset();
                TaxReportLineTemp.SetCurrentKey("Tax Type", "Document No.", "Entry No.");
                if TaxReportLineTemp.FindSet() then
                    repeat
                        IF CurrDocNo = '' THEN BEGIN
                            CurrDocNo := TaxReportLineTemp."WHT Certificate No.";
                            var_CountVend += 1;
                        END
                        ELSE
                            IF CurrDocNo <> TaxReportLineTemp."WHT Certificate No." THEN BEGIN
                                IF (var_CountVend > 0) AND (CurrDocNo <> '') AND (var_CountVend MOD RowsPerPage = 0) THEN
                                    PageNo += 1;

                                CurrDocNo := TaxReportLineTemp."WHT Certificate No.";
                                var_CountVend += 1;

                            END;

                    until TaxReportLineTemp.Next() = 0;


                // TaxReportLine.RESET();
                // TaxReportLine.SETCURRENTKEY("WHT Registration No.");
                // TaxReportLine.SETFILTER("Tax Type", '%1', "Tax Type");
                // TaxReportLine.SETFILTER("Document No.", '%1', "Document No.");
                // TaxReportLine.SetRange("Send to Report", true);
                // if DateFilter <> '' then
                //     TaxReportLine.SETFILTER("Posting Date", DateFilter);
                // IF TaxReportLine.FIND('-') THEN
                //     REPEAT
                //         IF var_WHTRegisNo = '' THEN
                //             var_CountVend := var_CountVend + 1
                //         ELSE
                //             IF var_WHTRegisNo = TaxReportLine."WHT Registration No." THEN
                //                 var_CountVend := var_CountVend
                //             ELSE
                //                 var_CountVend := var_CountVend + 1;

                //         var_WHTRegisNo := TaxReportLine."WHT Registration No.";

                //     UNTIL TaxReportLine.NEXT() = 0;

                //##### Option Type ######
                IF Send_Option = Send_Option::"ยื่นปกติ" THEN
                    var_Send_Option[1] := '/'
                ELSE
                    var_Send_Option[2] := '/';

                //##########################################
                IF Send_Type = Send_Type::"3 เตรส" THEN
                    var_Send_Type[1] := '/'
                ELSE
                    IF Send_Type = Send_Type::"65 จัตวา" THEN
                        var_Send_Type[2] := '/'
                    ELSE
                        IF Send_Type = Send_Type::"69 ทวิ" THEN
                            var_Send_Type[3] := '/';
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
                    field(Send_Type; Send_Type)
                    {
                        Caption = 'นำส่งภาษีตาม';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the นำส่งภาษีตาม field.';
                        OptionCaption = '3 เตรส,65 จัตวา,69 ทวิ';
                    }
                    field(Send_Option; Send_Option)
                    {
                        Caption = 'ประเภทการยื่น';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the ประเภทการยื่น field.';
                        OptionCaption = 'ยื่นปกติ,ยื่นเพิ่มเติม';
                    }
                    field(Additional_No; Additional_No)
                    {
                        Caption = 'ครั้งที่';
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the ครั้งที่ field.';
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
    /// <param name="Tempdate">Parameter of type Text[100].</param>
    procedure "SetFilter"(Tempdate: Text)
    begin

        DateFilter := Tempdate;
    end;

    var
        CompanyInformation: Record 79;
        YesrPS: Integer;
        WHTTypeFilter: Option "ภ.ง.ด. 3","ภ.ง.ด. 53","ภ.ง.ด. 54";
        Rec_WHTBusinessPostingGroup: Record "YVS WHT Business Posting Group";
        VAT_ID: array[15] of Text[10];
        var_VATAddress: Text[150];
        Month_No: array[12] of Text[20];
        var_Amount: Decimal;
        var_WHTAmount: Decimal;
        var_WHTTotalAmount: Decimal;
        TaxReportLine: Record "YVS Tax & WHT Line";
        TaxReportLineTemp: Record "YVS Tax & WHT Line" temporary;
        Send_Type: Option "3 เตรส","65 จัตวา","69 ทวิ";
        Send_Option: Option "ยื่นปกติ","ยื่นเพิ่มเติม";
        Additional_No: Integer;
        var_Send_Type: array[3] of Text;
        var_Send_Option: array[2] of Text;
        var_CountVend: Integer;
        var_CompanyName: Text[100];
        DateFilter: Text;
        CurrDocNo: Code[20];
        PageNo, RowsPerPage : Integer;

}

