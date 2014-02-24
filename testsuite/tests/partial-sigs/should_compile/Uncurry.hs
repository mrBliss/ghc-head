module Uncurry where

unc :: (_ -> _ -> _) -> (_, _) -> _
unc = uncurry


foo :: Char -> Bool -> Int
foo = undefined

test :: ([Bool], Int, (Bool, Char))
test = (unc (:) (True, []), unc foo ('c', True), unc (,) (True, 'c'))
