{-# LANGUAGE PartialTypeSignatures #-}
module Every where

every :: _ -> _ -> Bool
every _ [] = True
every p (x:xs) = p x && every p xs

test :: (Bool, Bool)
test = (every testChar "Foo", every testBool [True, False, True])
  where testChar :: Char -> Bool
        testChar = undefined
        testBool :: Bool -> Bool
        testBool = undefined
