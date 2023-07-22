/// <summary>
/// Codeunit YVS Get Cust/Vend Ledger Entry (ID 80013).
/// </summary>
codeunit 80013 "YVS Get Cust/Vend Ledger Entry"
{
    Permissions = TableData "Cust. Ledger Entry" = rm, TableData "Vendor Ledger Entry" = rm;
    TableNo = "YVS Billing Receipt Header";
    trigger OnRun()
    begin
        BillingHeader.GET(rec."Document Type", rec."No.");
        BillingHeader.TESTFIELD("Bill/Pay-to Cust/Vend No.");
        BillingHeader.TestField(Status, BillingHeader.Status::Open);
        CASE BillingHeader."Document Type" OF
            BillingHeader."Document Type"::"Sales Receipt":
                BEGIN
                    CLEAR(GetCustLedger);
                    GetCustLedger.SetTableData(BillingHeader."Bill/Pay-to Cust/Vend No.", BillingHeader."Document Type", BillingHeader."No.");
                    GetCustLedger.LOOKUPMODE := TRUE;
                    GetCustLedger.RUNMODAL();
                    CLEAR(GetCustLedger);
                END;

        END;

    end;

    /// <summary> 
    /// Description for SetDocument.
    /// </summary>
    /// <param name="VAR BillingHeader2">Parameter of type Record "Billing  Receipt Header".</param>
    procedure "SetDocument"(VAR BillingHeader2: Record "YVS Billing Receipt Header")
    begin
        BillingHeader.GET(BillingHeader2."Document Type", BillingHeader2."No.");
    end;

    var
        BillingHeader: Record "YVS Billing Receipt Header";

        GetCustLedger: Page "YVS Get Cus. Ledger Entry";
}