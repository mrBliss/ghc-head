module AddAndOr6 where

addAndOr6 :: (Int, _) -> (Bool, _) -> (_ Int Bool)
addAndOr6 (a, b) (c, d) = (a `plus` d, b || c)
  where plus :: Int -> Int -> Int
        x `plus` y = x + y

test :: (Int, Bool)
test = (3, True) `addAndOr6` (False, 4)
