{-# LANGUAGE PartialTypeSignatures #-}
module BoolToBool where

bar :: _ -> _
bar x = not x

test :: Bool
test = bar True
