{-# LANGUAGE NamedWildcards #-}
module NamedTyVar where

foo :: (_a, b) -> (a, _b)
foo (x, y) = (x, y)

test :: ((Bool, Char), (Maybe Char, [Bool]))
test = (foo (True, 'x'), foo (Just 'x', [False]))
