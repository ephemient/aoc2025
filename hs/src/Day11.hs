{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PatternSynonyms #-}

module Day11 where

import Data.Map (Map)
import Data.Map qualified as Map (findWithDefault, fromListWith, insert)
import Data.Text (Text)
import Data.Text qualified as T (lines, words, pattern (:>))

parse :: Text -> Map Text [Text]
parse input =
  Map.fromListWith
    (<>)
    [ (key, values)
    | (key T.:> ':') : values <- T.words <$> T.lines input
    ]

paths :: (Ord k) => Map k [k] -> k -> k -> Int
paths gr src dst = Map.findWithDefault 0 src paths'
  where
    paths' = Map.insert dst 1 $ go <$> gr
    go values = sum [Map.findWithDefault 0 value paths' | value <- values]

part1, part2 :: Text -> Int
part1 input = paths (parse input) "you" "out"
part2 input =
  paths gr "svr" "dac" * paths gr "dac" "fft" * paths gr "fft" "out"
    + paths gr "svr" "fft" * paths gr "fft" "dac" * paths gr "dac" "out"
  where
    gr = parse input
