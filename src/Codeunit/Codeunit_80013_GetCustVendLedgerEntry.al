/// <summary>
/// Codeunit YVS Get Cust/Vend Ledger Entry (ID 80013).
/// </summary>
codeunit 80013 "YVS Get Cust/Vend Ledger Entry"
{
    Permissions = TableData "Cust. Ledger Entry" = rm, TableData "Vendor Ledger Entry" = rm;
    TableNo = "YVS Billing Receipt Header";
    trigger OnRun()
    var
        IsHandle: Boolean;
    begin
        IsHandle := false;
        BillingHeader.GET(rec."Document Type", rec."No.");
        YVSOnBeforRunPage(BillingHeader, IsHandle);
        if not IsHandle then begin
            BillingHeader.TESTFIELD("Bill/Pay-to Cust/Vend No.");
            BillingHeader.TestField(Status, BillingHeader.Status::Open);
            CASE BillingHeader."Document Type" OF
                BillingHeader."Document Type"::"Sales Billing", BillingHeader."Document Type"::"Sales Receipt":
                    BEGIN
                        CLEAR(GetCustLedger);
                        GetCustLedger.SetTableData(BillingHeader."Bill/Pay-to Cust/Vend No.", BillingHeader."Document Type", BillingHeader."No.");
                        GetCustLedger.SetDocument(BillingHeader);
                        GetCustLedger.LOOKUPMODE := TRUE;
                        GetCustLedger.RUNMODAL();
                        CLEAR(GetCustLedger);
                    END;
            END;
        end;
        AfterOnRun(BillingHeader);


    end;


    /// <summary> 
    /// Description for SetDocument.
    /// </summary>
    /// <param name="VAR BillingHeader2">Parameter of type Record "Billing  Receipt Header".</param>
    procedure "SetDocument"(VAR BillingHeader2: Record "YVS Billing Receipt Header")
    begin
        BillingHeader.GET(BillingHeader2."Document Type", BillingHeader2."No.");
    end;

    [IntegrationEvent(false, false)]
    local procedure AfterOnRun(BillingHeader: Record "YVS Billing Receipt Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure YVSOnBeforRunPage(VAR BillingHeader2: Record "YVS Billing Receipt Header"; var pIsHandle: Boolean)
    begin
    end;

    var
        BillingHeader: Record "YVS Billing Receipt Header";

        GetCustLedger: Page "YVS Get Cus. Ledger Entry";
}