--Problema 1

-- foldl va aplicando el merge a cada elemento junto el resultado de haberlo aplicado antes
mergelist :: Ord a => [[a]] -> [a]
mergelist = foldl merge []

--merge de una lista ordenada
merge :: Ord a => [a] -> [a] -> [a]
merge [] xs = xs
merge xs [] = xs
merge (x:xs) (y:ys)
	| x < y 	= x:(merge xs (y:ys))
	| x > y 	= y:(merge (x:xs) ys)
	| otherwise = x:(merge xs ys)


--Problema 2


mults :: [Integer] -> [Integer]
mults l = 1:mergelist (map (\x -> map (*x) (mults l)) l)


--Problema 3

--Problema 3.1

data Procs a = End | Skip (Procs a) | Unary (a -> a) (Procs a) | Binary (a -> a -> a) (Procs a)

--Problema 3.2

exec :: [a] -> (Procs a) -> [a]
exec [] _ 					= []
exec x End 					= x
exec (x:xs) (Skip p) 		= x:(exec xs p)
exec (x:xs) (Unary f p) 	= exec ((f x):xs) p
exec (x:[]) (Binary f p)	= exec ((f x x):[]) p
exec (x:y:xs) (Binary f p) 	= exec ((f x y):xs) p


--Problema 4

--Problema 4.1

class Container c where
	emptyC :: c a -> Bool
	lengthC :: c a -> Int
	firstC :: c a -> a
	popC :: c a -> c a

--Problema 4.2
instance Container [] where
	emptyC [] 	= True
	emptyC _ 	= False
	lengthC 	= length
	firstC 		= head
	popC 		= tail


--Problema 4.3
data Tree a = Empty | Node a [Tree a] deriving (Show)


--Problema 4.4

instance Container Tree where
	emptyC Empty 		= True
	emptyC _ 			= False
	lengthC Empty 		= 0
	lengthC (Node _ ts) = (+) 1 (sum (map lengthC ts))
	firstC (Node x _) 	= x
	popC (Node x [])	= Empty
	popC (Node x ts) = Node (firstC (head $ dropWhile emptyC ts)) (cuerpo (head $ dropWhile emptyC ts) ++ (tail $ dropWhile emptyC ts))

cuerpo :: Tree a -> [Tree a]
cuerpo (Node _ ts) = ts


iterator :: Container c => c a -> [a]
iterator x
	| emptyC x = []
	| otherwise = (firstC x):(iterator $ popC x)