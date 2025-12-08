{-# LANGUAGE PatternSynonyms #-}

module Day5 (day5) where

import Control.Arrow (second)
import Control.Monad.ST (runST)
import Data.Monoid (Sum (Sum, getSum))
import Data.Text (Text)
import Data.Text qualified as T (lines, null, pattern Empty, pattern (:<))
import Data.Text.Read qualified as T (decimal)
import Data.Vector.Algorithms.Intro qualified as MV (sort)
import Data.Vector.Algorithms.Search qualified as MV (binarySearchP, binarySearchPBounds)
import Data.Vector.Unboxed qualified as V (create, foldMap', fromList, thaw, unsafeThaw, (!?))
import Data.Vector.Unboxed.Mutable qualified as MV (foldM', modify, take, write)

day5 :: Text -> (Int, Int)
day5 input =
  ( length
      [ ()
      | line <- input2,
        (x, T.Empty) <- decimal line,
        maybe False ((<= x) . fst) $
          ranges V.!? runST (V.unsafeThaw ranges >>= MV.binarySearchP ((x <=) . snd))
      ],
    getSum $ V.foldMap' (Sum . succ . uncurry subtract) ranges
  )
  where
    (input1, input2) = break T.null $ T.lines input
    ranges = V.create $ do
      ranges <-
        V.thaw $
          V.fromList
            [ (lo, hi)
            | line <- input1,
              (lo, '-' T.:< line') <- decimal line,
              (hi, T.Empty) <- decimal line'
            ]
      MV.sort ranges
      let go count range@(lo, hi) = do
            i <- MV.binarySearchPBounds ((lo <=) . snd) ranges 0 count
            if i < count
              then MV.modify ranges (second $ max hi) i
              else MV.write ranges i range
            pure $ i + 1
      count <- MV.foldM' go 0 ranges
      pure $ MV.take count ranges
    decimal = either (const mempty) pure . T.decimal
