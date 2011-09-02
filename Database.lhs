>module Database where

>import Database.HDBC
>import Database.HDBC.Sqlite3

>import Entry(Entry(MkEntry))


>loadDatabase = connectSqlite3

>buildTable conn = run conn "CREATE TABLE picoblog (key INTEGER PRIMARY KEY, t1 TEXT, line TEXT, t2 TEXT)" []

>makeSaveEntryAction conn = do
>  statement <- prepare conn "INSERT INTO picoblog (t1, line, t2) VALUES (?, ?, ?)"
>  return $ \(MkEntry t1 line t2) -> do
>    execute statement [toSql t1, toSql line, toSql t2]
>    commit conn

>makeSelectEntriesAction conn = do
>  statement <- prepare conn "SELECT t1, line, t2 FROM picoblog"
>  return $ do
>    execute statement [];
>    rows <- fetchAllRows statement
>    return $ map entryFromRow rows
> where entryFromRow [t1, line, t2] = MkEntry (fromSql t1) (fromSql line) (fromSql t2)
