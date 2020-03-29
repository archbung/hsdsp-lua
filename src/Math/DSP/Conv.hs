module Math.DSP.Conv (conv1d) where

import Data.List (tails)

conv1d :: Num a => [a] -> [a] -> [a]
conv1d input kernel = 
  map (sum . zipWith (*) (reverse kernel)) (init $ tails padded)
  where
    padded = replicate (length kernel - 1) 0 ++ input
