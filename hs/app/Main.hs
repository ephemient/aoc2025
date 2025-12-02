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
import qualified Day2 (part1, part2)
import System.Environment (getArgs, lookupEnv)
import System.FilePath (combine)

getDayInput :: String -> IO Text
getDayInput day = do
  dataDir <- fromMaybe "." . find (not . null) <$> lookupEnv "AOC2025_DATADIR"
  TIO.readFile . combine dataDir $ "day" <> day <> ".txt"

days :: Map String [Text -> Text]
days = Map.fromList [("1", [T.show . day1]), ("2", [T.show . Day2.part1, T.show . Day2.part2])]

main :: IO ()
main = do
  days' <- fmap (Map.restrictKeys days . Set.fromList) getArgs
  forM_ (Map.toList (if Map.null days' then days else days')) $ \(day, parts) -> do
    putStrLn $ "Day " <> day
    input <- getDayInput day
    mapM_ (TIO.putStrLn . ($ input)) parts
    putStrLn ""
