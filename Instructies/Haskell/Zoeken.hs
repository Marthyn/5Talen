----------------------------------------------------------------
--                                                            --
--                                                            --
--                                                            --
--  Zoeken                                                    --
--                                                            --
--  Jan van Eijck, Spring 2005                                --
--                                                            --
--  extended in Summer 2010                                   --
--                                                            --
--                                                            --
----------------------------------------------------------------

module Zoeken where 

import List
import Char
import System.IO.Unsafe (unsafePerformIO)

data Dcat = ADJ
          | BW 
          | ITJ
          | LID
          | N
          | TSW
          | TW
          | VNW
          | VNZ
          | VW
          | VWN
          | VZ
          | WW
          | Unknown
          deriving (Eq,Ord,Read)

type Ecat = String 

type LexItem = (String, String, String, Ecat) 

string2lexitem :: String  -> LexItem
string2lexitem str = (x, y, z, w) where 
  (x,str1) = break isSpace str
  (y,str2) = break isSpace (dropWhile isSpace str1)
  (z,str3) = break isSpace (dropWhile isSpace str2)
  w        = dropWhile isSpace str3

getLex :: FilePath -> IO ([LexItem])
getLex filename = do 
  xs <- readFile filename
  return (map string2lexitem (lines xs))

getL :: FilePath -> [LexItem]
getL filename = unsafePerformIO (getLex filename)

lexNE = getL "wbNE.txt"

zoek :: String -> [LexItem]
zoek str = [ (x,y,z,w) | (x,y,z,w) <- lexNE, str == x ]

cat :: String -> [LexItem]
cat c = [ (x,y,z,w) | (x,y,z,w) <- lexNE, c == y ]

catsN :: String -> [String]
catsN str = nub $ sort $ [ y | (x,y,z,w) <- zoek str ]

catsE :: String -> [String]
catsE str = nub $ sort $ [ w | (x,y,z,w) <- search str ]

search :: String -> [LexItem]
search str = [ (x,y,z,w) | (x,y,z,w) <- lexNE, str == z ]

equiv :: String -> [LexItem]
equiv str = 
  concat [ search z | (_,_,z,_) <- zoek str ]

equivR :: String -> [LexItem]
equivR str = 
  concat [ zoek x | (x,_,_,_) <- search str ]

equivN :: String -> [String]
equivN str = 
  nub $ sort $ 
  [ x | (x,y,_,_) <- equiv str, 
         str /= x, 
         elem  y (catsN str) ]

equivNsense :: String -> String -> [String]
equivNsense str sense = 
  nub $ sort $ 
  [ x | (x,y,z,_) <- equiv str, 
         str /= x, 
         z == sense,
         elem  y (catsN str) ]

equivNC ::  String -> String -> [String]
equivNC str cat = 
  nub $ sort $ [ x | (x,y,_,_) <- equiv str, str /= x, cat == y ]
                          
equivE :: String -> [String]
equivE str = 
  nub $ sort $ 
  [ z | (_,_,z,w) <- equivR str, 
        str /= z, 
        elem w (catsE str) ]

equivEsense :: String -> String -> [String]
equivEsense str sense =
  nub $ sort $ 
  [ z | (x,_,z,w) <- equivR str, 
        str /= z, 
        x == sense,
        elem w (catsE str) ]

equivEC :: String -> String -> [String]
equivEC str cat = 
  nub $ sort $ [ z | (_,_,z,w) <- equivR str, str /= z, cat == w ]

dcats :: [String]
dcats = nub $ sort $ [ y | (_,y,_,_) <- lexNE ]

ecats :: [String]
ecats = nub $ sort $ [ w | (_,_,_,w) <- lexNE ]
