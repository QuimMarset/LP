

minProd :: [Int] -> [Int] -> Int
minProd vectorX vectorY = sum $ zipWith (*) vectorXOrdenat vectorYOrdenatRev
    where
        vectorXOrdenat = ordena vectorX
        vectorYOrdenatRev = reverse $ ordena vectorY

ordena :: [Int] -> [Int]
ordena [] = []
ordena [x] = [x]
ordena vector = fusiona (ordena partEsq) (ordena partDre)
    where
        (partEsq,partDre) = dividir vector
        dividir :: [Int] -> ([Int],[Int])
        dividir []         = ([],[])
        dividir [x]        = ([x],[])
        dividir (x1:x2:xs) = (x1:esq,x2:dre)
            where
                (esq,dre) = dividir xs
        fusiona :: [Int] -> [Int] -> [Int]
        fusiona [] ys = ys
        fusiona xs [] = xs
        fusiona (x:xs) (y:ys)
            | x <= y    = x:(fusiona xs (y:ys))
            | otherwise = y:(fusiona (x:xs) ys)