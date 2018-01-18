


-- Problema 1.1

quadrats::[Integer]
quadrats = map (\x -> x*x) $ iterate (+1) 1

-- Problema 1.2

{-sumQuadrats::Integer -> Bool
sumQuadrats n = last llistaCandidats == n || comprova n llistaCandidats
    where
        llistaCandidats = takeWhile (<= n) quadrats
        comprova :: Integer -> [Integer] -> Bool
        comprova n llista =-}

-- Problema 2

conway :: [Integer]
conway = 1:(map last $ iterate conway' [1,1])
    where
        conway' :: [Integer] -> [Integer]
        conway' seqAct = seqAct ++ [resultat]
            where
                n = length seqAct
                ultim = fromInteger $ last seqAct
                resultat = (last $ take ultim seqAct) + (head $ drop (n - ultim) seqAct)


-- Problema 3.1

dc :: (a -> Bool) -> (a -> b) -> (a -> [a]) -> (a -> [b] -> b) -> a -> b
dc trivial resol parteix combina problema
    | trivial problema = resol problema
    | otherwise        = (combina problema).map (dc trivial resol parteix combina) $ parteix problema

-- Problema 3.2

quicksort:: Ord a => [a] -> [a]
quicksort llista = dc trivial resol parteix combina llista
    where
        trivial :: [a] -> Bool
        trivial [] = True
        trivial [x] = True
        trivial _ = False

        resol :: [a] -> [a]
        resol [] = []
        resol [x] = [x]

        parteix :: (Ord a) => [a] -> [[a]]
        parteix (x:xs) = [esq,dre]
            where
                esq = [elem | elem <- xs, elem < x]
                dre = [elem | elem <- xs, elem >= x]

        combina :: [a] -> [[a]] -> [a]
        combina (x:xs) ([y1,y2]) = y1 ++ [x] ++ y2


-- Problema 4.1

data GTree a = Empty | Node a [GTree a] deriving(Show)

flat :: (Eq a) => GTree a -> GTree a
flat (Empty) = Empty
flat (Node arrel llistaArbres) = Node arrel (concat $ map (comprova arrel) fillsAplanats)
    where
        fillsAplanats = map flat llistaArbres

        comprova :: (Eq a) => a -> GTree a -> [GTree a]
        comprova _ (Empty) = [Empty]
        comprova arrel node@(Node arrel2 llistaArbres)
            | arrel == arrel2 = llistaArbres
            | otherwise       = [node]

-- Problema 4.2

instance (Eq a) => Eq (GTree a) where
    arbre1 == arbre2 = comprovaIguals (flat arbre1) (flat arbre2)

comprovaIguals :: (Eq a) => GTree a -> GTree a -> Bool
comprovaIguals (Empty) (Empty) = True
comprovaIguals (Node arrel1 llistaArbres1) (Node arrel2 llistaArbres2)
    | arrel1 == arrel2 && permutacioIgual llistaArbres1 llistaArbres2 = True
    | otherwise                                                       = False
    where
        permutacioIgual :: (Eq a) => [GTree a] -> [GTree a] -> Bool
        permutacioIgual llista1 llista2 = and $ map (\arbre -> occurencies arbre llista1 == occurencies arbre llista2) llista1
            where
                occurencies :: (Eq a) => GTree a -> [GTree a] -> Int
                occurencies arbre llista = length $ filter (== arbre) llista

comprovaIguals _ _ = False