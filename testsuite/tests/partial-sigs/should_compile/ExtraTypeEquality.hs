{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE GADTs #-}
module ExtraTypeEquality where

foo :: _ => a -> Bool
foo = id

-- Inferred: (a ~ Bool) => a -> Bool

