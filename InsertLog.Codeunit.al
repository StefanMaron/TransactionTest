codeunit 50100 InsertLog
{
    TableNo = LogTable;

    trigger OnRun()
    begin
        Rec.InsertLog('Codeunit 50100 InsertLog');
    end;
}
codeunit 50101 DelegateInsert
{
    TableNo = LogTable;

    trigger OnRun()
    begin
        Rec.Insert();
    end;
}