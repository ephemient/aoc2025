{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PatternSynonyms #-}

module Day5 where

import Data.Ix (inRange, rangeSize)
import Data.Set qualified as Set (empty, lookupLE, lookupMax, lookupMin, singleton, spanAntitone, toList)
import Data.Text (Text)
import Data.Text qualified as T (breakOn, lines, pattern Empty, pattern (:<))
import Data.Text.Read qualified as T (decimal)

day5 :: Text -> (Int, Int)
day5 input =
  ( length
      [ ()
      | line <- T.lines input2,
        (a, T.Empty) <- either (const mempty) pure $ T.decimal line,
        maybe False (`inRange` a) $ Set.lookupLE (a, maxBound @Int) ranges
      ],
    sum $ rangeSize <$> Set.toList ranges
  )
  where
    (input1, input2) = T.breakOn "\n\n" input
    ranges = foldl' addRange Set.empty $ T.lines input1
    addRange ranges line
      | Right (lo, '-' T.:< rest) <- T.decimal line,
        Right (hi, T.Empty) <- T.decimal rest,
        (ranges1, ranges') <- Set.spanAntitone ((< lo) . snd) ranges,
        (ranges2, ranges3) <- Set.spanAntitone ((<= hi) . fst) ranges' =
          ranges1
            <> Set.singleton
              ( maybe lo (min lo . fst) $ Set.lookupMin ranges2,
                maybe hi (max hi . snd) $ Set.lookupMax ranges2
              )
            <> ranges3
      | otherwise = ranges
