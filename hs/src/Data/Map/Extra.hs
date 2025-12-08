{-# LANGUAGE UnboxedTuples #-}

module Data.Map.Extra
  ( spanAntitoneWithElem3,
  )
where

import Data.Map.Internal (Map (Bin, Tip), link)

spanAntitoneWithElem :: (k -> a -> Bool) -> Map k a -> (Map k a, Map k a)
spanAntitoneWithElem p0 m = (l0, r0)
  where
    go _ Tip = (# Tip, Tip #)
    go p (Bin _ kx x l r)
      | p kx x = let (# u, v #) = go p r in (# link kx x l u, v #)
      | otherwise = let (# u, v #) = go p l in (# u, link kx x v r #)
    (# l0, r0 #) = go p0 m

spanAntitoneWithElem3 :: (k -> a -> Ordering) -> Map k a -> (Map k a, Map k a, Map k a)
spanAntitoneWithElem3 p0 m = (l0, m0, r0)
  where
    go _ Tip = (# Tip, Tip, Tip #)
    go p (Bin _ kx x l r) = case p kx x of
      LT -> let (# u, v, w #) = go p r in (# link kx x l u, v, w #)
      EQ ->
        let (t, u) = spanAntitoneWithElem (\ky y -> p ky y == LT) l
            (v, w) = spanAntitoneWithElem (\ky y -> p ky y /= GT) r
         in (# t, link kx x u v, w #)
      GT -> let (# u, v, w #) = go p l in (# u, v, link kx x w r #)
    (# l0, m0, r0 #) = go p0 m
