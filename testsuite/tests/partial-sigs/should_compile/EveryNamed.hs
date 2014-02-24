{-# LANGUAGE NamedWildcards #-}
module EveryNamed where

every :: (_a -> Bool) -> [_a] -> Bool
every _ [] = True
every p (x:xs) = p x && every p xs

test :: (Bool, Bool)
test = (every testChar "Foo", every testBool [True, False, True])
  where testChar :: Char -> Bool
        testChar = undefined
        testBool :: Bool -> Bool
        testBool = undefined
