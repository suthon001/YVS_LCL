/// <summary>
/// Report YVS Inventory - List (ID 80089).
/// </summary>
report 80089 "YVS Inventory - List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LayoutReport/StandardReport/Report_80089_InventoryList.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'Inventory - List';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = WHERE(Type = CONST(Inventory));
            RequestFilterFields = "No.", "Search Description", "Assembly BOM", "Inventory Posting Group", "Shelf No.", "Statistics Group";
            column(CompanyName; COMPANYPROPERTY.DisplayName())
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(No_Item; "No.")
            {
                IncludeCaption = true;
            }
            column(Description_Item; Description)
            {
                IncludeCaption = true;
            }
            column(AssemblyBOM_Item; Format("Assembly BOM"))
            {
            }
            column(BaseUnitofMeasure_Item; "Base Unit of Measure")
            {
                IncludeCaption = true;
            }
            column(InventoryPostingGrp_Item; "Inventory Posting Group")
            {
                IncludeCaption = true;
            }
            column(ShelfNo_Item; "Shelf No.")
            {
                IncludeCaption = true;
            }
            column(VendorItemNo_Item; "Vendor Item No.")
            {
                IncludeCaption = true;
            }
            column(LeadTimeCalculation_Item; "Lead Time Calculation")
            {
                IncludeCaption = true;
            }
            column(ReorderPoint_Item; "Reorder Point")
            {
                IncludeCaption = true;
            }
            column(AlternativeItemNo_Item; "Alternative Item No.")
            {
                IncludeCaption = true;
            }
            column(Blocked_Item; Format(Blocked))
            {
            }
            column(InventoryListCaption; InventoryListCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(ItemAssemblyBOMCaption; ItemAssemblyBOMCaptionLbl)
            {
            }
            column(ItemBlockedCaption; ItemBlockedCaptionLbl)
            {
            }
        }
    }

    trigger OnPreReport()
    begin
        ItemFilter := Item.GetFilters();
    end;

    var
        ItemFilter: Text;
        InventoryListCaptionLbl: Label 'Inventory - List';
        CurrReportPageNoCaptionLbl: Label 'Page';
        ItemAssemblyBOMCaptionLbl: Label 'BOM';
        ItemBlockedCaptionLbl: Label 'Blocked';
}

