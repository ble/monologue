>module Formatting(rightAlign, numFormat, alphaFormat, formatDates, formatDatePairs, formatDateGivenPrevious) where

>import Data.Time
>import Data.Time.Format
>import Data.Time.Calendar

>import System.Locale

>import Control.Monad.Reader

>import Util(on)

>type NextDateFormatter = Maybe ZonedTime -> ZonedTime -> String
>data DateFormats = DF {
>  diffYear :: String,
>  diffDay :: String,
>  diffHour :: String,
>  diffMin :: String,
>  diffSec :: String,
>  sameTime :: String
>}

>testfmt = DF "%Y %m/%d %T" "%m/%d %T" "%T" "%M:%S" "%S" ""


>crazyFormat :: DateFormats -> NextDateFormatter
>crazyFormat f Nothing t = format (diffYear f) t
>crazyFormat f (Just t') t | not $ sameYear t t' = format (diffYear f) t
>                          | not $ sameDate t t' = format (diffDay f) t
>                          | not $ sameHour t t' = format (diffHour f) t
>                          | not $ sameMin t t'  = format (diffMin f) t
>                          | not $ sameSec t t'  = format (diffSec f) t
>                          | otherwise = sameTime f

>format :: String -> ZonedTime -> String
>format = formatTime defaultTimeLocale

>rightAlign :: Int -> String -> String
>rightAlign n str | m < n = replicate (n-m) ' ' ++ str
>                 | otherwise = str
>  where m = length str

>getTimeOfDay = localTimeOfDay.zonedTimeToLocalTime
>getHour = todHour.getTimeOfDay
>getMin= todMin.getTimeOfDay
>getSecond = round.todSec.getTimeOfDay
>getDate = localDay.zonedTimeToLocalTime
>getYear t = year
>  where (year, _, _) = toGregorian.getDate $ t

>same :: (Eq b) => (a -> b) -> a -> a -> Bool
>same = on (==)


>sameYear = same getYear
>sameDate = same getDate


>sameHour = same getHour
>sameMin= same getMin
>sameSec= same getSecond

>formatDates [] = []
>formatDates (x:xs) = cf Nothing x : helper x xs
> where helper _ [] = []
>       helper y (z:zs) = cf (Just y) z : helper z zs
>       cf = crazyFormat testfmt

>formatDateGivenPrevious last this = crazyFormat testfmt last this

>formatDatePairs _ [] = []
>formatDatePairs f@(t, d, y) ((d1, d2):ds) = 
>  (format (t++d++y) d1, format' d1 d2) : helper d2 ds
>    where format' = formatGivenLast f
>          helper _ [] = []
>          helper w ((z1,z2):zs) = (format' w z1, format' z1 z2):helper z2 zs

>formatGivenLast :: (String, String, String) -> ZonedTime -> ZonedTime -> String
>formatGivenLast (t, d, y) time time' = formatted
>  where withDate = t++d
>        withYear = withDate++y
>        formatStr | sameDate time time' = t
>                  | sameYear time time' = withDate
>                  | otherwise = withYear
>        formatted = format formatStr time'

>numFormat = ("%T", " %m/%d", "/%Y")
>alphaFormat = ("%T", ", %a %b %d", ", %Y")
