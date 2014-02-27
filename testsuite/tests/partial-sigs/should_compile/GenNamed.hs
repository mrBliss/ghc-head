{-# LANGUAGE PartialTypeSignatures #-}
module GenNamed where

bar :: _a -> _a
bar x = not x

test :: Bool
test = bar True
