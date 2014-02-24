{-# LANGUAGE RankNTypes #-}
module HigherRank1 where

foo :: (forall a. [a] -> [a]) -> _
foo x = (x [True, False], x ['a', 'b'])


test :: (([Bool], [Char]), ([Bool], [Char]))
test = (foo reverse, foo tail)
