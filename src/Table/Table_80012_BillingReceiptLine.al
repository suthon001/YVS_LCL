/// <summary>
/// Table YVS Billing Receipt Line (ID 80012).
/// </summary>
table 80012 "YVS Billing Receipt Line"
{
    Caption = 'Billing Receipt Line';
    Permissions = TableData 21 = rm, TableData 25 = rm;
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Document Type"; Enum "YVS Billing Document Type")
        {
            Caption = 'Document Type';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            Editable = false;

        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(6; "Bill/Pay-to Cust/Vend No."; Code[20])
        {
            Caption = 'Bill/Pay-to Cust/Vend No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Document Type" = FILTER('Sales Billing|Sales Receipt')) Customer."No." ELSE
            IF ("Document Type" = FILTER("Purchase Billing")) Vendor."No.";
            Editable = false;
        }
        field(7; "Source Ledger Entry No."; Integer)
        {
            Caption = 'Source Ledger Entry No.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(8; "Source Document Type"; Enum "Gen. Journal Document Type")
        {

            Editable = false;
            DataClassification = SystemMetadata;
            Caption = 'Source Document Type';

        }
        field(9; "Source Document No."; code[20])
        {
            Caption = 'Source Document No.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(10; "Source Posting Date"; Date)
        {
            Caption = 'Source Posting Date';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(11; "Source Document Date"; Date)
        {
            Caption = 'Source Document Date';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(12; "Source Ext. Document No."; Code[35])
        {
            Caption = 'Source Ext. Document No.';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(13; "Source Due Date"; Date)
        {
            Caption = 'Source Due Date';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(15; "Source Currency Code"; Code[10])
        {
            Caption = 'Source Currency Code';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(16; "Source Amount"; Decimal)
        {
            Caption = 'Source Amount';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(17; "Source Amount (LCY)"; Decimal)
        {
            Caption = 'Source Amount (LCY)';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(18; "Source Description"; text[100])
        {
            Caption = 'Source Description';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(19; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                CustLedger: Record "Cust. Ledger Entry";
                PurchaseBilling: Record "YVS Billing Receipt Line";
                PurchaseBillingHeader: Record "YVS Billing Receipt Header";
                TOtalAmt: Decimal;
            begin
                PurchaseBillingHeader.GET(rec."Document Type", rec."Document No.");
                PurchaseBillingHeader.TestField("Status", PurchaseBillingHeader."Status"::Open);
                if PurchaseBillingHeader."Document Type" = PurchaseBillingHeader."Document Type"::"Sales Receipt" then begin

                    if not CustLedger.GET("Source Ledger Entry No.") then
                        CustLedger.Init();
                    CustLedger.CalcFields("Remaining Amount");

                    PurchaseBilling.reset();
                    PurchaseBilling.SetRange("Document Type", PurchaseBillingHeader."Document Type");
                    PurchaseBilling.SetRange("Document No.", rec."Document No.");
                    PurchaseBilling.SetFilter("Line No.", '<>%1', rec."Line No.");
                    PurchaseBilling.setrange("Source Ledger Entry No.", rec."Source Ledger Entry No.");

                    PurchaseBilling.CalcSums("Amount");

                    TOtalAmt := PurchaseBilling."Amount";

                    PurchaseBilling.reset();
                    PurchaseBilling.SetRange("Document Type", PurchaseBillingHeader."Document Type");
                    PurchaseBilling.SetFilter("Document No.", '<>%1', rec."Document No.");
                    PurchaseBilling.setrange("Source Ledger Entry No.", rec."Source Ledger Entry No.");
                    PurchaseBilling.SetFilter("Status", '<>%1', PurchaseBilling."Status"::"Posted");
                    PurchaseBilling.CalcSums("Amount");
                    TOtalAmt := TOtalAmt + rec."Amount" + PurchaseBilling."Amount";


                    if (ABS(CustLedger."Remaining Amount") - TOtalAmt) < 0 then
                        CustLedger.FieldError("Remaining Amount", strsubstno('remaining amount is %1', ABS(CustLedger."Remaining Amount")));


                    TOtalAmt := 0;
                    PurchaseBilling.reset();
                    PurchaseBilling.SetRange("Document Type", PurchaseBillingHeader."Document Type");
                    PurchaseBilling.SetRange("Document No.", rec."Document No.");
                    PurchaseBilling.SetFilter("Line No.", '<>%1', rec."Line No.");
                    PurchaseBilling.CalcSums("Amount");

                    TOtalAmt := PurchaseBilling.Amount + rec.Amount;

                    PurchaseBillingHeader."Receive & Payment Amount" := TOtalAmt;
                    PurchaseBillingHeader.Modify();

                end;

            end;
        }
        field(20; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            DataClassification = CustomerContent;
        }
        field(21; "Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = CustomerContent;
        }
        field(22; "Source Currency Factor"; Decimal)
        {
            Caption = 'Source Currency Factor';
            Editable = false;
            DataClassification = SystemMetadata;
        }
        field(23; "Status"; Enum "YVS Billing Receipt Status")
        {

            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = lookup("YVS Billing Receipt Header"."Status" where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Editable = false;

        }


    }
    keys
    {
        key("PK"; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        TestOpenStatus();
        CASE "Document Type" OF

            "Document Type"::"Sales Receipt":
                if CustLedgEntry.GET("Source Ledger Entry No.") then begin
                    CustLedgEntry."YVS Completed Receipt" := FALSE;
                    CustLedgEntry.MODIFY();
                end;


        END;
    end;

    trigger OnModify()
    begin
        TestOpenStatus();
    end;


    /// <summary> 
    /// Description for TestOpenStatus.
    /// </summary>
    local procedure TestOpenStatus()
    var
        BillingReceiptHrd: Record "YVS Billing Receipt Header";
    begin
        BillingReceiptHrd.GET("Document Type", "Document No.");
        BillingReceiptHrd.TESTFIELD("Status", BillingReceiptHrd."Status"::Open);
    end;

    /// <summary> 
    /// Description for FindLastLineNo.
    /// </summary>
    /// <returns>Return variable "Integer".</returns>
    procedure "FindLastLineNo"(): Integer
    var
        BillingLines: Record "YVS Billing Receipt Line";
    begin
        BillingLines.reset();
        BillingLines.SetCurrentKey("Document Type", "Document No.", "Line No.");
        BillingLines.SetRange("Document Type", "Document Type");
        BillingLines.SetRange("Document No.", "Document No.");
        if BillingLines.FindLast() then
            exit(BillingLines."Line No." + 10000);
        exit(10000);

    end;

    var
        CustLedgEntry: Record "Cust. Ledger Entry";

}