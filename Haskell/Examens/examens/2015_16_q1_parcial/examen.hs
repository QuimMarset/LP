 quadrats :: [Integer]
 quadrats = map (\x -> x*x) (iterate (+1) 1)

 -- sumQuadrats::Integer -> Bool
 -- sumQuadrats a 	= esta a (comb lis len)
 -- 	where
 -- 		lis = (filter (<a) quadrats)
 -- 		len = length lis
 -- 		comb l le = []

 conway :: [Int]
 conway = iterate gencon [1,1]
 	where
 		gencon l = [((+) (selem its l) (selem ((-) (length l) ((-) its 1)) l))]
 			where
 				its = (last l)
 				selem n (x:xs)
 					| n <= 1 	= x
 					| otherwise = selem (n-1) xs