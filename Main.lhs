>import Control.Monad(when, unless)

>import System(getArgs)
>import System.Directory(doesFileExist)
>import System.Exit(exitFailure)

>import Data.List(isPrefixOf)

>import Database.HDBC(commit)

>import Database
>import Formatting
>import Entry
>import Input

>data Action = Action {
>  name :: String,
>  argValid :: [String] -> Bool,
>  run :: [String] -> IO (),
>  usage :: String
>}

>main = do
>  args <- getArgs
>  if null args
>    then
>      explainArgs
>    else
>      chooseAction (head args) $ (tail args)

>chooseAction :: String -> [String] -> IO ()
>chooseAction mode args = do
>  case applicable of
>    []        -> explainArgs
>    action:[] -> if (argValid action $ args) then run action $ args
>                                             else explain action
>    _         -> explainMany applicable
> where applicable = filter ((mode `isPrefixOf`).name) actions

>actions = [aMake, aRead, aAdd] :: [Action]
>explain = undefined :: Action -> IO ()
>explainMany = undefined :: [Action] -> IO ()
>explainArgs = explainMany actions

>aMake = Action "make" ((== 1).length) doMake "make file"
>doMake (file:[]) = do
>   exists <- doesFileExist file
>   when exists alreadyExists
>   conn <- loadDatabase file
>   buildTable conn
>   commit conn
>   insert <- makeSaveEntryAction conn
>   processEntries insert (== ".")
>   return ()
> where alreadyExists = do
>          putStrLn $ file ++ " already exists."
>          exitFailure

>aAdd = Action "addto" ((== 1).length) doAdd "addto file"
>doAdd (file:[]) = do
>  exists <- doesFileExist file
>  unless exists noFile
>  conn <- loadDatabase file
>  insert <- makeSaveEntryAction conn
>  processEntries insert (== ".")
>  return ()
> where noFile = do
>          putStrLn $ file ++ " doesn't exist."
>          exitFailure

>aRead = Action "read" (not.null) doRead "read file1 [file2 file3 ...]"
>doRead = mapM_ readOne

>readOne file = do
>    putStrLn $ replicate 80 '='
>    putStrLn file
>    putStrLn $ replicate 80 '='
>    conn <- loadDatabase file
>    select <- makeSelectEntriesAction conn
>    entries <- select
>    mapM_ putStrLn $ formatEntries entries

>formatEntries [] = []
>formatEntries (e:es) = (formatDate Nothing (t1 e) ++ " " ++ line e) : formatEntries' e es
>formatEntries' _ [] = []
>formatEntries' x (e:es) = (formatDate (Just$t1 x) (t1 e) ++ " " ++ line e) : formatEntries' e es

>formatDate prev this = (rightAlign 19) $ formatDateGivenPrevious prev this


