module Day4 (day4) where

import Control.Arrow (Arrow (first))
import Data.IntMap qualified as Map (fromSet, keysSet, map, partition, restrictKeys, union, unionsWith, withoutKeys)
import Data.IntSet qualified as Set (fromDistinctAscList, intersection, mapMonotonic, size, toList)
import Data.Text (Text)
import Data.Text qualified as T (length, lines, unpack)

day4 :: Text -> (Int, Int)
day4 input = (Set.size removals0, go 0 (Set.toList removals0) counts1)
  where
    grid = T.lines input
    width = foldl' max 1 (T.length <$> grid) + 2
    deltas = Set.fromDistinctAscList $ (+) <$> [-width, 0, width] <*> [-1 .. 1]
    points0 =
      Set.fromDistinctAscList
        [ix' | (ix, line) <- zip [0, width ..] grid, (ix', '@') <- zip [ix ..] $ T.unpack line]
    counts0 =
      Map.unionsWith (+) $
        Map.fromSet (const @Int 1) . Set.intersection points0 . flip Set.mapMonotonic points0 . (+)
          <$> Set.toList deltas
    (removals0, counts1) = first Map.keysSet $ Map.partition (<= 4) counts0
    go !part2 [] _ = part2
    go part2 (ix : removals) counts =
      go (part2 + 1) (Set.toList removals' ++ removals) . Map.union updates $
        counts `Map.withoutKeys` removals'
      where
        (removals', updates) =
          first Map.keysSet . Map.partition (<= 4) . Map.map (subtract 1) . Map.restrictKeys counts $
            Set.mapMonotonic (ix +) deltas
