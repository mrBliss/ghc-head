{-# LANGUAGE NamedWildcards, ScopedTypeVariables #-}
module WildcardsInPatternAndExprSig where

bar (Just ([x :: _a] :: _) :: Maybe [_a]) (z :: _a) = [x, z] :: [_a]

