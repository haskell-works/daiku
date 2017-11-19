{-# LANGUAGE OverloadedStrings #-}

module Lib
  ( createHelloBucket
  , deleteHelloBucket
  , sendAws
  ) where

import Control.Lens
import Control.Monad.Trans.AWS
import Network.AWS.S3
import System.IO

sendAws :: AWSRequest a => a -> IO (Rs a)
sendAws r = do
  lgr <- newLogger Trace stdout
  env <- newEnv Discover <&> set envLogger lgr . set envRegion Oregon
  runResourceT . runAWST env $ send r

createHelloBucket :: IO (Rs CreateBucket)
createHelloBucket = sendAws $ createBucket "daiku-hello" &
    (cbCreateBucketConfiguration .~ Just (createBucketConfiguration & cbcLocationConstraint .~ Just (LocationConstraint Oregon)))

deleteHelloBucket :: IO (Rs DeleteBucket)
deleteHelloBucket = sendAws $ deleteBucket "daiku-hello"
