{-# LANGUAGE NamedWildcards #-}

module ScopedNamedWildcards where

-- if named wildcards are properly scoped, this should lead to
-- a constraint _a ~ (_a,_)
test2 :: _a -> _a
test2 x = let y :: _a
              y = (x,undefined)
          in y
