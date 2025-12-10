module Main (main) where

import Control.Arrow ((>>>))
import Criterion.Main (bench, bgroup, defaultMain, env, envWithCleanup, nf, nfAppIO)
import Data.Foldable (find)
import Data.Maybe (fromMaybe)
import Data.Text (Text)
import Data.Text.IO qualified as TIO (readFile)
import Day1 (day1)
import Day10 qualified (part1, part2)
import Day2 qualified (part1, part2)
import Day3 (day3)
import Day4 (day4)
import Day5 (day5)
import Day6 qualified (part1, part2)
import Day7 (day7)
import Day8 (day8)
import Day9 qualified (part1, part2)
import System.Environment (getEnv, lookupEnv, setEnv, unsetEnv)
import System.FilePath (combine)

setTrace :: String -> IO (Maybe String)
setTrace value = lookupEnv "TRACE" <* setEnv "TRACE" value

unsetTrace :: Maybe String -> IO ()
unsetTrace = maybe (unsetEnv "TRACE") (setEnv "TRACE")

getDayInput :: Int -> IO Text
getDayInput day = do
  dataDir <- fromMaybe "." . find (not . null) <$> lookupEnv "AOC2025_DATADIR"
  TIO.readFile . combine dataDir $ "day" <> show day <> ".txt"

main :: IO ()
main =
  defaultMain
    [ env (getDayInput 1) $ \input ->
        bench "Day 1" $ nf day1 input,
      env (getDayInput 2) $ \input ->
        bgroup
          "Day 2"
          [ bench "part 1" $ nf Day2.part1 input,
            bench "part 2" $ nf Day2.part2 input
          ],
      env (getDayInput 3) $ \input ->
        bgroup
          "Day 3"
          [ bench "part 1" $ nf (day3 2) input,
            bench "part 2" $ nf (day3 12) input
          ],
      env (getDayInput 4) $ \input ->
        bench "Day 4" $ nf day4 input,
      env (getDayInput 5) $ \input ->
        bench "Day 5" $ nf day5 input,
      env (getDayInput 6) $ \input ->
        bgroup
          "Day 6"
          [ bench "part 1" $ nf Day6.part1 input,
            bench "part 2" $ nf Day6.part2 input
          ],
      env (getDayInput 7) $ \input ->
        bench "Day 7" $ nf day7 input,
      env (getDayInput 8) $ \input ->
        bench "Day 8" $ nf (day8 1000) input,
      env (getDayInput 9) $ \input ->
        bgroup
          "Day 9"
          [ bench "part 1" $ nf Day9.part1 input,
            bench "part 2" $ nf Day9.part2 input
          ],
      env (getDayInput 10) $ \input ->
        bgroup
          "Day 10"
          [ bench "part 1" $ nf Day10.part1 input,
            bench "part 2" $ nfAppIO Day10.part2 input
          ]
    ]
