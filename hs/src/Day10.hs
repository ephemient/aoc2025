module Day10 (part1) where

import Control.Monad (filterM)
import Data.Char (isDigit)
import Data.List (unfoldr, unsnoc)
import Data.Maybe (mapMaybe, maybeToList)
import Data.Text (Text)
import Data.Text qualified as T (dropWhile, lines, unpack, words)
import Data.Text.Read qualified as T (decimal)
import Data.Vector.Unboxed (Vector)
import Data.Vector.Unboxed qualified as V (all, fromList, modify)
import Data.Vector.Unboxed.Mutable qualified as MV (modify)

data Machine = Machine
  { machineLights :: Vector Bool,
    machineButtons :: [[Int]],
    machineJoltages :: Vector Int
  }

parse :: Text -> [Machine]
parse input =
  [ Machine
      { machineLights = V.fromList . mapMaybe parseLight $ T.unpack lights,
        machineButtons = parseNums <$> buttons,
        machineJoltages = V.fromList $ parseNums joltages
      }
  | lights : rest <- T.words <$> T.lines input,
    (buttons, joltages) <- maybeToList $ unsnoc rest
  ]
  where
    parseLight '.' = Just False
    parseLight '#' = Just True
    parseLight _ = Nothing
    parseNums = unfoldr (either (const Nothing) Just . T.decimal . T.dropWhile (not . isDigit))

part1 :: Text -> Int
part1 = sum . map go . parse
  where
    go Machine {machineLights, machineButtons} =
      minimum
        [ length buttons
        | buttons <- filterM (const [False, True]) machineButtons,
          V.all not $ V.modify (\lights -> mapM_ (MV.modify lights not) $ concat buttons) machineLights
        ]
