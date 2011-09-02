>module Util(on) where

>on :: (a -> a -> b) -> (c -> a) -> (c -> c-> b)
>(g `on` f) x y = g (f x) (f y)
