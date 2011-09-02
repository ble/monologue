>module Entry(Entry(..), getEntry, entryLine) where

>import Data.Time(ZonedTime, getZonedTime)

>data Entry = MkEntry {
>  t1 :: !ZonedTime,
>  line :: !String,
>  t2 :: !ZonedTime
>}

>entryLine (MkEntry _ s _ ) = s

>getEntry = do
>  t <- getZonedTime
>  line <- getLine
>  t' <- getZonedTime
>  return $ MkEntry t line t'


