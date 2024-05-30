/// <summary>
/// TableExtension YVS FixedAsset (ID 80044) extends Record Fixed Asset.
/// </summary>
tableextension 80044 "YVS FixedAsset" extends "Fixed Asset"
{
    fields
    {

        modify("FA Subclass Code")
        {
            trigger OnAfterValidate()
            var
                FASubclass: Record "FA Subclass";
                FuncenterYVS: Codeunit "YVS Function Center";
            begin
                if not FuncenterYVS.CheckDisableLCL() then
                    exit;
                if FASubclass.get("FA Subclass Code") then
                    IF FASubclass."Default FA Posting Group" <> '' THEN
                        VALIDATE("FA Posting Group", FASubclass."Default FA Posting Group");
            end;
        }
    }
}