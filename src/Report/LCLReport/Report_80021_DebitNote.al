/// <summary>
/// Report Debit Note (ID 80021).
/// </summary>
report 80021 "YVS Debit Note"
{
    Caption = 'Debit Note';
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/LCLReport/Report_80021_DebitNote.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = None;
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "Document Type", "No.";
            column(companyInfor_Picture; companyInfor.Picture) { }
            column(PostingDate; format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(DocumentDate; format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(Requested_Delivery_Date; format("Requested Delivery Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(Due_Date; format("Due Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(DocumentNo; "No.") { }
            column(CustText_1; CustText[1]) { }
            column(CustText_2; CustText[2]) { }
            column(CustText_3; CustText[3]) { }
            column(CustText_4; CustText[4]) { }
            column(CustText_5; CustText[5]) { }
            column(CustText_9; CustText[9]) { }
            column(CustText_10; CustText[10]) { }
            column(ExchangeRate; ExchangeRate) { }
            column(ComText_1; ComText[1]) { }
            column(ComText_2; ComText[2]) { }
            column(ComText_3; ComText[3]) { }
            column(ComText_4; ComText[4]) { }
            column(ComText_5; ComText[5]) { }
            column(ComText_6; ComText[6]) { }
            column(CommentText_1; CommentText[1]) { }
            column(CommentText_2; CommentText[2]) { }
            column(CommentText_3; CommentText[3]) { }
            column(CommentText_4; CommentText[4]) { }
            column(CommentText_5; CommentText[5]) { }
            column(Payment_Terms_Code; PaymentTerm.Description) { }
            column(CreateDocBy; "YVS Create By") { }
            column(SplitDate_1; SplitDate[1]) { }
            column(SplitDate_2; SplitDate[2]) { }
            column(SplitDate_3; SplitDate[3]) { }
            column(AmtText; AmtText) { }
            column(TotalAmt_1; TotalAmt[1]) { }
            column(TotalAmt_2; TotalAmt[2]) { }
            column(TotalAmt_3; TotalAmt[3]) { }
            column(TotalAmt_4; TotalAmt[4]) { }
            column(TotalAmt_5; TotalAmt[5]) { }
            column(TotalAmt_99; TotalAmt[99]) { }
            column(TotalAmt_100; TotalAmt[100]) { }
            column(VatText; VatText) { }
            column(Quote_No_; "Quote No.") { }
            column(ShipMethod_Description; ShipMethod.Description) { }
            column(CaptionOptionThai; CaptionOptionThai) { }
            column(CaptionOptionEng; CaptionOptionEng) { }
            column(RefDocumentNo; RefDocumentNo) { }
            column(var_RefDocumentNo; RefDocumentNo) { }
            column(var_RefDocumentDate; format(var_RefDocumentDate, 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(ReturnReasonDescFirstLine; ReturnReasonDescFirstLine) { }
            dataitem(myLoop; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                column(Number; Number) { }
                column(OriginalCaption; OriginalCaption) { }
                dataitem(SalesLine; "Sales Line")
                {
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                    DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                    DataItemLinkReference = SalesHeader;
                    column(SalesLine_No_; "No.") { }
                    column(SalesLine_Description; Description) { }
                    column(SalesLine_Description_2; "Description 2") { }
                    column(SalesLine_Unit_Price; "Unit Price") { }
                    column(Line_Discount__; "Line Discount %") { }
                    column(SalesLine_Line_Amount; "Line Amount") { }
                    column(SalesLine_LineNo; LineNo) { }
                    column(SalesLine_Quantity; Quantity) { }
                    column(SalesLine_Unit_of_Measure_Code; "Unit of Measure Code") { }

                    trigger OnAfterGetRecord()
                    begin
                        If "No." <> '' then
                            LineNo += 1;
                    end;
                }
                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, NoOfCopies + 1);
                end;

                trigger OnAfterGetRecord()
                begin
                    LineNo := 0;
                    if Number = 1 then
                        OriginalCaption := 'Original'
                    else
                        OriginalCaption := 'Copy';
                end;
            }

            trigger OnAfterGetRecord()
            var
                NewDate: Date;
                RecReturnReason: Record "Return Reason";
                RecSaleLine: Record "Sales Line";
            begin
                if "Currency Code" = '' then
                    FunctionCenter."CompanyinformationByVat"(ComText, "VAT Bus. Posting Group", false)
                else
                    FunctionCenter."CompanyinformationByVat"(ComText, "VAT Bus. Posting Group", true);

                FunctionCenter.SalesStatistic("Document Type", "No.", TotalAmt, VatText);
                FunctionCenter.GetSalesComment("Document Type", "No.", 0, CommentText);
                FunctionCenter.SalesInformation("Document Type", "No.", CustText, 0);
                FunctionCenter."ConvExchRate"("Currency Code", "Currency Factor", ExchangeRate);
                IF NOT PaymentTerm.GET(SalesHeader."Payment Terms Code") then
                    PaymentTerm.Init();
                IF NOT ShipMethod.Get("Shipment Method Code") then
                    ShipMethod.Init();
                NewDate := DT2Date("YVS Create DateTime");
                SplitDate[1] := Format(NewDate, 0, '<Day,2>');
                SplitDate[2] := Format(NewDate, 0, '<Month,2>');
                SplitDate[3] := Format(NewDate, 0, '<Year4>');
                if "Currency Code" = '' then
                    AmtText := '(' + FunctionCenter."NumberThaiToText"(TotalAmt[5]) + ')'
                else
                    AmtText := '(' + FunctionCenter."NumberEngToText"(TotalAmt[5], "Currency Code") + ')';



                TotalAmt[100] := "YVS Ref. Tax Invoice Amount";
                TotalAmt[99] := TotalAmt[100] - TotalAmt[1];
                var_RefDocumentDate := "YVS Ref. Tax Invoice Date";
                RefDocumentNo := "YVS Ref. Tax Invoice No.";


                ReturnReasonDescFirstLine := '';
                RecSaleLine.Reset();
                RecSaleLine.SetRange("Document Type", SalesHeader."Document Type");
                RecSaleLine.SetRange("Document No.", SalesHeader."No.");
                RecSaleLine.SetFilter("Return Reason Code", '<>%1', '');
                if RecSaleLine.FindFirst() then begin

                    if NOT RecReturnReason.Get(RecSaleLine."Return Reason Code") then
                        RecReturnReason.init();
                    ReturnReasonDescFirstLine := RecReturnReason.Description;

                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group("Options")
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = all;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies the value of the No. of Copies field.';
                        MinValue = 0;
                    }
                    field(CaptionOptionThai; CaptionOptionThai)
                    {
                        ApplicationArea = all;
                        Caption = 'Caption (Thai)';
                        ToolTip = 'Specifies the value of the Caption field.';
                        trigger OnAssistEdit()
                        var
                            EvenCenter: Codeunit "YVS EventFunction";
                            ltDocumentType: Enum "YVS Document Type Report";
                        begin
                            EvenCenter.SelectCaptionReport(CaptionOptionThai, CaptionOptionEng, ltDocumentType::"Sales Invoice");
                        end;
                    }
                    field(CaptionOptionEng; CaptionOptionEng)
                    {
                        ApplicationArea = all;
                        Caption = 'Caption (Eng)';
                        ToolTip = 'Specifies the value of the Caption field.';
                    }
                }
            }
        }


    }
    trigger OnPreReport()
    begin
        companyInfor.Get();
        companyInfor.CalcFields(Picture);

    end;

    var

        SplitDate: Array[3] of Text[20];

        companyInfor: Record "Company Information";

        PaymentTerm: Record "Payment Terms";

        ShipMethod: Record "Shipment Method";
        var_RefDocumentDate: Date;
        ExchangeRate: Text[30];
        LineNo: Integer;
        RefDocumentNo, var_RefDocumentNo : Code[50];
        CommentText: Array[99] of Text[250];

        FunctionCenter: Codeunit "YVS Function Center";

        TotalAmt: Array[100] of Decimal;
        VatText: Text[30];
        AmtText, ReturnReasonDescFirstLine : Text[250];
        ComText: Array[10] of Text[250];
        CustText: Array[10] of Text[250];

        CaptionOptionEng, CaptionOptionThai, OriginalCaption : Text[50];
        NoOfCopies: Integer;

}
