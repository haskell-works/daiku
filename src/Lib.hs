{-# LANGUAGE OverloadedStrings #-}

module Lib
  ( createDaikuBucket
  , deleteDaikuBucket
  , createDaikuKinesisStream
  , deleteDaikuKinesisStream
  , createDynamoDbTable
  , createSqsQueue
  , sendAws
  , kinesisPutConduit
  ) where

import Control.Lens
import Control.Monad.IO.Class
import Control.Monad.Trans.AWS hiding (await)
import Data.ByteString
import Data.Conduit
import Data.List.NonEmpty
import Data.Text
import Network.AWS.DynamoDB
import Network.AWS.Kinesis
import Network.AWS.S3
import Network.AWS.SQS
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

createDynamoDbTable :: IO (Rs CreateTable)
createDynamoDbTable = sendAws $ createTable "daiku-table"
  (keySchemaElement "id" Hash :| []) (provisionedThroughput 1 1)
  & ctAttributeDefinitions .~ [attributeDefinition "id" S]

createSqsQueue :: IO (Rs CreateQueue)
createSqsQueue = sendAws $ createQueue "daiku-queue"

kinesisPutConduit :: MonadIO m => Text -> Conduit (ByteString, Text) m PutRecordResponse
kinesisPutConduit streamName = do
  ma <- await
  case ma of
    Just (msg, key) -> do
      resp <- liftIO $ sendAws $ putRecord streamName msg key
      yield resp
    Nothing         -> return ()
