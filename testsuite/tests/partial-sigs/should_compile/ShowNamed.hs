{-# LANGUAGE NamedWildcards #-}
module ShowNamed where
       
showTwo :: Show _a => _a -> String
showTwo x = show x


test :: (String, String)
test = (show True, show 'c')
