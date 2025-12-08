{-# LANGUAGE OverloadedStrings #-}

module Day6 (part1, part2) where

import Data.Char (isSpace)
import Data.List (foldl1', transpose)
import Data.List.Split (splitWhen)
import Data.Maybe (mapMaybe)
import Data.Text (Text)
import Data.Text qualified as T (all, breakOnEnd, lines, strip, stripEnd, transpose, unpack, words)

day6 :: ([Text] -> [[Int]]) -> Text -> Int
day6 grouping input = sum $ zipWith foldl1' (mapMaybe op $ T.unpack input2) (grouping $ T.lines input1)
  where
    (input1, input2) = T.breakOnEnd "\n" $ T.stripEnd input
    op '+' = Just (+)
    op '*' = Just (*)
    op _ = Nothing

part1, part2 :: Text -> Int
part1 = day6 $ transpose . map (map (read . T.unpack) . T.words)
part2 = day6 $ map (map $ read . T.unpack . T.strip) . splitWhen (T.all isSpace) . T.transpose
