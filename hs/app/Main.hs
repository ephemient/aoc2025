module Main (main) where

import Control.Monad (forM_)
import Data.List (find)
import Data.Map (Map)
import Data.Map qualified as Map (fromList, null, restrictKeys, toList)
import Data.Maybe (fromMaybe)
import Data.Set qualified as Set (fromList)
import Data.Text (Text)
import Data.Text qualified as T (show)
import Data.Text.IO qualified as TIO (putStrLn, readFile)
import Day1 (day1)
import Day2 qualified (part1, part2)
import Day3 (day3)
import Day4 (day4)
import Day5 (day5)
import Day6 qualified (part1, part2)
import Day7 (day7)
import Day8 (day8)
import System.Environment (getArgs, lookupEnv)
import System.FilePath (combine)

getDayInput :: String -> IO Text
getDayInput day = do
  dataDir <- fromMaybe "." . find (not . null) <$> lookupEnv "AOC2025_DATADIR"
  TIO.readFile . combine dataDir $ "day" <> day <> ".txt"

days :: Map String [Text -> Text]
days =
  Map.fromList
    [ ("1", [T.show . day1]),
      ("2", [T.show . Day2.part1, T.show . Day2.part2]),
      ("3", [T.show . day3 2, T.show . day3 12]),
      ("4", [T.show . day4]),
      ("5", [T.show . day5]),
      ("6", [T.show . Day6.part1, T.show . Day6.part2]),
      ("7", [T.show . day7]),
      ("8", [T.show . Day8.day8 1000])
    ]

main :: IO ()
main = do
  days' <- fmap (Map.restrictKeys days . Set.fromList) getArgs
  forM_ (Map.toList (if Map.null days' then days else days')) $ \(day, parts) -> do
    putStrLn $ "Day " <> day
    input <- getDayInput day
    mapM_ (TIO.putStrLn . ($ input)) parts
    putStrLn ""
