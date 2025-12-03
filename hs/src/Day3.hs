module Day3 (day3) where

import Data.List (minimumBy)
import Data.Ord (Down (Down), comparing)
import Data.Text (Text)
import Data.Text qualified as T (drop, index, length, lines)

day3 :: Int -> Text -> Int
day3 n = sum . map (read . go n) . T.lines
  where
    go 0 _ = []
    go n line = T.index line i : go (n - 1) (T.drop (i + 1) line)
      where
        i = minimumBy (comparing $ Down . T.index line) [0 .. T.length line - n]
