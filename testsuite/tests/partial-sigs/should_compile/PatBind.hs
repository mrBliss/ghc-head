{-# LANGUAGE PartialTypeSignatures #-}
module PatBind where

foo :: _
Just foo = Just id

test :: (Bool, Char)
test = (foo True, foo 'x')
