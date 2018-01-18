allsets :: a -> [[a]]
allsets a = iterate (a:) []


alldivisors:: Int -> [[Int]]
alldivisors a = alldivisors2 a 2

alldivisors2 :: Int -> Int -> [[Int]]
alldivisors2 a b
	| a < b				= []
	| (mod a b) == 0 	= (timesDivisor a b):alldivisors2 a ((+1) b)
	| otherwise 		= alldivisors2 a ((+1) b)


timesDivisor :: Int -> Int -> [Int]
timesDivisor a b
	| (mod a b) == 0 	= b:timesDivisor (div a b) b
	| otherwise 		= []


data Expr a = Var String | Const a | Func String [(Expr a)] deriving (Show)


constLeafs :: Expr a -> [a]
constLeafs (Const a) 	= [a]
constLeafs (Func a t1)  = concat (map constLeafs t1)
constLeafs _ 			= []


instance Functor Expr where
	fmap g (Var x) 		= Var x
	fmap g (Const a) 	= Const (g a)
	fmap g (Func a t1)	= Func a (map (fmap g) t1)


join :: Eq a => [(String,a)] -> [(String,a)] -> Maybe [(String,a)]
join a b
	| correct a b 	= Just (join2 a b)
	| otherwise 	= Nothing


join2 :: Eq a => [(String,a)] -> [(String,a)] -> [(String,a)]
join2 [] [] 					= []
join2 [] a 						= a
join2 a []						= a
join2 ((a, an):x) ((b, bn):y)
	| (==) a b 					= [(a, an)]++join2 x y
	| (<) a b 					= [(a, an)]++join2 x ((b, bn):y)
	| otherwise 				= [(b, bn)]++join2 ((a, an):x) y

correct :: Eq a => [(String, a)] -> [(String, a)] -> Bool
correct [] [] 					= True
correct [] _					= True
correct _ []					= True
correct ((a, an):x) ((b, bn):y)
	| (&&) ((==) a b) ((/=) an bn)	= False
	| (==) a b					= correct x y
	| (<) a b					= correct x ((b, bn):y)
	| otherwise					= correct ((a, an):x) y


match :: Eq a => Expr a -> Expr a -> Maybe [(String,(Expr a))]