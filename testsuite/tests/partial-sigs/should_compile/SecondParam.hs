{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
module SecondParam where

class Two a b | a -> b where
  one :: a -> a
  two :: b -> b

-- Ignore the second parameter of the typeclass
secondParam :: Two a _ => a -> a
secondParam x = one x
-- Should be inferred: forall a b. Two a b -> a -> a

instance Two Char Bool where
  one = id
  two = id

test :: Char
test = secondParam 'x'
