


absValue :: Integer -> Integer
absValue x
	| x > 0 = x
	| otherwise = x*(-1)


power :: Integer -> Integer -> Integer
power x n
	| n == 0 = 1
	| even n = y*y
	| otherwise = y*y*x
	where y = power x $ div n 2



isPrime :: Integer -> Bool
isPrime 0 = False
isPrime 1 = False
isPrime x = isPrime' 2
	where
		isPrime' :: Integer -> Bool
		isPrime' y
			| y*y > x = True
			| x `mod` y == 0 = False
			| otherwise = isPrime'(y+1)


slowFib :: Integer -> Integer
slowFib 0 = 0
slowFib 1 = 1
slowFib x = slowFib (x-2) + slowFib (x-1)




quickFib :: Integer -> Integer
quickFib x = snd $ quickFib' x

quickFib':: Integer -> (Integer,Integer)
quickFib' 0 = (0,0)
quickFib' 1 = (0,1)
quickFib' n = (fibMenys1,fibMenys2+fibMenys1)
	where (fibMenys2,fibMenys1) = quickFib' (n-1)
