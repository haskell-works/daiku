module Daiku.Commands where

import Data.Aeson

data Command = Command
  { toJson :: Value
  , run    :: IO ()
  }
