import Data.Char (isDigit)
import Debug.Trace (trace)

data Number = Number
  { value :: Int,
    index :: Int
  }
  deriving (Show)

main = do
  file <- readFile "input.txt"
  putStrLn ("Task 1: " ++ show (parseLinesForSumOfValidNumbers ("" : lines file)))
  putStrLn ("Task 2: " ++ show (parseLinesForSumOfGearRatios ("" : lines file)))

-- task 1

parseLinesForSumOfValidNumbers :: [String] -> Int
parseLinesForSumOfValidNumbers [] = 0
parseLinesForSumOfValidNumbers [_] = 0
parseLinesForSumOfValidNumbers [x, y] =
  let numbers = getNumbersFromRow y
   in getSumOfValidNumbers numbers [x, y]
parseLinesForSumOfValidNumbers (x : y : z : xs) =
  let numbers = getNumbersFromRow y
   in getSumOfValidNumbers numbers [x, y, z] + parseLinesForSumOfValidNumbers (y : z : xs)

getNumbersFromRow :: String -> [Number]
getNumbersFromRow = getNumbersFromRowWithIndex 0

getNumbersFromRowWithIndex :: Int -> String -> [Number]
getNumbersFromRowWithIndex _ [] = []
getNumbersFromRowWithIndex index (x : xs)
  | isDigit x =
      Number
        { value = read (x : getNextDigits xs) :: Int,
          index = index
        }
        : getNumbersFromRowWithIndex (index + length (getNextDigits xs) + 1) (skipNextDigits xs)
  | otherwise = getNumbersFromRowWithIndex (index + 1) xs

getNextDigits :: String -> String
getNextDigits [] = []
getNextDigits (x : xs)
  | isDigit x = x : getNextDigits xs
  | otherwise = []

skipNextDigits :: String -> String
skipNextDigits [] = []
skipNextDigits all@(x : xs)
  | isDigit x = skipNextDigits xs
  | otherwise = all

isNextToSymbol :: Int -> Int -> String -> Bool
isNextToSymbol _ _ [] = False
isNextToSymbol start len row = not (all (\x -> (x == '.') || isDigit x) (getRelevantString start len row))

getRelevantString :: Int -> Int -> String -> String
getRelevantString start len row = take (len + 2) (drop (max 0 (start - 1)) row)

isValidNumber :: Number -> String -> Bool
isValidNumber Number {value, index} = isNextToSymbol index (length (show value))

getSumOfValidNumbers :: [Number] -> [String] -> Int
getSumOfValidNumbers [] _ = 0
getSumOfValidNumbers (x : xs) rows =
  (if any (isValidNumber x) rows then let Number {value} = x in value else 0)
    + getSumOfValidNumbers xs rows

-- task 2

parseLinesForSumOfGearRatios :: [String] -> Int
parseLinesForSumOfGearRatios [] = 0
parseLinesForSumOfGearRatios [_] = 0
parseLinesForSumOfGearRatios [x, y] =
  let numbers = getNumbersFromRow x ++ getNumbersFromRow y
   in let gears = getPotentialGearIndexes y
       in sum (map (getGearRatioFromPotentialGearIndex numbers) gears)
parseLinesForSumOfGearRatios (x : y : z : xs) =
  let numbers = getNumbersFromRow x ++ getNumbersFromRow y ++ getNumbersFromRow z
   in let gears = getPotentialGearIndexes y
       in sum (map (getGearRatioFromPotentialGearIndex numbers) gears) + parseLinesForSumOfGearRatios (y : z : xs)

getPotentialGearIndexes :: String -> [Int]
getPotentialGearIndexes = getPotentialGearIndexesWithIndex 0

getPotentialGearIndexesWithIndex :: Int -> String -> [Int]
getPotentialGearIndexesWithIndex _ [] = []
getPotentialGearIndexesWithIndex i (x : xs)
  | x == '*' =
      i : getPotentialGearIndexesWithIndex (i + 1) xs
  | otherwise = getPotentialGearIndexesWithIndex (i + 1) xs

getNumbersAdjacentToGear :: Int -> [Number] -> [Number]
getNumbersAdjacentToGear _ [] = []
getNumbersAdjacentToGear gear (Number {index, value} : xs) =
  if gear >= (index - 1) && gear < (index + length (show value) + 1) then Number {index, value} : getNumbersAdjacentToGear gear xs else getNumbersAdjacentToGear gear xs

getGearRatioFromPotentialGearIndex :: [Number] -> Int -> Int
getGearRatioFromPotentialGearIndex numbers gear =
  case getNumbersAdjacentToGear gear numbers of
    [Number {value = v1}, Number {value = v2}] -> v1 * v2
    _ ->  0
