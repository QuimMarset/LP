


-- Problema 1

allsets :: a -> [[a]]
allsets x = iterate (x:) []


-- Problema 2

alldivisors:: Int -> [[Int]]
alldivisors x = [f x y | y <- [2..x], x `mod` y == 0]
    where
        f :: Int -> Int -> [Int]
        f x y = map snd.takeWhile (\(f,s) -> f `mod` s == 0) $ iterate (\(f,s) -> (f `div` s,s)) (x,y)


-- Problema 3.1

data Expr a = Var String | Const a | Func String [Expr a] deriving (Show,Eq)

-- Problema 3.2

constLeafs :: Expr a -> [a]
constLeafs constant@(Const x) = [x]
constLeafs (Var _) = []
constLeafs (Func _ llistaExpr) = concat $ map constLeafs llistaExpr

-- Problema 3.3

instance Functor Expr where
    fmap funcio (Var x) = Var x
    fmap funcio (Const x) = Const (funcio x)
    fmap funcio (Func nom llistaExpr) = (Func nom (map (fmap funcio) llistaExpr)) 


-- Problema 4

join :: Eq a => [(String,a)] -> [(String,a)] -> Maybe [(String,a)]
join xs [] = Just xs
join [] ys = Just ys
join (x@(clau1,valor1):xs) (y@(clau2,valor2):ys)
    | clau1 > clau2 = join (x:xs) ys >>= (\assig -> Just (y:assig))
    | clau1 < clau2 = join xs (y:ys) >>= (\assig -> Just (x:assig))
    | otherwise     = join xs ys >>= (\assig -> if valor1 == valor2 then Just (x:assig) else Nothing)
 

-- Problema 5

match:: Eq a => Expr a -> Expr a -> Maybe [(String,(Expr a))]
match (Const x) (Const y) 
    | x == y    = Just []
    | otherwise = Nothing
match (Var nom1) expr2 = Just [(nom1,expr2)]
match (Func nom llistaExpr) (Func nom2 llistaExpr2)
    | nom == nom2 = comprovaAssignacio $ zipWith match llistaExpr llistaExpr2
    | otherwise   = Nothing
    where
        comprovaAssignacio :: (Eq a) => [Maybe [(String,(Expr a))]] -> Maybe [(String,(Expr a))]
        comprovaAssignacio assignacionsParcials
            | Nothing `elem` assignacionsParcials = Nothing
            | otherwise                           = 
                let
                 assignacionsFlat = concat $ map (\(Just assigs) -> assigs) assignacionsParcials
                 n = length assignacionsFlat `div` 2
                 (esq,dre) = splitAt n assignacionsFlat
                in join esq dre


match _ _ = Nothing


