{-# LANGUAGE NamedWildcards #-}

module ScopedNamedWildcards where

test2 :: _a -> _a
test2 x = let y :: _a
              y = (x,undefined)
          in y
