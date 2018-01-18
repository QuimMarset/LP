

-- Problema 1.1

mconcat':: [[a]] -> [a]
mconcat' llistes = [x | llista <- llistes, x <- llista]

-- Problema 1.2

concat3:: [[[a]]] -> [a]
concat3 llistesLlistes = [x | llistes <- llistesLlistes, llista <- llistes, x <- llista]


-- Problema 2

fold2r::(a -> b -> c -> c) -> c -> [a] -> [b] -> c
fold2r funcio acc llista1 llista2 = foldr (\(e1,e2) acc -> funcio e1 e2 acc) acc $ zip llista1 llista2


-- Problema 3

mix:: [a] -> [a] -> [a]
mix xs ys
    | n1 > n2   = resultatZip ++ drop n2 xs
    | n1 < n2   = resultatZip ++ drop n1 ys
    | otherwise = resultatZip
    where
        n1 = length xs
        n2 = length ys
        resultatZip = concat $ zipWith (\x y -> [x,y]) xs ys


lmix:: [Int] -> [a] -> [a]
lmix llistaSplit llista = foldl funcioDiv llista llistaSplit
    where
        funcioDiv :: [a] -> Int -> [a]
        funcioDiv llista elem = mix esq dre
            where
                (esq,dre) = splitAt elem llista


-- Problema 4

dPascal :: Int -> [Integer]
dPascal numDiag = map (\n -> factorial n `div` (factorial numDiag' * factorial (n-numDiag'))) [numDiag'..]
    where
        numDiag' = fromIntegral numDiag
        factorial :: Integer -> Integer
        factorial n = foldl (*) 1 [1..n]


-- Problema 5 

data BTree a = Empty | Node a (BTree a) (BTree a) deriving(Show)

buildTreeF :: [[a]] -> BTree a
buildTreeF llistaNivells = head $ buildTreeF' llistaNivells
    where
        buildTreeF' :: [[a]] -> [BTree a]
        buildTreeF' [] = [Empty]
        buildTreeF' [x] = map (\x -> Node x Empty Empty) x
        buildTreeF' (x:xs) = construeixNivell x construitResta ++ construitResta 
            where
                construitResta = buildTreeF' xs
                construeixNivell :: [a] -> [BTree a] -> [BTree a]
                construeixNivell [] _ = []
                construeixNivell (x:xs) arbresNivellInf
                    | n == 2    = let [esq,dre] = act in (Node x esq dre):construeixNivell xs resta
                    | n == 1    = (Node x (head act) Empty):construeixNivell xs resta
                    | otherwise = (Node x Empty Empty):construeixNivell xs resta
                    where
                        (act,resta) = splitAt 2 arbresNivellInf
                        n = length act


-- Problema 6.1

class Lit a where
    unary :: a -> a
    binary :: a -> a -> a
    list :: [a] -> a

-- Problema 6.2

data Expr a = Val a | Unary (Expr a) | Binary (Expr a) (Expr a) | List [Expr a] deriving(Show)

-- Problema 6.3

eval :: (Lit a) => Expr a -> a
eval (Val x) = x
eval (Unary expr) = unary $ eval expr
eval (Binary expr1 expr2) = binary (eval expr1) (eval expr2)
eval (List llistaExpr) = list $ map eval llistaExpr

-- Problema 6.4

instance Lit Int where
    unary x = (-x)
    binary x y = x + y
    list llista = sum llista


