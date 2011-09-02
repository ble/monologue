>module TestDates(testDates) where

>import Data.Time

>addTime :: ZonedTime -> NominalDiffTime -> ZonedTime
>addTime t delta = utcToZonedTime zone t'
>  where zone = zonedTimeZone t
>        t' = addUTCTime delta $ zonedTimeToUTC t

>times :: [NominalDiffTime]
>times = scanl1 (*) [60, 60, 24, 365]

>[minute, hour, day, year] = times
>month' = 30 * day

>testDates :: IO [ZonedTime]
>testDates = do
>  now <- getZonedTime
>  let times = [-3 * year, -1 * year, -1 * month', -1 * day, -12*hour, -2*hour, -30*minute, 0] in
>    return $ map (addTime now) times  
