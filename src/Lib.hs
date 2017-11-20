{-# LANGUAGE OverloadedStrings #-}

module Lib
  ( createDaikuBucket
  , deleteDaikuBucket
  , createDaikuKinesisStream
  , deleteDaikuKinesisStream
  , createDynamoDbTable
  , createSnsTopic
  , listSnsSubscriptions
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
import Network.AWS.SNS
import Network.AWS.SQS
import System.IO

sendAws :: (MonadIO m, AWSRequest a) => a -> m (Rs a)
sendAws r = do
  lgr <- newLogger Trace stdout
  env <- liftIO $ newEnv Discover <&> set envLogger lgr . set envRegion Oregon
  liftIO $ runResourceT . runAWST env $ send r

createDaikuBucket :: MonadIO m => m (Rs CreateBucket)
createDaikuBucket = sendAws $ createBucket "daiku-bucket" &
    (cbCreateBucketConfiguration .~ Just (createBucketConfiguration & cbcLocationConstraint .~ Just (LocationConstraint Oregon)))

deleteDaikuBucket :: MonadIO m => m (Rs DeleteBucket)
deleteDaikuBucket = sendAws $ deleteBucket "daiku-bucket"

createDaikuKinesisStream :: MonadIO m => m (Rs CreateStream)
createDaikuKinesisStream = sendAws $ createStream "daiku-stream" 1

deleteDaikuKinesisStream :: MonadIO m => m (Rs DeleteStream)
deleteDaikuKinesisStream = sendAws $ deleteStream "daiku-stream"

createDynamoDbTable :: MonadIO m => m (Rs CreateTable)
createDynamoDbTable = sendAws $ createTable "daiku-table"
  (keySchemaElement "id" Hash :| []) (provisionedThroughput 1 1)
  & ctAttributeDefinitions .~ [attributeDefinition "id" S]

createSqsQueue :: MonadIO m => m (Rs CreateQueue)
createSqsQueue = sendAws $ createQueue "daiku-queue"

kinesisPutConduit :: MonadIO m => Text -> Conduit (ByteString, Text) m PutRecordResponse
kinesisPutConduit streamName = do
  ma <- await
  case ma of
    Just (msg, key) -> do
      resp <- liftIO $ sendAws $ putRecord streamName msg key
      yield resp
    Nothing         -> return ()

createSnsTopic :: MonadIO m => m (Rs CreateTopic)
createSnsTopic = sendAws $ createTopic "daiku-topic"

listSnsSubscriptions :: MonadIO m => m (Rs ListSubscriptions)
listSnsSubscriptions = sendAws listSubscriptions
