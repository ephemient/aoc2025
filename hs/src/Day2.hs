{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PatternSynonyms #-}

module Day2 (part1, part2) where

import Control.Arrow (first, (***))
import Control.Monad (ap)
import Control.Monad.Fix (fix)
import Data.List (inits)
import Data.Text (Text)
import Data.Text qualified as T (splitOn, strip, pattern Empty, pattern (:<))
import Data.Text.Read qualified as T (decimal)

day2 :: (Integral a) => [(Int, a)] -> Text -> a
day2 factors = sum . concatMap go . T.splitOn ","
  where
    go line
      | Right (lo, '-' T.:< line') <- T.decimal $ T.strip line,
        Right (hi, T.Empty) <- T.decimal line' =
          [ (maxChunk * (maxChunk + 1) - minChunk * (minChunk + 1)) `div` 2 * (scale' * c)
          | (scale0, c) <- takeWhile ((<= hi) . fst) $ map (first $ (10 ^) . pred) factors,
            ((prev, _), (power, scale)) <-
              zip `ap` drop 1 $ takeWhile ((<= hi) . snd) $ iterate ((* 10) *** (* scale0)) (1, 1),
            let scale' = (scale * power - 1) `div` (power - 1)
                minChunk = max (prev - 1) $ (lo - 1) `div` scale'
                maxChunk = min (power - 1) $ hi `div` scale',
            minChunk < maxChunk
          ]
    go _ = []

part1, part2 :: Text -> Int
part1 = day2 [(2, 1)]
part2 = day2 $ filter ((/= 0) . snd) $ fix (zipWith go [2 ..] . inits)
  where
    go n factors = (n, foldl' (-) 1 [c | (m, c) <- factors, n `mod` m == 0])
