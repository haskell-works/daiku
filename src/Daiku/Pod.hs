{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module Daiku.Pod where

import Data.Yaml         (FromJSON (..), (.:))
import Text.RawString.QQ

import qualified Data.Yaml as Y

data Pod = Pod
  { inputs  :: [String]
  , outputs :: [String]
  } deriving (Eq, Show)

instance FromJSON Pod where
  parseJSON (Y.Object v) = Pod
    <$> v .:  "inputs"
    <*> v .:  "outputs"
  parseJSON _ = fail "Expected Object for Pod value"

main :: IO ()
main = print (Y.decode [r|
inputs:
- input1
- input2
outputs:
- output1
- output2
|] :: Maybe Pod)
