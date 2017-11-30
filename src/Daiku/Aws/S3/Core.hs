{-# LANGUAGE OverloadedStrings #-}

module Daiku.Aws.S3.Core
  ( createDaikuBucket
  , deleteDaikuBucket
  , putObject
  ) where

import Control.Lens
import Control.Monad.IO.Class
import Control.Monad.Trans.AWS hiding (await)
import Daiku.Aws.Core

import qualified Network.AWS.S3 as AWS

createDaikuBucket :: MonadIO m => AWS.BucketName -> m (Rs AWS.CreateBucket)
createDaikuBucket bucketName = sendAws $ AWS.createBucket bucketName &
    (AWS.cbCreateBucketConfiguration .~
      Just (
        AWS.createBucketConfiguration & AWS.cbcLocationConstraint .~ Just (AWS.LocationConstraint Oregon)))

deleteDaikuBucket :: MonadIO m => AWS.BucketName -> m (Rs AWS.DeleteBucket)
deleteDaikuBucket bucketName = sendAws $ AWS.deleteBucket bucketName

putObject :: MonadIO m => AWS.BucketName -> AWS.ObjectKey -> RqBody -> m AWS.PutObjectResponse
putObject bucketName objectKey requestBody = sendAws $ AWS.putObject bucketName objectKey requestBody
