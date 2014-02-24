{-# LANGUAGE NamedWildcards #-}
module UncurryNamed where

unc :: (_a -> _b -> _c) -> (_a, _b) -> _c
unc = uncurry

foo :: Char -> Bool -> Int
foo = undefined

test :: ([Bool], Int, (Bool, Char))
test = (unc (:) (True, []), unc foo ('c', True), unc (,) (True, 'c'))
