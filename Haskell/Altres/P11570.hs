import Data.List
import Data.Ord



data Avi = Avi {
    nom :: [Char],
    edat :: Int,
    despeses :: [Int]
    } deriving (Show)


promigDespeses :: Avi -> Int
promigDespeses (Avi _ _ despeses) = round $ (fromIntegral (sum despeses)) / (fromIntegral n)
    where
        n = length despeses


edatsExtremes :: [Avi] -> (Int, Int)
edatsExtremes avis = (minima,maxima)
    where
        maxima = edat $ maximumBy (comparing edat) avis
        minima = edat $ minimumBy (comparing edat) avis


sumaPromig :: [Avi] -> Int
sumaPromig avis = sum $ map promigDespeses avis


maximPromig :: [Avi] -> Int
maximPromig avis = maximum $ map promigDespeses avis


despesaPromigSuperior :: [Avi] -> Int -> ([Char], Int)
despesaPromigSuperior avis despesa 
    | length llista == 0 = ("",0)
    | otherwise = retorna $ head llista
    where
        llista = sortBy (comparing promigDespeses) $ filter (\avi -> promigDespeses avi > despesa) avis
        retorna :: Avi -> ([Char],Int)
        retorna avi = (nom avi, edat avi)