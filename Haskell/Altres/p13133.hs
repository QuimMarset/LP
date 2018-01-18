



sumMultiples35 :: Integer -> Integer
sumMultiples35 n = sumMultiplesNLim 3 n + sumMultiplesNLim 5 n - sumMultiplesNLim 15 n

sumMultiplesNLim :: Integer -> Integer -> Integer
sumMultiplesNLim n lim = progAritm
    where
        numMult = (lim-1) `div` n
        termeUlt = n + (numMult - 1)*n
        progAritm = numMult*(n + termeUlt) `div` 2
        -- suma dels numMult primers termes multiples de n


fibonacci :: Int -> Integer
fibonacci n = seqFib !! n
    where
        seqFib = map fst $ iterate (\(f,s) -> (s,f+s)) (0,1)


sumEvenFibonaccis :: Integer -> Integer
sumEvenFibonaccis n = sumEvenFibonaccis' n (0,1)
    where
        sumEvenFibonaccis' n (ant2,ant)
            | fib < n && fib `mod` 2 == 0  = fib + sumEvenFibonaccis' n (ant,ant+ant2)
            | fib < n && fib `mod` 2 /= 0 = sumEvenFibonaccis' n (ant,fib)
            | otherwise = 0
            where 
                fib = ant + ant2


largestPrimeFactor :: Int -> Int
largestPrimeFactor n = maximum $ factorsPrimers 2 n

factorsPrimers :: Int -> Int -> [Int]
factorsPrimers p n
    | p*p > n = [n]
    | n `mod` p == 0 = p:factorsPrimers p (n `div` p)
    | otherwise = factorsPrimers (p+1) n


isPalindromic :: Integer -> Bool
isPalindromic n = reverse nString == nString
    where
       nString = show n
