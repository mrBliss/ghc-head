{-# LANGUAGE PartialTypeSignatures, ScopedTypeVariables #-}
module Forall1 where

fall :: forall a. _ -> a
fall v = v

test :: (Char, Bool)
test = (fall 'c', fall True)
