prefsufs :: [a] -> [[a]]
prefsufs l = [take x l | x <- [1..len]]++[drop x l | x <- [1..(len-1)]]
	where len = length l


fixedPoint :: Eq a => (a -> a) -> a -> a
fixedPoint f x
	| (==) (f x) x 	= x
	| otherwise 	= fixedPoint (f) (f x)



data Polynomial a = P [a]


instance Eq (Polynomial a) where
	(==) (P a) (P b) = (==) a b