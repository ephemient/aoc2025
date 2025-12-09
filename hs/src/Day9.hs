{-# LANGUAGE PatternSynonyms #-}

module Day9 (part1, part2) where

import Control.Monad (ap)
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

part1, part2 :: Text -> Int
part1 input =
  foldl'
    max
    0
    [ (abs (x2 - x1) + 1) * (abs (y2 - y1) + 1)
    | (x1, y1) : rest <- tails $ parse input,
      (x2, y2) <- rest
    ]
part2 input =
  foldl'
    max'
    0
    [ ((min x1 x2, min y1 y2), (max x1 x2, max y1 y2))
    | (x1, y1) : rest <- tails input',
      (x2, y2) <- rest
    ]
  where
    input' = parse input
    max' acc ((x1, y1), (x2, y2))
      | acc < area,
        and
          [ max x3 x4 <= min x1 x2 || max x1 x2 <= min x3 x4 || max y3 y4 <= min y1 y2 || max y1 y2 <= min y3 y4
          | ((x3, y3), (x4, y4)) <- zip `ap` (drop 1 . cycle) $ input'
          ] =
          area
      | otherwise = acc
      where
        area = (abs (x2 - x1) + 1) * (abs (y2 - y1) + 1)
