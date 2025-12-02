{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PatternSynonyms #-}

module Day2 (part1, part2) where

import Data.Containers.ListUtils (nubOrd)
import Data.Function (on)
import Data.Text (Text)
import Data.Text qualified as T (breakOn, length, replicate, show, splitOn, strip, take, unpack, pattern Empty, pattern (:<))
import Data.Text.Read qualified as T (decimal)

day2 :: (Int -> Int -> Int) -> Text -> Int
day2 chunks = sum . concatMap go . T.splitOn ","
  where
    go line
      | (lo, '-' T.:< hi) <- T.breakOn "-" $ T.strip line,
        Right (lo', T.Empty) <- T.decimal lo,
        Right (hi', T.Empty) <- T.decimal hi =
          nubOrd
            [ candidate
            | n <- [2 .. on chunks T.length lo hi],
              let loChunk = case T.length lo `divMod` n of
                    (q, 0) -> read . T.unpack $ T.take q lo
                    (q, _) -> 10 ^ q
                  hiChunk = case T.length hi `divMod` n of
                    (q, 0) -> read . T.unpack $ T.take q hi
                    (q, _) -> 10 ^ q - 1,
              chunk :: Int <- [loChunk .. hiChunk],
              let candidate = read . T.unpack . T.replicate n $ T.show chunk,
              lo' <= candidate,
              candidate <= hi'
            ]
    go _ = []

part1, part2 :: Text -> Int
part1 = day2 (const $ const 2)
part2 = day2 max
