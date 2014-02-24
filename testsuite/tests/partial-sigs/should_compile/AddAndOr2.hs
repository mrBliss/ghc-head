module AddAndOr2 where

addAndOr2 :: _ -> _
addAndOr2 (a, b) (c, d) = (a `plus` d, b || c)
  where plus :: Int -> Int -> Int
        x `plus` y = x + y

test :: (Int, Bool)
test = (3, True) `addAndOr2` (False, 4)
