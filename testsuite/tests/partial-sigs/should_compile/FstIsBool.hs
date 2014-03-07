{-# LANGUAGE PartialTypeSignatures, GADTs #-}
module FstIsBool where

fstIsBool :: (Bool, _) ~ a => a -> Bool
fstIsBool (b1, b2) = not b1 && b2

test :: Bool
test = fstIsBool (True, False)
