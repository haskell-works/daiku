{-# LANGUAGE OverloadedStrings #-}

module Lib
  ( createHelloBucket
  ) where

import Control.Lens
import Control.Monad.Trans.AWS
import Network.AWS.S3
import System.IO

createHelloBucket :: IO ()
createHelloBucket = do
  lgr <- newLogger Trace stdout
  env <- newEnv Discover <&> set envLogger lgr . set envRegion Oregon
  _ <- runResourceT . runAWST env $ send $ createBucket "daiku-hello" &
    (cbCreateBucketConfiguration .~ Just (createBucketConfiguration & cbcLocationConstraint .~ Just (LocationConstraint Oregon)))
  return ()
