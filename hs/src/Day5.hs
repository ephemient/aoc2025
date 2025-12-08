{-# LANGUAGE PatternSynonyms #-}

module Day5 (day5) where

import Data.Ix (rangeSize)
import Data.Map qualified as Map (assocs, empty, lookupLE, lookupMax, lookupMin, singleton)
import Data.Map.Extra qualified as Map (spanAntitoneWithElem3)
import Data.Text (Text)
import Data.Text qualified as T (lines, null, pattern Empty, pattern (:<))
import Data.Text.Read qualified as T (decimal)

day5 :: Text -> (Int, Int)
day5 input =
  ( length
      [ ()
      | line <- input2,
        (a, T.Empty) <- either (const mempty) pure $ T.decimal @Int line,
        maybe False ((a <=) . snd) $ Map.lookupLE a ranges
      ],
    sum $ rangeSize <$> Map.assocs ranges
  )
  where
    (input1, input2) = break T.null $ T.lines input
    ranges = foldl' addRange Map.empty input1
    addRange ranges line
      | Right (lo, '-' T.:< rest) <- T.decimal line,
        Right (hi, T.Empty) <- T.decimal rest,
        (rangesLT, rangesEQ, rangesGT) <- Map.spanAntitoneWithElem3 (cmp lo hi) ranges =
          rangesLT
            <> Map.singleton
              (maybe lo (min lo . fst) $ Map.lookupMin rangesEQ)
              (maybe hi (max hi . snd) $ Map.lookupMax rangesEQ)
            <> rangesGT
      | otherwise = ranges
      where
        cmp lo _ _ hi | hi < lo = LT
        cmp _ hi lo _ | hi < lo = GT
        cmp _ _ _ _ = EQ
