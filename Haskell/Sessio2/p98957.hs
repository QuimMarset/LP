


ones :: [Integer]
ones = iterate id 1

nats :: [Integer]
nats = iterate (+1) 0

ints :: [Integer] 
ints = 0:(foldr (\x acc -> x:(-x):acc) [] $ iterate (+1) 1)

triangulars :: [Integer]
triangulars = scanl (+) 0 $ iterate (+1) 1

factorials :: [Integer]
factorials = scanl (*) 1 $ iterate (+1) 1

fibs :: [Integer]
fibs = 0:1:zipWith (+) fibs (tail fibs)

primes :: [Integer]
primes = filtraNumeros  $ iterate (+1) 2
    where
        filtraNumeros :: [Integer] -> [Integer]
        filtraNumeros (x:xs) = x:(filtraNumeros $ filter (\y -> y `mod` x /= 0) xs)

hammings :: [Integer] 
hammings = 1:map (*2) hammings `merge` map (*3) hammings `merge` map (*5) hammings
    where 
        merge :: [Integer] -> [Integer] -> [Integer]
        merge [] ys = ys
        merge xs [] = xs
        merge (x:xs) (y:ys)
            | x > y = y:merge (x:xs) ys
            | x < y = x:merge xs (y:ys)
            | otherwise = x:merge xs ys


lookNsay :: [Integer]
lookNsay = iterate (\x -> read . comptaNumeros 1 $ show x ::Integer) 1
    where
        comptaNumeros :: Integer -> String -> String
        comptaNumeros acc [x]  = show acc ++ [x]
        comptaNumeros acc (x1:x2:xs)
            | x1 == x2 = comptaNumeros (acc+1)  (x2:xs) 
            | otherwise = show acc ++ [x1] ++ comptaNumeros 1 (x2:xs)

tartaglia :: [[Integer]] 
tartaglia = iterate (\l -> zipWith (+) (0:l) (l ++ [0])) [1]