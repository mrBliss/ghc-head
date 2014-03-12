{-# LANGUAGE PartialTypeSignatures, RankNTypes, GADTs #-}
module Demo where

------------------------------------------------------------------------------
--- DEMO: Partial Type Signatures for Haskell
------------------------------------------------------------------------------
-- Thomas Winant, Dominique Devriese, Frank Piessens, and Tom Schrijvers

-- This demo file contains examples of partial type signatures to
-- illustrate their usage, and also to demonstrate the status of their
-- implementation in GHC.


------------------------------------------------------------------------------
--- USAGE
------------------------------------------------------------------------------

-- Try out the different (partial) type signatures for each example in
-- this file, reload with ':r', and verify the type of a definition
-- with ':t def', where 'def' is the name of the definition.

-- Run this file with:
-- $ ./inplace/bin/ghc-stage2 --interactive Demo.hs

------------------------------------------------------------------------------
--- EXAMPLES
------------------------------------------------------------------------------

-- A simple example of a partial type signature in which the wildcards
-- correspond to closed types.

-- bar :: Bool -> Bool
bar :: _ -> _
-- bar :: Bool -> _
-- bar :: _
bar x = not x

------------------------------------------------------------------------------

-- Recall that (Integer, Bool) is the infix notation for ((,) Integer
-- Bool). Using prefix notation, we can replace the type constructor
-- with a wildcard as well.

-- addAndOr :: (Integer, Bool) -> (Bool, Integer) -> (Integer, Bool)
-- addAndOr :: (Integer, Bool) -> (Bool, Integer) -> (_, _)
-- addAndOr :: (Integer, Bool) -> (Bool, Integer) -> (_ Integer Bool)
-- addAndOr :: (Integer, Bool) -> (Bool, Integer) -> _
-- addAndOr :: (Integer, _) -> (Bool, _) -> ((,) _ Bool)
-- addAndOr :: (Integer, _) -> (Bool, _) -> (_ Integer Bool)
-- addAndOr :: (Integer, _) -> (Bool, _) -> ((,) _ _)
addAndOr :: (Integer, _) -> _ -> _
-- addAndOr :: (_, _) -> (_, _) -> (_ _ _)
-- addAndOr :: (_ _ _) -> (_ _ _) -> (_ _ _)
-- addAndOr :: _ -> _ -> _
-- addAndOr :: _ -> _
-- addAndOr :: _
addAndOr (a, b) (c, d) = (a + d, b || c)

------------------------------------------------------------------------------

-- The following example makes use of a higher-rank type, requiring us
-- to annotate it by providing a /full/ type signature. With a partial
-- type signature, we can replace the parts of the type that can be
-- inferred with wildcards.

-- foo :: (forall a. [a] -> [a]) -> ([Bool], [Char])
-- foo :: (forall a. [a] -> [a]) -> ([_], [_])
-- foo :: (forall a. [a] -> [a]) -> (_, _)
-- foo :: (forall a. [a] -> [a]) -> (_, [Char])
foo :: (forall a. [a] -> [a]) -> _
foo x = (x [True, False], x ['a', 'b'])

fooTest = foo tail -- Note that tail :: [a] -> [a]


------------------------------------------------------------------------------

-- Local partial type signatures are implemented, but are not as easy
-- to demonstrate.
v = let f :: _ -> _
        f x = not x
    in f

------------------------------------------------------------------------------

-- In the following definition, generalisation occurs. The resulting type is:
-- "forall a. a -> Bool".

alwaysTrue :: _ -> _
alwaysTrue _ = True

------------------------------------------------------------------------------

-- The following example demonstrates the extra-constraints wildcard,
-- which allows an arbitrary number of constraints to be generated.
-- The constraints (Eq a), (Show a), and (Num a) that are generated
-- while inferring the type, will be added to the type.

showSum :: _ => a -> a -> String
-- showSum :: (Eq a, _) => a -> a -> String
-- showSum :: (Eq a, Show a, Num a, _) => a -> a -> String
showSum x y = if x == y then show x else show (x + y)


------------------------------------------------------------------------------

-- Named wildcards work.

showTwo :: Show _a => _a -> String
showTwo x = show x

------------------------------------------------------------------------------

-- Named wildcards are currently scoped by default.

test :: _a -> _a
test x = let y :: (_a, _a)
             y = (x, x)
         in True && x
