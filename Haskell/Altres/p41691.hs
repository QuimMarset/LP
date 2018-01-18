


prefsufs:: [a] -> [[a]]
prefsufs (x:xs) = prefixos ++ sufixos
    where
        prefixos = scanl (\acc elem -> acc ++ [elem]) [x] xs
        sufixos = takeWhile (not.null) $ iterate tail xs


mult :: [Double] -> [Double] -> [Double]
mult coef1 coef2 = zipWith (\l1 l2 -> sum $ zipWith (*) l1 l2) prefSuf1 prefSuf2 ++ [0.0]
    where
        prefSuf1 = prefsufs coef1
        prefSuf2 = map reverse $ prefsufs coef2 