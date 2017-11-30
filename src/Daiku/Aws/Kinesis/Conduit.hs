
module Daiku.Aws.Kinesis.Conduit
  ( kinesisPutKV
  ) where

import Control.Monad.IO.Class
import Daiku.Aws.Core
import Data.Conduit
import Data.Text
import Network.AWS.Data.ByteString
import Network.AWS.Data.Text
import Network.AWS.Kinesis

kinesisPutKV :: (MonadIO m, ToText k, ToByteString v) => Text -> Conduit (k, v) m PutRecordResponse
kinesisPutKV streamName = do
  ma <- await
  case ma of
    Just (k, v) -> do
      resp <- liftIO $ sendAws $ putRecord streamName (toBS v) (toText k)
      yield resp
    Nothing         -> return ()
