


fact1 :: Integer -> Integer
fact1 0 = 1
fact1 n = n*fact1 (n-1)

fact2 :: Integer -> Integer
fact2 n = fact2' n 1
    where
        fact2' 0 acc = acc
        fact2' n acc = fact2' (n-1) (n*acc)

fact3 :: Integer -> Integer
fact3 n = product [1..n]

fact4 :: Integer -> Integer
fact4 n
    | n == 0 = 1
    | otherwise = n*fact4(n-1)

fact5 :: Integer -> Integer
fact5 n = if n == 0 then 1 else n*fact5(n-1)

fact6 :: Integer -> Integer
fact6 0 = 1
fact6 n = last.take (fromInteger n) $ 1:fact6'
    where
        fact6' = 2 : 6 : zipWith (*) [4..] (tail fact6')

fact7 :: Integer -> Integer
fact7 n = foldl (*) 1 [1..n]

fact8 :: Integer -> Integer
fact8 0 = 1
fact8 n =  (\(a,b) -> a*b).last.take (fromInteger n) $  iterate (\(f,s) -> (f*s,s+1)) (1,1)


