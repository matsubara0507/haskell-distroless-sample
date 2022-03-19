{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE MultiWayIf            #-}

module Main where

import Paths_haskell_distroless_sample (version)

import Control.Monad (when)
import Data.Version qualified as Version
import Network.Wai.Handler.Warp qualified as Warp
import Servant
import System.Console.GetOpt
import System.Environment (getArgs)
import Text.Read (readMaybe)

type API
    = "hello" :> Get '[PlainText] String

api :: Proxy API
api = Proxy

server :: Server API
server = pure "world!"

main :: IO ()
main = do
  opts <- compilerOpts usage =<< getArgs
  if
    | opts.help    -> putStrLn usage
    | opts.version -> putStrLn $ Version.showVersion version
    | otherwise    -> Warp.run opts.port $ serve api server
  where
    usage = usageInfo "Usage: sample [OPTION...]" options

data Options = Options
  { help    :: Bool
  , version :: Bool
  , port    :: Int
  }

defaultOptions :: Options
defaultOptions = Options
  { help    = False
  , version = False
  , port    = 8080
  }

options :: [OptDescr (Options -> Options)]
options =
  [ Option ['h'] ["help"]
      (NoArg (\opts -> opts { help = True }))
      "Show this help text"
  , Option ['V'] ["version"]
      (NoArg (\opts -> opts { version = True }))
      "Show version"
  , Option ['p'] ["port"]
      (ReqArg (\port opts -> maybe opts (\p -> opts { port = p }) (readMaybe port)) "PORT")
      "Port to serve (default is 8080)"
  ]

compilerOpts :: String -> [String] -> IO Options
compilerOpts usage argv =
  case getOpt Permute options argv of
    (o, _, []) -> pure $ foldl (flip id) defaultOptions o
    (_, _, errs) -> ioError $ userError (concat errs ++ usage)
