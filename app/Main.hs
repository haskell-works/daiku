module Main where

import Development.Shake
import Development.Shake.FilePath
import Development.Shake.Util
import System.Directory

main :: IO ()
main = do
  createDirectoryIfMissing True "_shake"
  runShake

runShake :: IO ()
runShake = shakeArgs shakeOptions{shakeFiles="_build"} $ do
  want ["_build/run" <.> exe]

  phony "clean" $ do
    putNormal "Cleaning files in _build"
    removeFilesAfter "_build" ["//*"]

  "_build/run" <.> exe %> \out -> do
    cs <- getDirectoryFiles "" ["//*.c"]
    let os = ["_build" </> c -<.> "o" | c <- cs]
    need os
    cmd "gcc -o" [out] os

  "_build//*.o" %> \out -> do
    let c = dropDirectory1 $ out -<.> "c"
    let m = out -<.> "m"
    () <- cmd "gcc -c" [c] "-o" [out] "-MMD -MF" [m]
    needMakefileDependencies m
