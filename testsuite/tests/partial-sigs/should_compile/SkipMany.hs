module SkipMany where

data GenParser tok st a = GenParser tok st a

skipMany' :: GenParser tok st a -> GenParser tok st ()
skipMany' = undefined

skipMany :: _ -> _ ()
skipMany = skipMany'

test :: GenParser tok st a -> GenParser tok st ()
test = skipMany

test2 :: GenParser foo bar bie -> GenParser foo bar ()
test2 = skipMany
