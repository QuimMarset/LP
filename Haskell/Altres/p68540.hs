import Data.Char(digitToInt)


diffSqrs :: Integer -> Integer
diffSqrs x = abs $ quadSuma - sumaQuad
    where
        quadSuma = div (x * (x+1)) 2 ^ 2
        sumaQuad = foldl (\acc x -> acc + x*x) 0 [1..x]



pythagoreanTriplets :: Int -> [(Int, Int, Int)]
pythagoreanTriplets n = [(a,b,c) | a <- [1..n], b <- [a..n], c <- [b..n], a+b+c == n, a*a + b*b == c*c]



tartaglia :: [[Integer]]
tartaglia = iterate (\n -> zipWith (+) (0:n) (n ++ [0])) [1]



sumDigits :: Integer -> Integer
sumDigits n = sum $ map (toInteger.digitToInt) $ show n


digitalRoot :: Integer -> Integer
digitalRoot n = until (< 10) sumDigits n