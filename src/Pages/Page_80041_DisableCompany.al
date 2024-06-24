/// <summary>
/// Page YVS Disable Company (ID 80041).
/// </summary>
page 80041 "YVS Disable Company"
{
    ApplicationArea = All;
    Caption = 'Disable Thai LCL';
    PageType = List;
    SourceTable = Company;
    UsageCategory = Lists;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(gvDisableLCL; gvDisableLCL)
                {
                    Caption = 'Disable LCL';
                    ToolTip = 'Specifies the value of the Disable LCL field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of a company that has been created in the current database.';
                }
                field("Display Name"; Rec."Display Name")
                {
                    ToolTip = 'Specifies the display name that is defined for the company. If a display name is not defined, then the company name is used.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(DisableLCL)
            {
                Image = ApprovalSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the DisableLCL action.';
                Caption = 'Disable LCL';
                trigger OnAction()
                var
                    ltConmpany: Record Company;
                    CompanyInfomation: Record "Company Information";
                begin
                    ltConmpany.Copy(rec);
                    CurrPage.SetSelectionFilter(ltConmpany);
                    if ltConmpany.FindSet() then
                        repeat
                            CompanyInfomation.ChangeCompany(ltConmpany.Name);
                            CompanyInfomation.GET();
                            CompanyInfomation."YVS Disable LCL" := true;
                            CompanyInfomation.Modify();
                        until ltConmpany.Next() = 0;
                    CurrPage.Update();
                end;
            }
            action(UnDisableLCL)
            {
                Image = ApprovalSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the UnDisableLCL action.';
                Caption = 'UnDisable LCL';
                trigger OnAction()
                var
                    ltConmpany: Record Company;
                    CompanyInfomation: Record "Company Information";
                begin
                    ltConmpany.Copy(rec);
                    CurrPage.SetSelectionFilter(ltConmpany);
                    if ltConmpany.FindSet() then
                        repeat
                            CompanyInfomation.ChangeCompany(ltConmpany.Name);
                            CompanyInfomation.GET();
                            CompanyInfomation."YVS Disable LCL" := false;
                            CompanyInfomation.Modify();
                        until ltConmpany.Next() = 0;
                    CurrPage.Update();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        CompanyInfomation: Record "Company Information";
    begin
        CompanyInfomation.ChangeCompany(CompanyInfomation.Name);
        CompanyInfomation.GET();
        gvDisableLCL := CompanyInfomation."YVS Disable LCL";
    end;

    var
        gvDisableLCL: Boolean;
}
