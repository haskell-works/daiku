{-# LANGUAGE OverloadedStrings #-}

module Lib
  ( createDaikuBucket
  , deleteDaikuBucket
  , createDaikuKinesisStream
  , deleteDaikuKinesisStream
  , sendAws
  ) where

import Control.Lens
import Control.Monad.Trans.AWS
import Network.AWS.Kinesis
import Network.AWS.S3
import System.IO

sendAws :: AWSRequest a => a -> IO (Rs a)
sendAws r = do
  lgr <- newLogger Trace stdout
  env <- newEnv Discover <&> set envLogger lgr . set envRegion Oregon
  runResourceT . runAWST env $ send r

createDaikuBucket :: IO (Rs CreateBucket)
createDaikuBucket = sendAws $ createBucket "daiku-bucket" &
    (cbCreateBucketConfiguration .~ Just (createBucketConfiguration & cbcLocationConstraint .~ Just (LocationConstraint Oregon)))

deleteDaikuBucket :: IO (Rs DeleteBucket)
deleteDaikuBucket = sendAws $ deleteBucket "daiku-bucket"

createDaikuKinesisStream :: IO (Rs CreateStream)
createDaikuKinesisStream = sendAws $ createStream "daiku-stream" 1

deleteDaikuKinesisStream :: IO (Rs DeleteStream)
deleteDaikuKinesisStream = sendAws $ deleteStream "daiku-stream"
