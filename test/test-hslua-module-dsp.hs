{-# LANGUAGE OverloadedStrings #-}
import Control.Monad (void)
import Foreign.Lua (Lua)
import Foreign.Lua.Module.DSP (preloadModule, pushModule)
import Test.Tasty (TestTree, defaultMain, testGroup)
import Test.Tasty.HUnit (assertEqual, testCase)
import Test.Tasty.Lua (translateResultsFromFile)

import qualified Foreign.Lua as Lua

main :: IO ()
main = do
  luaTest <- Lua.run $ do
    Lua.openlibs
    Lua.requirehs "dsp" (void pushModule)
    translateResultsFromFile "test/test-dsp.lua"
  defaultMain $ testGroup "hslua-module-dsp" [tests, luaTest]

tests :: TestTree
tests = testGroup "FromLuaStack"
  [ testCase "dsp module can be pushed to the stack" $
    Lua.run (void pushModule)

  , testCase "dsp module can be added to the preloader" . Lua.run $ do
      Lua.openlibs
      preloadModule "dsp"
      assertEqual' "function not added to the preloader" Lua.TypeFunction =<< do
        Lua.getglobal' "package.preload.dsp"
        Lua.ltype (-1)

  , testCase "dsp module can be loaded as hsdsp" . Lua.run $ do
      Lua.openlibs
      preloadModule "hsdsp"
      assertEqual' "loading the module fails " Lua.OK =<<
        Lua.dostring "require 'hsdsp'"
  ]

assertEqual' :: (Show a, Eq a) => String -> a -> a -> Lua ()
assertEqual' msg expected = Lua.liftIO . assertEqual msg expected
