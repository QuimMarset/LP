


-- Problema 1.1

shuffleOnce :: [a] -> [a]
shuffleOnce llista
    | even n = concat resultat
    | otherwise = concat resultat ++ [last meitat2]
    where
        n = length llista
        (meitat1,meitat2) = splitAt (n `div` 2) llista
        resultat = zipWith (\x y -> [y,x]) meitat1 meitat2

-- Problema 1.2

shuffleBack :: Eq a => [a] -> Int
shuffleBack llista = 1 + aux
    where
        aux = length.takeWhile (/= llista).tail $ iterate shuffleOnce llista


-- Problema 2.1

segments :: Ord a => [a] -> [[a]]
segments llista = foldr f [] llista
    where
        f :: Ord a => a -> [[a]] -> [[a]]
        f y [] = [[y]]
        f y llista@(x:xs)
            | y < head x     = (y:x):xs
            | otherwise = [y]:llista 

-- Problema 2.2

mergeSegments :: Ord a => [[a]] -> [[a]]
mergeSegments llista = map prefusiona $ separa llista
    where
        prefusiona :: Ord a => [[a]] -> [a]
        prefusiona [xs] = xs
        prefusiona [xs,ys] = fusiona xs ys

separa :: [[a]] -> [[[a]]]
separa llista = takeWhile (not.null).map (take 2) $ iterate (drop 2) llista
--takeWhile (not.null).map (fst).tail $ iterate (\(f,s) -> splitAt 2 s) ([],llista)

fusiona :: Ord a => [a] -> [a] -> [a]
fusiona [] ys = ys
fusiona xs [] = xs
fusiona (x:xs) (y:ys)
    | x <= y    = x:fusiona xs (y:ys)
    | otherwise = y:fusiona (x:xs) ys

-- Problema 2.3

mergeSegmentsort :: Ord a => [a] -> [a]
mergeSegmentsort llista = head $ until (\x -> (length x) == 1) mergeSegments $ segments llista


-- Problema 3.1

data FExpr a = Const a | Func String [FExpr a] deriving (Show)

-- Problema 3.2

flatten :: FExpr a -> FExpr a
flatten expr@(Const x) = expr
flatten (Func nom llistaArg) = Func nom $ concat $ map (f nom) flattenArgs
    where
        flattenArgs = map flatten llistaArg

        f :: String -> FExpr a -> [FExpr a]
        f _ expr@(Const x) = [expr]
        f nom expr@(Func nom2 llistaArg)
            | nom == nom2 = llistaArg
            | otherwise   = [expr]

-- Problema 3.3

instance (Eq a) => Eq (FExpr a) where 
    expr1 == expr2 = comprovaIgualtat (flatten expr1) (flatten expr2)


comprovaIgualtat :: (Eq a) => FExpr a -> FExpr a -> Bool
comprovaIgualtat (Const x) (Const y) = x == y
comprovaIgualtat (Func nom llistaArg) (Func nom2 llistaArg2) = nom == nom2 && igualPermutats llistaArg llistaArg2
comprovaIgualtat _ _ = False


igualPermutats :: (Eq a) => [FExpr a] -> [FExpr a] -> Bool
igualPermutats llistaArg llistaArg2 = and $ map (\expr -> aparicions expr llistaArg == 
    aparicions expr llistaArg2) llistaArg
    where
        aparicions :: (Eq a) => FExpr a -> [FExpr a] -> Int
        aparicions expr llistaExpr = length $ filter (== expr) llistaExpr
