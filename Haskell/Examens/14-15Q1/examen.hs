


-- Problema 1

prefsufs:: [a] -> [[a]]
prefsufs (x:xs) = prefixos ++ sufixos
    where
        prefixos = scanl (\acc elem -> acc ++ [elem]) [x] xs
        sufixos = takeWhile (not.null) $ iterate tail xs


-- Problema 2.1

fixedPoint :: (Eq a) => (a -> a) -> a -> a
fixedPoint f x = fst $ until (\(p,s) -> p == s) (\(p,s) -> (s,f s)) (x,f x) 

-- Problema 2.2

newton :: Float -> Float
newton y = fixedPoint (\x -> (y / x + x) / 2.0) 1.0


-- Problema 3.1

data Polynomial a = Polynomial [a] deriving (Show)

instance (Eq a, Num a) => Eq (Polynomial a) where
     polinomi1 == polinomi2 = comprovaIgual polinomi1 polinomi2
        where
            comprovaIgual :: (Eq a, Num a) => Polynomial a -> Polynomial a -> Bool
            comprovaIgual (Polynomial coef1) (Polynomial coef2) 
                | n1 == n2  = resultatZip
                | n1 > n2   = resultatZip && (all (== 0) $ drop n2 coef1)
                | otherwise = resultatZip && (all (== 0) $ drop n1 coef2)
                where
                    n1 = length coef1
                    n2 = length coef2
                    resultatZip = and $ zipWith (==) coef1 coef2


-- Problema 3.2

instance (Num a) => Num (Polynomial a) where
    abs (Polynomial coef) = Polynomial (map abs coef)
    signum polinomi@(Polynomial []) = polinomi
    signum (Polynomial (x:xs)) = Polynomial ((signum x):xs)
    fromInteger x = Polynomial [fromInteger x]
    (Polynomial coef1) + (Polynomial coef2) = Polynomial (zipWith (+) coef1 coef2)
    (Polynomial coef1) * (Polynomial coef2) = Polynomial (producteCoef coef1 coef2)

producteCoef :: (Num a) => [a] -> [a] -> [a]
producteCoef coef1 coef2 = zipWith (\l1 l2 -> sum $ zipWith (*) l1 l2) prefSuf1 prefSuf2
    where
        prefSuf1 = prefsufs coef1
        prefSuf2 = map reverse $ prefsufs coef2 


-- Problema 4.1

data AndOr a = ALeaf a | Nand [AndOrAux a] deriving(Show)
data AndOrAux a = Nor [AndOr a] | OLeaf a deriving (Show)

-- Problema 4.2

eval :: (a -> Bool) -> (AndOr a) -> Bool
eval predicat (ALeaf x) = predicat x
eval predicat (Nand llistaNodeOr) = and $ map (eval' predicat) llistaNodeOr
    where
        eval' :: (a -> Bool) -> (AndOrAux a) -> Bool
        eval' predicat (OLeaf x) = predicat x
        eval' predicat (Nor llistaNodeAnd) = or $ map (eval predicat) llistaNodeAnd