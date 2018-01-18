


-- Problema 1

mergelist :: Ord a => [[a]] -> [a]
mergelist [] = []
mergelist (x:xs) = foldl fusiona x xs
    where
        fusiona :: Ord a => [a] -> [a] -> [a]
        fusiona xs [] = xs
        fusiona [] ys = ys
        fusiona (x:xs) (y:ys)
            | x > y     = y:(fusiona (x:xs) ys)
            | x < y     = x:(fusiona xs (y:ys))
            | otherwise = x:(fusiona xs ys)


-- Problema 2

mults :: [Integer] -> [Integer]
mults llista = 1:(mergelist $ map (\x -> map (*x) $ mults llista) llista)


-- Problema 3.1

data Procs a = End | Skip (Procs a) | Unary (a -> a) (Procs a) | Binary (a -> a -> a) (Procs a)

-- Problema 3.2

exec :: [a] -> (Procs a) -> [a]
exec [] _ = []
exec llista (End) = llista
exec (x:xs) (Skip seqProces) = x:exec xs seqProces
exec (x:xs) (Unary funcio seqProces) = exec ((funcio x):xs) seqProces
exec [x] (Binary funcio seqProces) = exec [(funcio x x)] seqProces
exec (x1:x2:xs) (Binary funcio seqProces) = exec ((funcio x1 x2):xs) seqProces


--Problema 4.1

class Container c where
    emptyC :: c a -> Bool
    lengthC :: c a -> Int
    firstC :: c a -> a
    popC :: c a -> c a

-- Problema 4.2

instance Container [] where
    emptyC xs = null xs
    lengthC xs = length xs
    firstC (x:xs) = x
    popC (x:xs) = xs

-- Problema 4.3

data Tree a = Empty | Node a [Tree a] deriving (Show)

-- Problema 4.4

instance Container Tree where
    emptyC (Empty) = True
    emptyC _ = False
    lengthC (Empty) = 0
    lengthC (Node a llistaArbres) = 1 + (sum $ map lengthC llistaArbres)
    firstC (Node a _) = a
    popC (Node a []) = Empty
    popC (Node a llistaArbres) = construirArbre fillsSenseEmptysPrincipi
        where
            fillsSenseEmptysPrincipi = dropWhile emptyC llistaArbres
            construirArbre :: [Tree a] -> Tree a
            construirArbre ((Node a fills):xs) = Node a (fills ++ xs)
            construirArbre [] = Empty

-- Problema 4.5

iterator :: Container c => c a -> [a]
iterator contenidor
    | emptyC contenidor = []
    | otherwise         = map (firstC).takeWhile (not.emptyC) $ iterate popC contenidor 

