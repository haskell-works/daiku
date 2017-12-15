{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module Daiku.Pod where

import Data.Map
import Data.Yaml         (FromJSON (..), (.:))
import Text.RawString.QQ

import qualified Data.Yaml as Y

data Pod = Pod
  { name    :: String
  , inputs  :: [String]
  , outputs :: [String]
  } deriving (Eq, Show)

instance FromJSON Pod where
  parseJSON (Y.Object v) = Pod
    <$> v .:  "name"
    <*> v .:  "inputs"
    <*> v .:  "outputs"
  parseJSON _ = fail "Expected Object for Pod value"

data Expr = Expr
  { exprEval :: Map String String -> String
  , exprText :: String
  }

main :: IO ()
main = print (Y.decode [r|
name: daiku-bucket
inputs:
- input1
- input2
outputs:
- output1
- output2
|] :: Maybe Pod)
