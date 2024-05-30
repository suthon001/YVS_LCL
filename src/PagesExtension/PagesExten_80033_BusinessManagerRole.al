/// <summary>
/// PageExtension YVS Business Manager Role (ID 80033) extends Record Business Manager Role Center.
/// </summary>
pageextension 80033 "YVS Business Manager Role" extends "Business Manager Role Center"
{
    actions
    {
        addafter("Purchase Quotes")
        {
            action("Purchase Requests")
            {
                ApplicationArea = Suite;
                Caption = 'Purchase Requests';
                RunObject = Page "YVS Purchase Requests";
                ToolTip = 'Create purchase Requests to represent your request for quotes from vendors. Quotes can be converted to purchase orders.';
            }
        }
        addafter("Purchase Quote")
        {
            action("Purchase &Request")
            {
                ApplicationArea = Suite;
                Caption = 'Purchase Request';
                Image = Quote;
                RunObject = Page "YVS Purchase Request Card";
                RunPageMode = Create;
                ToolTip = 'Create a new purchase Request, for example to reflect a request for Request.';
            }
        }
        addfirst(sections)
        {
            group("Localized")
            {
                Caption = 'TH Localized';
                group("WHT Posting Group")
                {
                    Caption = 'VAT & WHT Posting Setup';
                    action("WHT Business Posting Group")
                    {
                        Caption = 'WHT Business Posting Group';
                        ApplicationArea = all;
                        RunObject = page "YVS WHT Business Posting Group";
                        ToolTip = 'Executes the WHT Business Posting Group action.';
                    }
                    action("WHT Product Posting Group")
                    {
                        Caption = 'WHT Product Posting Group';
                        ApplicationArea = all;
                        RunObject = page "YVS WHT Product Posting Group";
                        ToolTip = 'Executes the WHT Product Posting Group action.';
                    }
                    action("WHT Posting Setup")
                    {

                        Caption = 'WHT Posting Setup';
                        ApplicationArea = all;
                        RunObject = page "YVS WHT Posting Setup";
                        ToolTip = 'Executes the WHT Posting Setup action.';
                    }
                    action("VAT Bus. Posting Group")
                    {
                        Caption = 'VAT Business Posting Group';
                        ApplicationArea = all;
                        RunObject = page "VAT Business Posting Groups";
                        ToolTip = 'Executes the VAT Business Posting Group action.';
                    }
                    action("VAT Prod. Posting Group")
                    {
                        Caption = 'VAT Product Posting Group';
                        ApplicationArea = all;
                        RunObject = page "VAT Product Posting Groups";
                        ToolTip = 'Executes the VAT Product Posting Group action.';
                    }
                    action("VAT Posting Setup")
                    {
                        Caption = 'VAT Posting Setup';
                        ApplicationArea = all;
                        RunObject = page "VAT Posting Setup";
                        ToolTip = 'Executes the VAT Posting Setup action.';
                    }
                }
                group("Tax Report")
                {
                    Caption = 'Tax & WHT';
                    action("Sale Vat")
                    {
                        Caption = 'Sale Vat';
                        ApplicationArea = all;
                        RunObject = page "YVS Sales Vat Lists";
                        ToolTip = 'Executes the Sale Vat action.';
                    }
                    action("Purchase Vat")
                    {
                        Caption = 'Purchase Vat';
                        ApplicationArea = all;
                        RunObject = page "YVS Purchase Vat Lists";
                        ToolTip = 'Executes the Purchase Vat action.';
                    }
                    action("WHT Certificate")
                    {
                        Caption = 'WHT Certificate';
                        ApplicationArea = all;
                        RunObject = page "YVS WHT Certificate List";
                        ToolTip = 'Executes the WHT Certificate action.';
                    }
                    action("WHT03")
                    {
                        Caption = 'WHT03';
                        ApplicationArea = all;
                        RunObject = page "YVS WHT Lists";
                        ToolTip = 'Executes the WHT03 action.';
                    }
                    action("WHT53")
                    {
                        Caption = 'WHT53';
                        ApplicationArea = all;
                        RunObject = page "YVS WHT53 Lists";
                        ToolTip = 'Executes the WHT53 action.';
                    }
                    action("VATTransaction")
                    {
                        Caption = 'VAT Transaction';
                        ApplicationArea = all;
                        RunObject = page "YVS Vat Transaction Entries";
                        ToolTip = 'Executes the Vat Transaction action.';
                    }
                    action("WHTTransaction")
                    {
                        Caption = 'WHT Transaction';
                        ApplicationArea = all;
                        RunObject = page "YVS WHT Transaction Entries";
                        ToolTip = 'Executes the WHT Transaction action.';
                    }
                }
                group("Sales Receipt")
                {
                    Caption = 'Sales Receipt';
                    action("Sales Receipt List")
                    {
                        Caption = 'Sales Receipt';
                        ApplicationArea = all;
                        RunObject = page "YVS Sales Receipt List";
                        ToolTip = 'Executes the Sales Receipt action.';
                    }

                }
                group("LCL Report")
                {
                    Caption = 'LCL Report';
                    group("LCL Stock")
                    {
                        Caption = 'Stock Report';
                        action("Stock Card Cost")
                        {
                            Caption = 'Stock Card Cost';
                            ApplicationArea = all;
                            RunObject = report "YVS Report Stock Card Cost";
                            ToolTip = 'Executes the Stock Card Cost action.';
                        }
                        action("Stock Movement")
                        {
                            Caption = 'Stock Movement';
                            ApplicationArea = all;
                            RunObject = report "YVS Stock Movement";
                            ToolTip = 'Executes the Stock Movement action.';
                        }
                        action("Stock On hand")
                        {
                            Caption = 'Stock On hand';
                            ApplicationArea = all;
                            RunObject = report "YVS Stock On hand";
                            ToolTip = 'Executes the Stock On hand action.';
                        }
                    }

                    action("GL Journal Report")
                    {
                        Caption = 'GL Journal Report';
                        ApplicationArea = all;
                        RunObject = report "YVS GL Journal Report";
                        ToolTip = 'Executes the GL Journal Report action.';
                    }


                }
            }


        }

    }
}
