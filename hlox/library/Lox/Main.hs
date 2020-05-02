{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeOperators #-}

module Lox.Main where

import Control.Lens ((^.))
import Data.Generics.Labels ()
import qualified Options.Applicative as Options
import Path (Abs, File, Path)
import Path.IO (resolveFile')
import Relude
import Text.Pretty.Simple (pPrint)

-------------------------------------------------------------------------------
main :: IO ()
main = do
  loxConfig <- fromLoxOpts =<< Options.execParser optionsParserInfo
  pPrint loxConfig
  pure ()

-------------------------------------------------------------------------------
-- Lox interpreter configuration parameters.
data LoxConfig = LoxConfig
  { scriptPath :: Path Abs File
  }
  deriving stock (Generic, Show)

fromLoxOpts :: LoxOpts -> IO LoxConfig
fromLoxOpts loxOpts = do
  scriptPath <- resolveFile' $ loxOpts ^. #scriptPath
  pure LoxConfig {..}

-------------------------------------------------------------------------------
optionsParserInfo :: Options.ParserInfo LoxOpts
optionsParserInfo =
  Options.info (loxOptsParser <**> Options.helper) $
    Options.fullDesc
      <> Options.progDesc "Lox Interpreter"

-- | Command line options 'Options.Parser' for 'LoxOpts'.
loxOptsParser :: Options.Parser LoxOpts
loxOptsParser = do
  scriptPath <-
    Options.strArgument $
      Options.metavar "SCRIPT"
        <> Options.help "Path to a *.lox file."
  pure LoxOpts {..}

-- | Configuration options for the Lox interpreter.
data LoxOpts = LoxOpts
  { scriptPath :: FilePath
  }
  deriving stock (Generic, Show)
