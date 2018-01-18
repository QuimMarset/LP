


countIf :: (Int -> Bool) -> [Int] -> Int
countIf p = foldl (\acc x -> if p x then acc+1 else acc) 0 

pam :: [Int] -> [Int -> Int] -> [[Int]]
pam xs = map (\f -> map f xs)

pam2 :: [Int] -> [Int -> Int] -> [[Int]]
pam2 xs funcions = map (\x -> map (\f -> f x) funcions) xs

filterFoldl :: (Int -> Bool) -> (Int -> Int -> Int) -> Int -> [Int] -> Int
filterFoldl p f = foldl (\acc x -> if p x then f acc x else acc) 
--foldl f acc $ filter p xs

insert :: (Int -> Int -> Bool) -> [Int] -> Int -> [Int]
insert p xs elem = takeWhile predicatFlip xs ++ [elem] ++ dropWhile predicatFlip xs
    where 
        predicatFlip = flip p elem
--foldl (\acc x -> if p x elem then acc ++ [x] else acc ++ [elem,x] ) [] xs 

insertionSort :: (Int -> Int -> Bool) -> [Int] -> [Int]
insertionSort p = foldl (\acc x -> insert p acc x) []