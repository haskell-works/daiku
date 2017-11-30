{-# LANGUAGE OverloadedStrings #-}

module Daiku.Aws.Sns.Core
  ( createSnsTopic
  , listSnsSubscriptions
  ) where

import Control.Monad.IO.Class
import Control.Monad.Trans.AWS hiding (await)
import Daiku.Aws.Core
import Network.AWS.SNS

createSnsTopic :: MonadIO m => m (Rs CreateTopic)
createSnsTopic = sendAws $ createTopic "daiku-topic"

listSnsSubscriptions :: MonadIO m => m (Rs ListSubscriptions)
listSnsSubscriptions = sendAws listSubscriptions
