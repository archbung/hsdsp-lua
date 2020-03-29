module Foreign.Lua.Module.DSP where

import Foreign.Lua (Lua, NumResults (..))
import qualified Foreign.Lua as Lua

import qualified Math.DSP.Conv as Conv


conv1d :: [Int] -> [Int] -> Lua [Int]
conv1d input kernel = return $ Conv.conv1d input kernel

pushModule :: Lua NumResults
pushModule = do
  Lua.newtable
  Lua.addfunction "conv1d" conv1d
  return 1

preloadModule :: String -> Lua ()
preloadModule = flip Lua.preloadhs pushModule
