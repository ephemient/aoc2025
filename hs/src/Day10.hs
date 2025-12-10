{-# LANGUAGE OverloadedStrings #-}

module Day10 (part1, part2) where

import Control.Monad (filterM)
import Data.Char (isDigit)
import Data.List (unfoldr, unsnoc)
import Data.Maybe (mapMaybe, maybeToList)
import Data.Text (Text)
import Data.Text qualified as T (dropWhile, empty, lines, pack, unlines, unpack, unwords, words)
import Data.Text.IO qualified as TIO (hGetContents, hPutStr)
import Data.Text.Read qualified as T (decimal)
import Data.Vector.Unboxed (Vector)
import Data.Vector.Unboxed qualified as V (all, fromList, length, modify, (!))
import Data.Vector.Unboxed.Mutable qualified as MV (modify)
import System.IO (hClose)
import System.IO.Temp (withSystemTempFile)
import System.Process (CreateProcess (std_out), StdStream (CreatePipe), proc, withCreateProcess)

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

part2 :: Text -> IO Int
part2 = fmap sum . mapM go . parse
  where
    go Machine {machineButtons, machineJoltages} = do
      let vars = ["button" <> T.pack (show i) | i <- [0 .. length machineButtons - 1]]
      output <- withSystemTempFile "aoc2025d10p2.XXXXXX" $ \path handle -> do
        TIO.hPutStr handle . T.unlines $
          ["(declare-const " <> var <> " Int)" | var <- vars]
            ++ ["(assert (<= 0 " <> var <> "))" | var <- vars]
            ++ [ "(assert (= "
                   <> T.pack (show $ machineJoltages V.! i)
                   <> " (+ "
                   <> T.unwords [var | (var, button) <- zip vars machineButtons, i `elem` button]
                   <> ")))"
               | i <- [0 .. V.length machineJoltages - 1]
               ]
            ++ ["(minimize (+ " <> T.unwords vars <> "))", "(check-sat)", "(get-model)"]
        hClose handle
        withCreateProcess (proc "z3" [path]) {std_out = CreatePipe} $ \_ stdout _ _ -> maybe (pure T.empty) TIO.hGetContents stdout
      pure $ case T.words output of
        "sat" : rest -> sum $ mapMaybe (either (const Nothing) (Just . fst) . T.decimal) rest
        _ -> 0
