{-# LANGUAGE OverloadedStrings #-}

module Daiku.Aws.DynamoDb
  ( createDynamoDbTable
  ) where

import Control.Lens
import Control.Monad.IO.Class
import Control.Monad.Trans.AWS hiding (await)
import Daiku.Aws.Core
import Data.List.NonEmpty
import Network.AWS.DynamoDB

createDynamoDbTable :: MonadIO m => m (Rs CreateTable)
createDynamoDbTable = sendAws $ createTable "daiku-table"
  (keySchemaElement "id" Hash :| []) (provisionedThroughput 1 1)
  & ctAttributeDefinitions .~ [attributeDefinition "id" S]
