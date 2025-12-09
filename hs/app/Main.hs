module Main (main) where

import Control.Arrow ((***))
import Control.Monad (forM_)
import Data.List (find)
import Data.Maybe (fromMaybe)
import Data.Set qualified as Set (fromList, member)
import Data.Text (Text)
import Data.Text.IO qualified as TIO (readFile)
import Day1 (day1)
import Day2 qualified (part1, part2)
import Day3 (day3)
import Day4 (day4)
import Day5 (day5)
import Day6 qualified (part1, part2)
import Day7 (day7)
import Day8 (day8)
import Day9 qualified (part1, part2)
import System.Environment (getArgs, lookupEnv)
import System.FilePath (combine)

getDayInput :: Int -> IO Text
getDayInput day = do
  dataDir <- fromMaybe "." . find (not . null) <$> lookupEnv "AOC2025_DATADIR"
  TIO.readFile . combine dataDir $ "day" <> show day <> ".txt"

days :: [(Int, String, Text -> IO ())]
days =
  [ run 1 print2 [day1],
    run 2 print [Day2.part1, Day2.part2],
    run 3 print [day3 2, day3 12],
    run 4 print2 [day4],
    run 5 print2 [day5],
    run 6 print [Day6.part1, Day6.part2],
    run 7 print2 [day7],
    run 8 (putStrLn2 . (show *** maybe "null" show)) [Day8.day8 1000],
    run 9 print [Day9.part1, Day9.part2]
  ]
  where
    run day showIO funcs = (day, show day, run' showIO funcs)
    run' showIO funcs input = mapM_ (showIO . ($ input)) funcs
    print2 (a, b) = print a >> print b
    putStrLn2 (a, b) = putStrLn a >> putStrLn b

main :: IO ()
main = do
  args <- Set.fromList <$> getArgs
  let days' = [spec | spec@(_, name, _) <- days, name `Set.member` args]
  forM_ (if null days' then days else days') $ \(day, name, run) -> do
    putStrLn $ "Day " <> name
    run =<< getDayInput day
    putStrLn ""
