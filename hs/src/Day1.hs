module Day1 (day1) where

import Data.Text (Text)
import Data.Text qualified as T

day1 :: Text -> (Int, Int)
day1 input = (zeros, zeros + turns)
  where
    (_, zeros, turns) = foldl' go (50, 0, 0) $ T.lines input
    go k ('L' T.:< line) = go' k $ -read (T.unpack line)
    go k ('R' T.:< line) = go' k $ read (T.unpack line)
    go k _ = k
    go' (pos, zeros, turns) rotation =
      ( pos'',
        (if pos'' == 0 then succ else id) zeros,
        (if pos /= 0 && pos' < 0 then succ else id) turns'
      )
      where
        pos' = pos + rotation
        pos'' = pos' `mod` 100
        turns' = turns + abs (pos' - signum pos') `div` 100
