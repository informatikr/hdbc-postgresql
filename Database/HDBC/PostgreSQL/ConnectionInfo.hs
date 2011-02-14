module Database.HDBC.PostgreSQL.ConnectionInfo
    ( ConnectionInfo(..)
    , renderConnInfo
    , defaultConnInfo
    )
  where

import Data.List (unwords)
import Data.Maybe (mapMaybe)


{-| A data type for the parameters used by 'connectPostgreSQL'.

See <http://www.postgresql.org/docs/8.1/static/libpq.html#LIBPQ-CONNECT> for
a detailed description of the parameters.
-}
data ConnectionInfo = CI
    { host, hostaddr, port, dbname, user, password, connection_timeout
    , options, tty, sslmode, requiressl, krbsrvname, service :: String }


{-| A default 'ConnectionInfo' value. It is equivalent to an empty-string parameter to the 'connectPostgreSQL' function. Fields can be overridden individually by using record syntax.

An example:

@
    myConnInfo = defaultConnInfo { dbname = \"myDB\", password = \"secret\" }
@
-}
defaultConnInfo :: ConnectionInfo
defaultConnInfo = CI "" "" "" "" "" "" "" "" "" "" "" "" ""


{-| Convert a 'ConnectionInfo' Value to a 'String' as used by the 'connectPostgreSQL' function.

Usage:

@
    do conn <- connectPostgreSQL (renderConnInfo myConnInfo)
       ...
       disconnect conn
@
-}
renderConnInfo :: ConnectionInfo -> String
renderConnInfo ci = unwords . mapMaybe renderParam $
    [ ("host", host)
    , ("hostaddr", hostaddr)
    , ("port", port)
    , ("dbname", dbname)
    , ("user", user)
    , ("password", password)
    , ("connection_timeout", connection_timeout)
    , ("options", options)
    , ("tty", tty)
    , ("sslmode", sslmode)
    , ("requiressl",requiressl)
    , ("krbsrvname",krbsrvname)
    , ("service", service)
    ]
  where
    renderParam (key,getValue) =
        let value = getValue ci
        in if null value
            then Nothing
            else Just $ key ++ "=" ++ value
