{-# LANGUAGE OverloadedStrings #-}

module Daiku.Aws.Kinesis.Core
  ( createDaikuKinesisStream
  , deleteDaikuKinesisStream
  ) where

import Control.Monad.IO.Class
import Control.Monad.Trans.AWS hiding (await)
import Daiku.Aws.Core
import Network.AWS.Kinesis

createDaikuKinesisStream :: MonadIO m => m (Rs CreateStream)
createDaikuKinesisStream = sendAws $ createStream "daiku-stream" 1

deleteDaikuKinesisStream :: MonadIO m => m (Rs DeleteStream)
deleteDaikuKinesisStream = sendAws $ deleteStream "daiku-stream"
