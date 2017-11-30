{-# LANGUAGE OverloadedStrings #-}

module Daiku.Aws.Sqs.Core
  ( createSqsQueue
  ) where

import Control.Monad.IO.Class
import Control.Monad.Trans.AWS hiding (await)
import Daiku.Aws.Core
import Network.AWS.SQS

createSqsQueue :: MonadIO m => m (Rs CreateQueue)
createSqsQueue = sendAws $ createQueue "daiku-queue"
