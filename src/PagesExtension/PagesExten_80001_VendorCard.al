/// <summary>
/// PageExtension ExtenVendor Card (ID 80001) extends Record Vendor Card.
/// </summary>
pageextension 80001 "YVS ExtenVendor Card" extends "Vendor Card"
{

    layout
    {
        addlast(General)
        {

            field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
            }
            field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
            }
            field("WHT Business Posting Group"; rec."YVS WHT Business Posting Group")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the WHT Business Posting Group field.';
                ShowMandatory = true;
            }
            field("Head Office"; rec."YVS Head Office")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Head Office field.';
            }
            field("VAT Branch Code"; rec."YVS VAT Branch Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the VAT Branch Code field.';
            }
        }
        moveafter("VAT Branch Code"; "VAT Registration No.")
        modify("Currency Code")
        {
            Visible = true;
        }
        modify("No.")
        {
            Visible = true;
            Importance = Promoted;
        }
        addafter(General)
        {
            group(WHTInfor)
            {
                Caption = 'WHT Information';
                field("YVS WHT Title Name"; rec."YVS WHT Title Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the คำนำหน้า field.';
                }
                field("YVS WHT Name"; rec."YVS WHT Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ชื่อ field.';
                }
                field("YVS WHT Building"; rec."YVS WHT Building")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ชื่ออาคาร/หมู่บ้าน field.';
                }
                field("YVS WHT House No."; rec."YVS WHT House No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the เลขที่ห้อง field.';
                }
                field("YVS WHT Village No."; rec."YVS WHT Village No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the หมู่ที่ field.';
                }
                field("YVS WHT Floor"; rec."YVS WHT Floor")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ชั้น field.';
                }
                field("YVS WHT No."; rec."YVS WHT No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the เลขที่ field.';
                }
                field("YVS WHT Street"; rec."YVS WHT Street")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ถนน field.';
                }
                field("YVS WHT Alley/Lane"; rec."YVS WHT Alley/Lane")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ตรอก/ซอย field.';
                }
                field("YVS WHT Sub-district"; rec."YVS WHT Sub-district")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ตำบล/แขวง field.';
                }
                field("YVS WHT District"; rec."YVS WHT District")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the อำเภอ/เขต field.';
                }
                field("YVS WHT Province"; rec."YVS WHT Province")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the จังหวัด field.';
                }
                field("YVS WHT Post Code"; rec."YVS WHT Post Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the รหัสไปรษณีย์ field.';
                }

            }
        }
    }

}