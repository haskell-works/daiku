module Daiku.Aws.Core
  ( sendAws
  ) where

import Control.Lens
import Control.Monad.IO.Class
import Control.Monad.Trans.AWS hiding (await)
import System.IO

sendAws :: (MonadIO m, AWSRequest a) => a -> m (Rs a)
sendAws r = do
  lgr <- newLogger Trace stdout
  env <- liftIO $ newEnv Discover <&> set envLogger lgr . set envRegion Oregon
  liftIO $ runResourceT . runAWST env $ send r
