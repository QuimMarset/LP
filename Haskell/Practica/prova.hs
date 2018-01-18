

words' :: Char -> String -> [String]
words' separador [] = []
words' separador cadena@(x:xs)
	| x == separador = words' separador xs
	| otherwise = 
		let 
			(element,resta) = span (/= separador) cadena
		in
			element:words' separador resta
