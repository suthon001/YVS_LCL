/// <summary>
/// Page YVS WHT Certificate Subform (ID 80009).
/// </summary>
page 80009 "YVS WHT Certificate Subform"
{
    PageType = ListPart;
    SourceTable = "YVS WHT Line";
    MultipleNewLines = false;
    AutoSplitKey = true;
    RefreshOnActivate = true;
    Caption = 'WHT Certificate Subform';
    layout
    {
        area(content)
        {
            repeater("Group")
            {
                Caption = 'Lines';
                field("WHT Product Posting Group"; Rec."WHT Product Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Product Posting Group field.';
                    trigger OnValidate()
                    begin
                        UpdateName();
                        CurrPage.Update();
                    end;
                }
                field(WHTPostingName; WHTPostingName)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Product Posting Group field.';
                    Editable = false;
                    Caption = 'Description';
                }
                field("WHT %"; Rec."WHT %")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT % field.';
                }
                field("WHT Base"; Rec."WHT Base")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Base field.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("WHT Amount"; Rec."WHT Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the WHT Amount field.';
                }

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        UpdateName();
    end;

    local procedure UpdateName()
    begin
        if not WHTPostingGroup.GET(rec."WHT Product Posting Group") then
            WHTPostingGroup.init();

        WHTPostingName := WHTPostingGroup.Description;
        AfterShowDescription(WHTPostingName, WHTPostingGroup, rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure AfterShowDescription(var pWHTDescription: Text; pWHTPostingGroup: Record "YVS WHT Product Posting Group"; pwhtLine: Record "YVS WHT Line")
    begin
    end;

    var

        WHTPostingGroup: Record "YVS WHT Product Posting Group";
        WHTPostingName: Text;

}