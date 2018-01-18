


myFoldl :: (a -> b -> a) -> a -> [b] -> a --
myFoldl _ acc [] = acc
myFoldl f acc (x:xs) = myFoldl f (f acc x) xs

myFoldr :: (a -> b -> b) -> b -> [a] -> b --
myFoldr _ acc [] = acc
myFoldr f acc (x:xs) = f x accResta
    where accResta = myFoldr f acc xs 

myIterate :: (a -> a) -> a -> [a] --
myIterate f x = x:myIterate f resultat 
    where resultat = f x

myUntil :: (a -> Bool) -> (a -> a) -> a -> a --
myUntil predicat f x
    | predicat x = x
    | otherwise = myUntil predicat f $ f x

myMap :: (a -> b) -> [a] -> [b]
myMap f xs = foldr (\x acc -> f x:acc) [] xs

myFilter :: (a -> Bool) -> [a] -> [a]
myFilter predicat xs = foldr (\x acc -> if predicat x then x:acc else acc) [] xs

myAll :: (a -> Bool) -> [a] -> Bool
myAll predicat xs = and $ myMap predicat xs 

myAny :: (a -> Bool) -> [a] -> Bool
myAny predicat xs = or $ myMap predicat xs

myZip :: [a] -> [b] -> [(a, b)] --
myZip xs [] = []
myZip [] ys = [] 
myZip (x:xs) (y:ys) = (x,y):myZip xs ys

myZipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
myZipWith f xs ys = map (\(x,y) -> f x y) $ myZip xs ys