


myMap :: (a -> b) -> [a] -> [b] 
myMap f xs = [f x | x <- xs]

myFilter :: (a -> Bool) -> [a] -> [a]
myFilter predicat xs = [x | x <- xs, predicat x]

myZipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
myZipWith f xs ys = [f x y | (x,y) <- llistaDuples]
    where llistaDuples = zip xs ys
--zip és necessari ja que sinó es faria el producte cartesià dels elements de les dues llistes

thingify :: [Int] -> [Int] -> [(Int, Int)]
thingify xs ys = [(x,y) | x <- xs, y <- ys, x `mod` y == 0]

factors :: Int -> [Int]
factors x = [x' | x' <- [1..x], x `mod` x' == 0]