


eql :: [Int] -> [Int] -> Bool
eql xs ys = comprovacioMateixaLlardaga && comprovacioIguals
    where
        comprovacioMateixaLlardaga = length xs == length ys
        comprovacioIguals = foldl (\acc x -> acc && x) True $ zipWith (==) xs ys

prod :: [Int] -> Int
prod xs = foldl (\acc x -> acc*x) 1 xs

prodOfEvens :: [Int] -> Int 
prodOfEvens xs = prod $ filter (even) xs

powersOf2 :: [Int]
powersOf2 = scanl (\acc x -> acc*2) 1 [1..]
--powersOf2 = zipWith (^) [2,2..] [0..]

scalarProduct :: [Float] -> [Float] -> Float
scalarProduct xs ys = foldl (\acc x -> acc + x) 0 $ zipWith (*) xs ys