{-# LANGUAGE PatternSynonyms #-}

module Day9 (part1, part2) where

import Control.Monad (ap)
import Data.IntMap qualified as IntMap (dropWhileAntitone, empty, insertWith, takeWhileAntitone)
import Data.List (tails)
import Data.Text (Text)
import Data.Text qualified as T (lines, pattern Empty, pattern (:<))
import Data.Text.Read qualified as T (decimal)

parse :: Text -> [(Int, Int)]
parse input =
  [ (x, y)
  | line <- T.lines input,
    (x, ',' T.:< line') <- either (const mempty) pure $ T.decimal line,
    (y, T.Empty) <- either (const mempty) pure $ T.decimal line'
  ]

area :: (Num a) => (a, a) -> (a, a) -> a
area (x1, y1) (x2, y2) = (abs (x1 - x2) + 1) * (abs (y1 - y2) + 1)

part1, part2 :: Text -> Int
part1 input = foldl' max 0 [area a b | a : rest <- tails $ parse input, b <- rest]
part2 input = foldl' max' 0 [(a, b) | a : rest <- tails input', b <- rest]
  where
    input' = parse input
    (xs, ys) = foldl' go (IntMap.empty, IntMap.empty) $ zip `ap` (drop 1 . cycle) $ input'
    go (xs', ys') ((x1, y1), (x2, y2)) =
      ( if x1 == x2 then IntMap.insertWith (<>) x1 [(min y1 y2, max y1 y2)] xs' else xs',
        if y1 == y2 then IntMap.insertWith (<>) y1 [(min x1 x2, max x1 x2)] ys' else ys'
      )
    max' acc (a@(x1, y1), b@(x2, y2))
      | acc < area',
        and
          [ max y1 y2 <= min y3 y4 || max y3 y4 <= min y1 y2
          | (y3, y4) <- concat $ IntMap.dropWhileAntitone (<= min x1 x2) $ IntMap.takeWhileAntitone (< max x1 x2) xs
          ],
        and
          [ max x1 x2 <= min x3 x4 || max x3 x4 <= min x1 x2
          | (x3, x4) <- concat $ IntMap.dropWhileAntitone (<= min y1 y2) $ IntMap.takeWhileAntitone (< max y1 y2) ys
          ] =
          area'
      | otherwise = acc
      where
        area' = area a b
