{-# LANGUAGE PartialTypeSignatures #-}
module Either where

barry :: _a -> (_b _a, _b _)
barry x = (Left "x", Right x)

test :: ((Either [Char] Bool, Either [Char] Bool), (Either [Char] Char, Either [Char] Char))
test = (barry True, barry 'c')
