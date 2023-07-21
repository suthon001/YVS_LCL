/// <summary>
/// PageExtension FixedassetCard (ID 80080) extends Record Fixed Asset Card.
/// </summary>
pageextension 80080 "YVS FixedassetCard" extends "Fixed Asset Card"
{

    trigger OnAfterGetRecord()
    begin
        "YVS LoadDepreciationBooks"();
        "YVS FADepreciationBook".COPY("YVS FADepreciationBookOld");
    end;
    /// <summary>
    /// YVS LoadDepreciationBooks.
    /// </summary>
    procedure "YVS LoadDepreciationBooks"()
    begin
        CLEAR("YVS FADepreciationBookOld");
        "YVS FADepreciationBookOld".SETRANGE("FA No.", Rec."No.");
        IF "YVS FADepreciationBookOld".COUNT <= 1 THEN
            IF "YVS FADepreciationBookOld".FINDFIRST() THEN
                "YVS FADepreciationBookOld".CALCFIELDS("Book Value");
    end;

    var
        "YVS FADepreciationBookOld", "YVS FADepreciationBook" : Record "FA Depreciation Book";
}