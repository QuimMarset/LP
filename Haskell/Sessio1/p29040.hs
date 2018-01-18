
insert :: [Int] -> Int -> [Int]
insert [] a = [a]
insert (x:xs) a
    |a <= x = a:(x:xs)
    |a > x = x:insert xs a


isort :: [Int] -> [Int]
isort [] = []
isort (x:xs) = insert (isort xs) x


remove :: [Int] -> Int -> [Int]
remove [] _ = []
remove (x:xs) a
    |x == a = xs
    |x /= a = x:remove xs a


ssort :: [Int] -> [Int]
ssort [] = []
ssort xs = minim:ssort (remove xs minim)
            where minim = minimum xs


merge :: [Int] -> [Int] -> [Int]
merge [] ys = ys
merge xs [] = xs
merge xs@(x:xs2) ys@(y:ys2)
    |x <= y = x:merge xs2 ys
    |x > y = y:merge xs ys2


msort :: [Int] -> [Int]
msort [] = []
msort [x] = [x]
msort xs = merge meitat1S meitat2S
    where meitat = (length xs) `div` 2
          meitat1S = msort (take meitat xs)
          meitat2S = msort (drop meitat xs)


qsort :: [Int] -> [Int]
qsort [] = []
qsort xs = qsort [a | a <- resta, a <= pivot] ++ [pivot] ++ qsort [a | a <- resta, a > pivot]
    where pivot = head xs
          resta = tail xs


genQsort :: Ord a => [a] -> [a] 
genQsort [] = []
genQsort xs = genQsort [x | x <- resta, x <= pivot] ++ [pivot] ++ genQsort [x | x <- resta, x > pivot]
    where pivot = head xs
          resta = tail xs