module Day4 (day4) where

import Control.Arrow (first)
import Data.List (unfoldr)
import Data.Monoid (Sum (Sum, getSum))
import Data.Text (Text)
import Data.Text qualified as T (index, length, lines)
import Data.Vector.Unboxed qualified as V (concat, drop, empty, foldMap', generate, imapMaybe, length, take, update)

day4 :: Text -> (Int, Int)
day4 input = (sum $ take 1 steps, sum steps)
  where
    step grid =
      case first sum $
        unzip
          [ (V.length diff, V.update line diff)
          | (line, above, below) <- zip3 grid (V.empty : grid) $ drop 1 grid ++ [V.empty],
            let f x '@'
                  | getSum (V.foldMap' (Sum @Int . \case '@' -> 1; _ -> 0) adj) <= 4 =
                      Just (x, 'x')
                  where
                    adj = V.concat $ (if x == 0 then V.take 2 else V.take 3 . V.drop (x - 1)) <$> [line, above, below]
                f _ _ = Nothing
                diff = V.imapMaybe f line

          ] of
        (0, _) -> Nothing
        res -> Just res
    steps = unfoldr step [V.generate (T.length line) (T.index line) | line <- T.lines input]
