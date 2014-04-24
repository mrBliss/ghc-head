{-# LANGUAGE NamedWildcards, ScopedTypeVariables #-}
module TidyClash2 where

barry :: forall tw_. _ -> _ -> tw_
barry (x :: _) (y :: _) = undefined :: _

