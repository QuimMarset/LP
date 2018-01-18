mconcat :: [[a]] -> [a]
mconcat l = [x | y <- l, x <- y]


concat3 :: [[[a]]] -> [a]
concat3 l = [x | z <- l, y <- z, x <- y]


fold2r :: (a -> b -> c -> c) -> c -> [a] -> [b] -> c
fold2r _ n [] _ = n
fold2r _ n _ [] = n
fold2r f n (x:xs) (y:ys) = f x y (fold2r f n xs ys)


mix:: [a] -> [a] -> [a]
mix a b = mix2 0 a b
	where
		mix2 _ [] b 	= b
		mix2 _ a [] 	= a
		mix2 0 (x:xs) b = x:(mix2 1 xs b)
		mix2 1 a (y:ys) = y:(mix2 0 a ys)


lmix:: [Int] -> [a] -> [a]
lmix [] l 		= l
lmix (x:xs) l 	= lmix xs (mix (take x l) (drop x l))


-- data BTree a = Empty | Node (BTree a) (BTree a) deriving (Show)

-- buildTreeF :: [[a]] -> BTree a
-- buildTreeF []		= Empty
-- buildTreeF (x:xs)	=


class Lit a where
	unary :: a -> a
	binary :: a -> a -> a
	list :: [a] -> a


data Expr a = Val a | Unary (Expr a) | Binary (Expr a) (Expr a) | List [Expr a] deriving (Show)


ex1 :: Expr Int
ex1 = Unary (Binary (List [Val 3, Unary (Val 2)]) (Val 8))


eval :: Lit a => Expr a -> a
eval (Val a) = a
eval (Unary a) = unary (eval a)
eval (Binary a b) = binary (eval a) (eval b)
eval (List t1) = list (map eval t1)


instance Lit Int where
	unary a = -a
	binary a b = a + b
	list t1 = sum t1 