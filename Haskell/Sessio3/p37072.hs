

data Tree a = Node a (Tree a) (Tree a) | Empty deriving (Show)

size :: Tree a -> Int 
size Empty = 0
size (Node a left right) = 1 + size left + size right


height :: Tree a -> Int
height Empty = 0
height (Node a left right) = 1 + max (height left) (height right)


equal :: Eq a => Tree a -> Tree a -> Bool
equal Empty Empty = True
equal Empty _ = False
equal _ Empty = False
equal (Node a1 left1 right1) (Node a2 left2 right2)
    | a1 /= a2 = False
    | otherwise = equal left1 right1 && equal left2 right2


isomorphic :: Eq a => Tree a -> Tree a -> Bool
isomorphic Empty Empty = True
isomorphic _ Empty = False
isomorphic Empty _ = False
isomorphic (Node a1 left1 right1) (Node a2 left2 right2) =
    a1 == a2 && (isomorphic left1 left2 || isomorphic left1 right2) && (isomorphic right1 left2 || isomorphic right1 right2)


preOrder :: Tree a -> [a]
preOrder Empty = []
preOrder (Node a left right) = [a] ++ preOrder left ++ preOrder right


postOrder :: Tree a -> [a]
postOrder Empty = []
postOrder (Node a left right) = postOrder left ++ postOrder right ++ [a]


inOrder :: Tree a -> [a]
inOrder Empty = []
inOrder (Node a left right) = inOrder left ++ [a] ++ inOrder right


breadthFirst :: Tree a -> [a]
breadthFirst t = recorregutCua [t]
    where
        recorregutCua:: [Tree a] -> [a]
        recorregutCua [Empty] = []
        recorregutCua (Empty:xs) = recorregutCua xs
        recorregutCua ((Node a left right):xs) = [a] ++ recorregutCua (xs ++ [left,right])


build :: Eq a => [a] -> [a] -> Tree a
build [] [] = Empty
build (x:xs) inOrdre = (Node x (build esqPre esqIn) (build drePre dreIn))
    where
        (esqIn,(y:dreIn)) = span (/= x) inOrdre
        (esqPre,drePre) = splitAt (length esqIn) xs


overlap :: (a -> a -> a) -> Tree a -> Tree a -> Tree a
overlap _ Empty Empty = Empty
overlap _ t1 Empty = t1
overlap _ Empty t2 = t2
overlap f (Node a1 left1 right1) (Node a2 left2 right2) = (Node (f a1 a2) (overlap f left1 left2) (overlap f right1 right2))