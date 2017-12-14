{-# LANGUAGE OverloadedStrings #-}

module Daiku.Pod where

import qualified Data.Yaml as Y

main :: IO ()
main = print (Y.decode "[1, 2, 3]" :: Maybe [Integer])
