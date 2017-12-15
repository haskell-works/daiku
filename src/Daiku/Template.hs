{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module Daiku.Template where

import Data.Map
import Data.Yaml         (FromJSON (..), (.:))
import Text.RawString.QQ

import qualified Data.Yaml as Y

data Template = Template
  { name    :: String
  , inputs  :: [String]
  , outputs :: [String]
  } deriving (Eq, Show)

instance FromJSON Template where
  parseJSON (Y.Object v) = Template
    <$> v .:  "name"
    <*> v .:  "inputs"
    <*> v .:  "outputs"
  parseJSON _ = fail "Expected Object for Template value"

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
|] :: Maybe Template)
