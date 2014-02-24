{-# LANGUAGE TypeFamilies #-}
module EqualityConstraint where

foo :: a ~ Bool => (a, _)
foo = (True, False)

test :: (Bool, Bool)
test = foo
