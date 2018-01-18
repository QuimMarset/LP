


data Queue a = Queue [a] [a] deriving (Show)

create :: Queue a
create = (Queue [] [])


push :: a -> Queue a -> Queue a
push x (Queue l1 l2) = (Queue l1 (x:l2))


pop :: Queue a -> Queue a
pop (Queue [] []) = (Queue [] [])
pop (Queue [] l2) = (Queue lrev [])
    where
        (x:lrev) = reverse l2
pop (Queue l1 l2) = (Queue (tail l1) l2)


top :: Queue a -> a
top (Queue [] l2) = last l2
top (Queue l1 l2) = head l1


empty :: Queue a -> Bool
empty (Queue [] []) = True
empty (Queue _ _) = False


instance Eq a => Eq (Queue a) where
    (Queue l1 l2) == (Queue l3 l4) = l1 ++ reverse l2 == l3 ++ reverse l4