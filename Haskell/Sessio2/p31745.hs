

flatten :: [[Int]] -> [Int]
flatten xs = foldl (++) [] xs

myLength :: String -> Int
myLength s = foldl (\acc c -> acc + 1) 0 s

myReverse :: [Int] -> [Int]
myReverse xs = foldl (\acc x -> x:acc) [] xs

countIn :: [[Int]] -> Int -> [Int]
countIn xs elem = map (\subLlista -> foldl (\acc x -> if x == elem then acc+1 else acc) 0 subLlista) xs

firstWord :: String -> String
firstWord s = takeWhile (/= ' ') . dropWhile (== ' ') $ s