module Main where

import Data.Semigroup             ((<>))
import Development.Shake
import Development.Shake.FilePath
import Development.Shake.Util
import Options.Applicative
import System.Directory

data Sample = Sample
  { hello      :: String
  , quiet      :: Bool
  , enthusiasm :: Int }

sample :: Parser Sample
sample = Sample
      <$> strOption
          ( long "hello"
          <> metavar "TARGET"
          <> help "Target for the greeting" )
      <*> switch
          ( long "quiet"
          <> short 'q'
          <> help "Whether to be quiet" )
      <*> option auto
          ( long "enthusiasm"
          <> help "How enthusiastically to greet"
          <> showDefault
          <> value 1
          <> metavar "INT" )

greet :: Sample -> IO ()
greet (Sample h False n) = putStrLn $ "Hello, " ++ h ++ replicate n '!'
greet _                  = return ()

main :: IO ()
main = greet =<< execParser opts
  where opts = info (sample <**> helper)
          (   fullDesc
          <>  progDesc "Print a greeting for TARGET"
          <>  header "hello - a test for optparse-applicative" )

  -- createDirectoryIfMissing True "_shake"
  -- runShake

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
