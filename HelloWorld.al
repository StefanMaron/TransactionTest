table 50100 LogTable
{
    DataClassification = SystemMetadata;


    fields
    {
        field(1; EntryNo; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Message; Text[250]) { }
    }

    keys
    {
        key(Key1; EntryNo)
        {
            Clustered = true;
        }
    }

    procedure InsertLog(MessageIn: Text[250])
    var
        LogTable: Record LogTable;
    begin
        LogTable.Init();
        LogTable.Message := MessageIn;
        LogTable.Insert(false);
    end;
}

page 50100 LogList
{
    ApplicationArea = All;
    PageType = List;
    SourceTable = LogTable;
    SourceTableView = order(descending);
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Main)
            {
                field(EntryNo; Rec.EntryNo)
                {
                }
                field(Message; Rec.Message)
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(BaseTransaction)
            {

                trigger OnAction()
                begin
                    Rec.InsertLog('Base Transaction without Error');
                end;
            }
            action(BaseTransactionWithError)
            {

                trigger OnAction()
                begin
                    Rec.InsertLog('Base Transaction with Error');
                    Error('Error in Base Transaction');
                end;
            }
            action(BaseTransactionWithCommitAndError)
            {

                trigger OnAction()
                begin
                    Rec.InsertLog('Base Transaction with Commit and Error');
                    Commit();
                    Error('Error in Base Transaction');
                end;
            }
            action(CodeunitRun)
            {

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::InsertLog);
                end;
            }
            action(CodeunitRunWithError)
            {

                trigger OnAction()
                begin
                    Codeunit.Run(Codeunit::InsertLog);
                    Error('Error after Codeunit Run');
                end;
            }
            action(IfCodeunitRun)
            {

                trigger OnAction()
                begin
                    if Codeunit.Run(Codeunit::InsertLog) then
;
                end;
            }
            action(IfCodeunitRunWithError)
            {

                trigger OnAction()
                begin
                    if Codeunit.Run(Codeunit::InsertLog) then
;
                    Error('Error after Codeunit Run');
                end;
            }

            action(IfCodeunitRunInWriteTransaction)
            {

                trigger OnAction()
                begin
                    Rec.InsertLog('Before Codeunit Run');
                    if Codeunit.Run(Codeunit::InsertLog) then
;
                end;
            }
            action(BasicWithCommitBehaviorIgnore)
            {

                trigger OnAction()
                begin
                    IgnoreCommits();
                end;
            }
            action(BasicWithCommitBehaviorError)
            {

                trigger OnAction()
                begin
                    ErrorOnCommits();
                end;
            }
            action(IfCodeunitRunWithCommitBehaviorIgnore)
            {

                trigger OnAction()
                begin
                    IgnoreCommitsIfCodeunitRun();
                end;
            }
            action(IfCodeunitRunBasicWithCommitBehaviorError)
            {

                trigger OnAction()
                begin
                    ErrorOnCommitsIfCodeunitRun();
                end;
            }
            action(DoubleCodeunitRun)
            {
                trigger OnAction()
                var
                    Ok: Boolean;
                begin
                    Ok := Codeunit.Run(Codeunit::InsertLog);
                    Ok := Codeunit.Run(Codeunit::InsertLog);
                end;
            }
            action(DelateInsert)
            {
                trigger OnAction()
                var
                    Ok: Boolean;
                begin
                    Rec.EntryNo := 0;
                    Rec.Message := 'Delegated Insert';
                    Ok := Codeunit.Run(Codeunit::DelegateInsert, Rec);

                    Rec.EntryNo := 0;
                    Rec.Message := 'Delegated Insert 2';
                    Ok := Codeunit.Run(Codeunit::DelegateInsert, Rec);

                end;
            }
            action(TryFunction)
            {
                trigger OnAction()
                var
                    Ok: Boolean;
                begin
                    Ok := FancyInsertMethod();
                end;
            }
            action(TryFunctionWithLogInsert)
            {
                trigger OnAction()
                var
                    Ok: Boolean;
                begin
                    Ok := FancyInsertMethodWithLogInsert();
                    Error('Error after Try function');
                end;
            }
            action(TransactionTest)
            {
                trigger OnAction()
                begin
                    Message('Is write Transaction: %1', IsInWriteTransaction());
                    Message('Current Transaction type: %1', CurrentTransactionType);
                end;
            }
            action(TransactionTypeBrowse)
            {
                trigger OnAction()
                begin
                    CurrentTransactionType(TransactionType::Browse);
                    Rec.InsertLog('After setting transaction type to Browse');
                end;
            }
            action(TransactionTypeSnapshot)
            {
                trigger OnAction()
                begin
                    CurrentTransactionType(TransactionType::Snapshot);
                    Rec.InsertLog('After setting transaction type to Snapshot');
                end;
            }


        }
        area(Promoted)
        {
            // actionref(Test1_promoted; BaseTransaction) { }
            // actionref(Test2_promoted; BaseTransactionWithError) { }
            // actionref(Test3_promoted; BaseTransactionWithCommitAndError) { }
            // actionref(Test4_promoted; CodeunitRun) { }
            // actionref(Test5_promoted; CodeunitRunWithError) { }
            // actionref(Test6_promoted; IfCodeunitRun) { }
            // actionref(Test7_promoted; IfCodeunitRunWithError) { }
            // actionref(Test8_promoted; IfCodeunitRunInWriteTransaction) { }
            // actionref(Test9_promoted; BasicWithCommitBehaviorIgnore) { }
            // actionref(Test10_promoted; BasicWithCommitBehaviorError) { }
            // actionref(Test11_promoted; IfCodeunitRunWithCommitBehaviorIgnore) { }
            // actionref(Test12_promoted; IfCodeunitRunBasicWithCommitBehaviorError) { }
            // actionref(Test13_promoted; DoubleCodeunitRun) { }
            // actionref(Test14_promoted; DelateInsert) { }
            // actionref(Test15_promoted; TryFunction) { }
            // actionref(Test16_promoted; TryFunctionWithLogInsert) { }
            // actionref(Test17_promoted; TransactionTest) { }
            actionref(Test18_promoted; TransactionTypeBrowse) { }
            actionref(Test19_promoted; TransactionTypeSnapshot) { }
        }


    }

    [CommitBehavior(CommitBehavior::Ignore)]
    procedure IgnoreCommits()
    begin
        Rec.InsertLog('Before Commit');
        Commit();
        Error('Error after Commit');
    end;

    [CommitBehavior(CommitBehavior::Error)]
    procedure ErrorOnCommits()
    begin
        Rec.InsertLog('Before Commit');
        Commit();
        Error('Error after Commit');
    end;


    [CommitBehavior(CommitBehavior::Ignore)]
    procedure IgnoreCommitsIfCodeunitRun()
    var
        Ok: Boolean;
    begin
        Ok := Codeunit.Run(Codeunit::InsertLog);
        Error('Error after Commit');
    end;

    [CommitBehavior(CommitBehavior::Error)]
    procedure ErrorOnCommitsIfCodeunitRun()
    var
        Ok: Boolean;
    begin
        Ok := Codeunit.Run(Codeunit::InsertLog);
        Error('Error after Commit');
    end;

    [CommitBehavior(CommitBehavior::Error)]
    procedure SecureImport()
    var
        Ok: Boolean;
    begin
        Rec.InsertLog('Just to start the write transaction');
        // Do some logic
        // Call 3rd party code
        Commit();
        Ok := Codeunit.Run(Codeunit::InsertLog);

        //If we encounter an error
        Error('Something went wrong');
    end;

    [TryFunction]
    procedure FancyInsertMethod()
    begin
        Error('Error in Fancy Insert Method');
    end;

    [TryFunction]
    procedure FancyInsertMethodWithLogInsert()
    begin
        Rec.InsertLog('Inside Try function');
    end;

}