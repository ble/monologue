>module Input(getEntries, processEntries) where

>import Data.Time.LocalTime(getZonedTime)
>import Entry(Entry, getEntry, entryLine)

>getEntries :: (String -> Bool) -> IO [Entry]
>getEntries pTerm = do
>  e <- getEntry
>  moreEntries <- if pTerm (entryLine e) then return [] else getEntries pTerm
>  return (e:moreEntries)

>processEntries action pred = do
>  e <- getEntry
>  action e
>  if pred (entryLine e)
>    then return []
>    else do
>      es <- processEntries action pred
>      return (e:es)

