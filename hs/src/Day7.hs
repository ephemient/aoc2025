module Day7 (day7) where

import Control.Arrow (second)
import Data.IntMap.Strict qualified as IntMap (fromDistinctAscList, mapKeysMonotonic, partitionWithKey, size, unionsWith)
import Data.Text (Text)
import Data.Text qualified as T (index, length, lines, unpack)

day7 :: Text -> (Int, Int)
day7 input = second sum $ foldl' go (0, start) $ drop 1 input'
  where
    input' = T.lines input
    start = IntMap.fromDistinctAscList [(i, 1) | line <- take 1 input', (i, 'S') <- zip [0 ..] $ T.unpack line]
    go (count, prev) line = (count', next)
      where
        (left, right) = IntMap.partitionWithKey (\key _ -> 0 <= key && key < T.length line && line `T.index` key == '^') prev
        !count' = count + IntMap.size left
        !next = IntMap.unionsWith (+) [IntMap.mapKeysMonotonic pred left, right, IntMap.mapKeysMonotonic succ left]
