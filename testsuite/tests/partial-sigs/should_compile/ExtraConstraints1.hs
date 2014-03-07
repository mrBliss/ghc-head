{-# LANGUAGE PartialTypeSignatures #-}
module ExtraConstraints1 where

arbitCs1 :: _ => a -> String
arbitCs1 x = show (succ x) ++ show (x == x)

arbitCs2 :: (Show a, _) => a -> String
arbitCs2 = arbitCs1

arbitCs3 :: (Show a, Enum a, _) => a -> String
arbitCs3 = arbitCs1

arbitCs4 :: (Eq a, _) => a -> String
arbitCs4 = arbitCs1

arbitCs5 :: (Eq a, Enum a, Show a, _) => a -> String
arbitCs5 = arbitCs1
