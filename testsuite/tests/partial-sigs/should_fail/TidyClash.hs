module TidyClash where

-- Type variables originating from wildcards are normally given the
-- name tw_, but in this case there is already a type variable called
-- tw_. Tidying the types should result in tw_1 and tw_2 for the two
-- new type variables originating from the wildcards.

bar :: tw_ -> (tw_, _ -> _)
bar x = (x, \y -> undefined)
