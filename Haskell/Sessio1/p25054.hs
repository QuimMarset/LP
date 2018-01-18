


myLength :: [Int] -> Int
myLength [] = 0
myLength (x:xs) = 1 + myLength xs


myMaximum :: [Int] -> Int
myMaximum [x] = x
myMaximum (x:xs)
    | x > maximResta = x
    | otherwise = maximResta
    where maximResta = myMaximum xs


average :: [Int] -> Float
average l = fromIntegral (sum l) / fromIntegral (myLength l)
    where 
        sum [] = 0
        sum (x:xs) = x + sum xs


buildPalindrome :: [Int] -> [Int]
buildPalindrome l = inversa l ++ l
    where
        inversa [] = []
        inversa (x:xs) = inversa xs ++ [x]


remove :: [Int] -> [Int] -> [Int]
remove [] ys = []
remove (x:xs) ys
    | pertany x ys = restants
    | otherwise = x:restants
    where 
        restants = remove xs ys
        pertany x [] = False
        pertany x (y:ys) = x == y || comprovacioRestant
            where comprovacioRestant = pertany x ys



flatten :: [[Int]] -> [Int]
flatten [] = []
flatten (x:xs) = x ++ flatten xs


oddsNevens :: [Int] -> ([Int],[Int])
oddsNevens [] = ([],[])
oddsNevens (x:xs)
    | even x = (senars,x:parells)
    | otherwise = (x:senars,parells)
    where (senars,parells) = oddsNevens xs



primeDivisors :: Int -> [Int]
primeDivisors x = primeDivisors' [2..x]
    where 
        primeDivisors' [] = []
        primeDivisors' (y:ys)
            | isPrime y && x `mod` y == 0 = y:restaPrimers
            | otherwise = restaPrimers
            where
                restaPrimers = primeDivisors' ys
                isPrime 0 = False
                isPrime 1 = False
                isPrime z = isPrime' 2
                    where
                        isPrime' u
                            | u*u > z = True
                            | z `mod` u == 0 = False
                            | otherwise = isPrime' (u+1)



