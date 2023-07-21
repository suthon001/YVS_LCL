/// <summary>
/// PageExtension YVS GenjournalTemplate (ID 80084) extends Record General Journal Templates.
/// </summary>
pageextension 80084 "YVS GenjournalTemplate" extends "General Journal Templates"
{
    layout
    {
        addafter(Description)
        {
            field("Description Eng"; rec."YVS Description Eng")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Description Eng field.';
            }
            field("Description Thai"; rec."YVS Description Thai")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Description Thai field.';
            }

        }
    }
}