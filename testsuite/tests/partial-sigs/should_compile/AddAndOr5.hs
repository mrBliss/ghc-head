{-# LANGUAGE PartialTypeSignatures #-}
module AddAndOr5 where

addAndOr5 :: (_, _) -> (_, _) -> (_, _)
addAndOr5 (a, b) (c, d) = (a `plus` d, b || c)
  where plus :: Int -> Int -> Int
        x `plus` y = x + y

test :: (Int, Bool)
test = (3, True) `addAndOr5` (False, 4)
