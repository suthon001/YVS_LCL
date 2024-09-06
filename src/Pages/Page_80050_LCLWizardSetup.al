/// <summary>
/// Page YVS LCL Wizard Setup (ID 80050).
/// </summary>
page 80050 "YVS LCL Wizard Setup"
{
    ApplicationArea = All;
    Caption = 'LCL Wizard Setup';
    PageType = NavigatePage;
    UsageCategory = Administration;
    layout
    {
        area(Content)
        {
            group("TPP Step1")
            {
                Visible = currentstep = 1;
                Editable = true;
                Caption = 'Step1';
                part(NoSeriesWizard; "YVS LCL No. Series Setup")
                {
                    ApplicationArea = all;
                    Caption = 'WHT No.Series Setup Wizard';
                    UpdatePropagation = Both;
                }
            }
            group("TPP Step2")
            {
                Visible = currentstep = 2;
                Editable = true;
                Caption = 'Step2';
                part(WHTGeneralSetupWizard; "YVS General Setup Wizard")
                {
                    ApplicationArea = all;
                    Caption = 'WHT General Setup Wizard';
                    UpdatePropagation = Both;
                }
            }
            group("TPP Step3")
            {
                Visible = currentstep = 3;
                Editable = true;
                Caption = 'Step2';
                part(WHTBussSetupWizard; "YVS WHT Buss Wizard")
                {
                    ApplicationArea = all;
                    Caption = 'WHT Business Posting Group Wizard';
                    UpdatePropagation = Both;
                }
            }

            group("TPP Step4")
            {
                Visible = currentstep = 4;
                Editable = true;
                Caption = 'Step4';
                part(WHTProdPostingGroup; "YVS WHT Prod Wizard")
                {
                    ApplicationArea = all;
                    Caption = 'WHT Product Posting Group Wizard';
                    UpdatePropagation = Both;
                }
            }
            group("TPP Step5")
            {
                Visible = currentstep = 5;
                Editable = true;
                Caption = 'Step5';
                part(WHTPostingSetup; "YVS WHT Posting Setup Wizard")
                {
                    ApplicationArea = all;
                    Caption = 'WHT Posting Setup Wizard';
                    UpdatePropagation = Both;
                }
            }


        }
    }
    actions
    {
        area(Processing)
        {
            action("TPP ActionBack")
            {
                ApplicationArea = all;
                Caption = 'Back';
                Enabled = ActionBackAllowed;
                Image = PreviousRecord;
                InFooterBar = true;
                ToolTip = 'Executes the Back action.';
                trigger OnAction()
                begin
                    TakeStep(-1);
                end;

            }
            action("TPP ActionNext")
            {
                ApplicationArea = all;
                Caption = 'Next';
                Enabled = ActionNextAllowed;
                Image = NextRecord;
                InFooterBar = true;
                ToolTip = 'Executes the Next action.';
                trigger OnAction()
                begin
                    TakeStep(1);
                end;
            }
            action("TPP ActionFinish")
            {
                ApplicationArea = all;
                Caption = 'Finish';
                Enabled = ActionFinishAllowed;
                Image = Approve;
                InFooterBar = true;
                ToolTip = 'Executes the Finish action.';
                trigger OnAction()
                begin
                    InsertWHTSetup();
                    CurrPage.Close();
                end;
            }
        }
    }
    local procedure SetControl()
    begin
        ActionBackAllowed := currentstep > 1;
        ActionNextAllowed := currentstep < 5;
        ActionFinishAllowed := currentstep = 5;
    end;

    local procedure TakeStep(Step: Integer)
    begin
        currentstep := currentstep + Step;
        SetControl();
    end;

    trigger OnOpenPage()
    begin
        currentstep := 1;
        SetControl();
    end;

    local procedure InsertWHTSetup()
    var
        VatProdPostingGroup: Record "VAT Product Posting Group";
    begin
        if not VatProdPostingGroup.Get('DIRECT') then begin
            VatProdPostingGroup.Init();
            VatProdPostingGroup.Code := 'DIRECT';
            VatProdPostingGroup.Description := 'Direct Vat';
            VatProdPostingGroup."YVS Direct VAT" := true;
            VatProdPostingGroup.Insert();
        end else begin
            VatProdPostingGroup."YVS Direct VAT" := true;
            VatProdPostingGroup.Modify();
        end;

        CurrPage.NoSeriesWizard.Page.InserttoRecord();
        CurrPage.WHTGeneralSetupWizard.Page.InserttoRecord();
        CurrPage.WHTBussSetupWizard.Page.InserttoRecord();
        CurrPage.WHTProdPostingGroup.Page.InserttoRecord();
        CurrPage.WHTPostingSetup.Page.InserttoRecord();

    end;

    var
        currentstep: Integer;
        ActionBackAllowed: Boolean;
        ActionNextAllowed: Boolean;
        ActionFinishAllowed: Boolean;
}
