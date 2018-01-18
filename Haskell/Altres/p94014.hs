


fib :: Int -> Integer
fib 0 = 0
fib 1 = 1
fib n = head $ head $ fibMatriu (n-1) [[1,1],[1,0]]


fibMatriu :: Int -> [[Integer]] -> [[Integer]]
fibMatriu n matriu
    | n == 1 = matriu
    | even n = producteMatrius prod $ transpose prod
    | otherwise = producteMatrius (producteMatrius prod $ transpose prod) $ transpose matriu
    where
        prod = fibMatriu (n `div` 2) matriu

transpose :: [[Integer]] -> [[Integer]]
transpose ([]:_) = []
transpose matriu = map (head) matriu:(transpose $ map (tail) matriu)


producteMatrius :: [[Integer]] -> [[Integer]] -> [[Integer]]
producteMatrius m1 m2 = map (\fila -> calculaFila fila m2) m1
    where
        calculaFila :: [Integer] -> [[Integer]] -> [Integer]
        calculaFila fila matriu = map (\fila2 -> sum $ zipWith (*) fila fila2) matriu 
