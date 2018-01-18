


fizzBuzz :: [Either Int String]
fizzBuzz = map funcio $ [0..]
	where
		funcio :: Int -> Either Int String
		funcio x
			| x `mod` 3 == 0 && x `mod` 5 == 0 = Right "FizzBuzz"
			| x `mod` 3 == 0 = Right "Fizz"
			| x `mod` 5 == 0 = Right "Buzz"
			| otherwise = Left x