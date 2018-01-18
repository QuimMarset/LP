


data BST a = E | N a (BST a) (BST a) deriving (Show)


insert :: Ord a => BST a -> a -> BST a
insert (E) x = N x E E
insert bst@(N a bstE bstD) x
    | x == a    = bst
    | x > a     = N a bstE (insert bstD x)
    | otherwise = N a (insert bstE x) bstD


create :: Ord a => [a] -> BST a
create llista = foldl insert E llista


remove :: Ord a => BST a -> a -> BST a
remove (E) _ = E
remove bst@(N a bstE bstD) x
    | x == a    = remove' bst
    | x > a     = N a bstE (remove bstD x)
    | otherwise = N a (remove bstE x) bstD
    where
        remove' :: Ord a => BST a -> BST a
        remove' (N a E E) = E
        remove' (N a E bstD) = bstD
        remove' (N a bstE E) = bstE
        remove' (N a bstE bstD) = recorrer bstD bstE
            where
                recorrer :: BST a -> BST a -> BST a
                recorrer (N x E bstD) bst = N x bst bstD
                recorrer (N x bstE bstD) bst = N x (recorrer bstE bst) bstD


contains :: Ord a => BST a -> a -> Bool
contains (E) _ = False
contains (N a bstE bstD) x
    | x == a    = True
    | x > a     = contains bstD x
    | otherwise = contains bstE x


getmax :: BST a -> a
getmax (N a _ E) = a
getmax (N a bstE bstD) = getmax bstD


getmin :: BST a -> a
getmin (N a E _) = a
getmin (N a bstE bstD) = getmin bstE


size :: BST a -> Int
size (E) = 0
size (N a bstE bstD) = 1 + size bstE + size bstD


elements :: BST a -> [a]
elements (E) = []
elements (N a bstE bstD) = elements bstE ++ [a] ++ elements bstD