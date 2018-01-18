


data AVL a = E | N a Int (AVL a) (AVL a) -- l’enter guarda l’alçada
         deriving (Show)


insert :: Ord a => AVL a -> a -> AVL a
insert (E) x = N x 0 E E
insert avl@(N a h avlE avlD) x
    | x == a    = avl
    | x > a     = equilibra $ N a h avlE (insert avlD x)
    | otherwise = equilibra $ N a h (insert avlE x) avlD
    

equilibra :: AVL a -> AVL a
equilibra avl@(N x _ avlE avlD)
    | diferenciaED >= 2 && diferenciaEED >= 1   = girEE avl
    | diferenciaED >= 2 && diferenciaEED <= -1  = girED avl
    | diferenciaED <= -2 && diferenciaDED >= 1  = girDE avl
    | diferenciaED <= -2 && diferenciaDED <= -1 = girDD avl
    | otherwise                                 = 
        let
            altura = 1 + max (obtenirAltura avlE) (obtenirAltura avlD)
        in N x altura avlE avlD
    where
        diferenciaED = diferenciaAltures avl
        diferenciaEED = diferenciaAltures avlE
        diferenciaDED = diferenciaAltures avlD


girEE :: AVL a -> AVL a
girEE (N x _ (N x2 _ avlE2 avlD2) avlD) = N x2 hNova avlE2 (N x hNova2 avlD2 avlD)
    where
        hNova2 = 1 + max (obtenirAltura avlD2) (obtenirAltura avlD)
        hNova = 1 + max (obtenirAltura avlE2) hNova2


girDD :: AVL a -> AVL a
girDD (N x _ avlE (N x2 _ avlE2 avlD2)) = N x2 hNova (N x hNova2 avlE avlE2) avlD2
    where
        hNova2 = 1 + max (obtenirAltura avlE) (obtenirAltura avlE2)
        hNova = 1 + max (obtenirAltura avlD2) hNova2


girED :: AVL a -> AVL a
girED (N x _ avlE avlD) = girEE (N x hNova resGirD avlD)
    where
        resGirD = girDD avlE
        hNova = 1 + max (obtenirAltura resGirD) (obtenirAltura avlD)


girDE :: AVL a -> AVL a
girDE (N x _ avlE avlD) = girDD (N x hNova avlE resGirE)
    where
        resGirE = girEE avlD
        hNova = 1 + max (obtenirAltura avlE) (obtenirAltura resGirE)


diferenciaAltures :: AVL a -> Int
diferenciaAltures (E) = 0
diferenciaAltures (N x _ avlE avlD) = obtenirAltura avlE - obtenirAltura avlD


obtenirAltura :: AVL a -> Int
obtenirAltura (E) = -1
obtenirAltura (N _ h _ _) = h


create :: Ord a => [a] -> AVL a
create llista = foldl insert E llista


check :: AVL a -> (Bool,Int)
check (E) = (True,-1)
check (N x h avlE avlD)
    | compleixE && compleixD && diferencia < 2 = (True,h)
    | otherwise                                = (False,-99)
    where
        (compleixE,valorE) = check avlE
        (compleixD,valorD) = check avlD
        diferencia = abs $ obtenirAltura avlE - obtenirAltura avlD
