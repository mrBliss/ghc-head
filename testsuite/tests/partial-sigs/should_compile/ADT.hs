module ADT where

data Foo x y z = Foo x y z

bar :: Int -> _ Int
bar x = Foo True () x

test :: Foo Bool () Int
test = bar 3
