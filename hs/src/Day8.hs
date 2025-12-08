{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TransformListComp #-}

module Day8 (day8) where

import Control.Monad (foldM, join)
import Control.Monad.ST (runST)
import Data.Function (on)
import Data.IntMap qualified as IntMap (elems, empty, insertWith, size)
import Data.List (sortOn, tails)
import Data.List.NonEmpty (nonEmpty)
import Data.List.NonEmpty qualified as NE (head, zipWith)
import Data.Maybe (mapMaybe)
import Data.Ord (Down (Down))
import Data.Text (Text)
import Data.Text qualified as T (lines, splitOn, unpack)
import Data.Vector.Unboxed.Mutable qualified as MV (generate, read, write)

day8 :: Int -> Text -> (Int, Maybe Int)
day8 n input = runST $ do
  mapping <- MV.generate size id
  let lookupId i = do
        j <- MV.read mapping i
        if i == j
          then pure i
          else do
            k <- lookupId j
            k <$ MV.write mapping i k
      go part1 components m ((i, j) : edges) = do
        a <- lookupId i
        b <- lookupId j
        components' <-
          if a /= b
            then components - 1 <$ MV.write mapping (max a b) (min a b)
            else pure components
        part1' <-
          if m + 1 /= n
            then pure part1
            else do
              let add counts k = do
                    v <- lookupId k
                    pure $ IntMap.insertWith (+) v 1 counts
              counts <- foldM add IntMap.empty [0 .. size - 1]
              pure $ if IntMap.size counts < 3 then 0 else product . take 3 . sortOn Down $ IntMap.elems counts
        if components' == 1
          then pure (part1', Just $ ((*) `on` NE.head . (nodes !!)) i j)
          else go part1' components' (m + 1) edges
      go part1 _ _ _ = pure (part1, Nothing)
  go 0 size 0 $
    [ (i, j)
    | (i, a) : rest <- tails $ zip [0 ..] nodes,
      (j, b) <- rest,
      let d = sum $ join (*) <$> NE.zipWith (-) a b,
      then
        sortOn
      by
        d
    ]
  where
    nodes = mapMaybe (nonEmpty . map (read . T.unpack) . T.splitOn ",") (T.lines input)
    size = length nodes
