import Data.List
import Data.Ord


data Flor = Flor [MesuraFlor] ClasseFlor deriving (Show)
data Conjunt = Conjunt [Flor] deriving (Show)

type DistanciaAFlor = (ClasseFlor,Float)

type OcurrenciesClasseFlor = (ClasseFlor,Int)

type ClasseFlor = String
type DistanciaFlors = Float
type MesuraFlor = Float
type FuncioAplicar = String



distanciaEuclidea :: Flor -> Flor -> Float
distanciaEuclidea (Flor parametres1 _) (Flor parametres2 _) = sqrt.sum.map (** 2) $ zipWith (-) parametres1 parametres2


distanciaManhattan :: Flor -> Flor -> Float
distanciaManhattan (Flor parametres1 _) (Flor parametres2 _) = sqrt.sum.map abs $ zipWith (-) parametres1 parametres2


votacioSimple ::  [DistanciaAFlor] -> Int -> ClasseFlor
votacioSimple distancies k
    | k == 1    = head classesMesProperes
    | otherwise = determinaClasse classesMesProperes
    where
        classesMesProperes = map (\(classe,_) -> classe) $ take k $ sortBy (comparing snd) distancies


determinaClasse :: [ClasseFlor] -> ClasseFlor
determinaClasse classesMesProperes = fst $ maximumBy (comparing snd) ocurrenciesClasses
    where
        classesOrdenades = sortBy (comparing id) classesMesProperes
        ocurrenciesClasses = calculaOcurrencies classesMesProperes 1

        calculaOcurrencies :: [ClasseFlor] -> Int -> [OcurrenciesClasseFlor]
        calculaOcurrencies [x] acum = [(x,acum)]
        calculaOcurrencies (x1:x2:xs) acum
            | x1 == x2  = calculaOcurrencies (x2:xs) (acum+1)
            | otherwise = (x1,acum):calculaOcurrencies (x2:xs) 1
        

votacioPonderada :: [DistanciaAFlor] -> Int -> ClasseFlor
votacioPonderada distancies k
    | k == 1    = head classesCandidates
    | otherwise = determinaClassePonderacio (zip classesCandidates pesos)
    where
        candidats = take k $ sortBy (comparing snd) distancies
        classesCandidates = map fst candidats
        pesos = map (\(_,dist) -> 1/dist) candidats 

determinaClassePonderacio :: [(ClasseFlor,Float)] -> ClasseFlor
determinaClassePonderacio classesPonderades = fst $ maximumBy (comparing snd) pesosAcumulats
    where
        classesOrdenades = sortBy (comparing snd) classesPonderades
        pesosAcumulats = calculaPes classesPonderades 0
        calculaPes :: [(ClasseFlor,Float)] -> Float -> [(ClasseFlor,Float)]
        calculaPes [x] pesAcum = [(fst x,pesAcum + snd x)]
        calculaPes (x1:x2:xs) pesAcum
            | fst x1 == fst x2 = calculaPes (x2:xs) (pesAcum + snd x1)
            | otherwise        = (fst x1,pesAcum + snd x1):calculaPes (x2:xs) 0
        

avaluacioAccuracy :: Int -> Int -> Float
avaluacioAccuracy prediccionsCorrectes nombreExemples = fromIntegral prediccionsCorrectes / fromIntegral nombreExemples * 100


avaluacioLost :: Int -> Int -> Float
avaluacioLost prediccionsIncorrectes nombreExemples = fromIntegral prediccionsIncorrectes / fromIntegral nombreExemples * 100

      
calculaPrediccions :: [[DistanciaAFlor]] -> Int -> FuncioAplicar -> [ClasseFlor]
calculaPrediccions distanciesFlors k funcioVot
    | funcioVot == "Simple" = map (\d -> votacioSimple d k) distanciesFlors
    | otherwise             = map (\d -> votacioPonderada d k) distanciesFlors


calculaDistancies :: Conjunt -> Conjunt -> FuncioAplicar -> [[DistanciaAFlor]]
calculaDistancies (Conjunt florsTest) (Conjunt florsTrain) funcioDist
    | funcioDist == "Euclidea" = map (\florTest -> funcioEuclidea florTest florsTrain) florsTest
    | otherwise                = map (\florTest -> funcioManhattan florTest florsTrain) florsTest
    where

        funcioEuclidea :: Flor -> [Flor] -> [DistanciaAFlor]
        funcioEuclidea florTest florsTrain = 
            map (\florTrain@(Flor _ classe) -> (classe,distanciaEuclidea florTest florTrain)) florsTrain

        funcioManhattan :: Flor -> [Flor] -> [DistanciaAFlor]
        funcioManhattan florTest florsTrain =
            map (\florTrain@(Flor _ classe) -> (classe,distanciaManhattan florTest florTrain)) florsTrain


kNearestNeighbours :: Conjunt -> Conjunt -> Int -> FuncioAplicar -> FuncioAplicar -> [ClasseFlor]
kNearestNeighbours conjuntTest conjuntTrain k funcioDist funcioVot = calculaPrediccions distanciesFlorsTestTrain k funcioVot
    where
        distanciesFlorsTestTrain = calculaDistancies conjuntTest conjuntTrain funcioDist


avaluaBondatClassificador :: Conjunt -> [ClasseFlor] -> [FuncioAplicar] -> [Float]
avaluaBondatClassificador (Conjunt florsTest) classesPrediccio funcionsAval = [avaluacioAccuracy prediccionsCorrectes nombreExemples]
    where
        classesTest = map (\(Flor _ classe) -> classe) florsTest
        nombreExemples = length classesTest
        comparacioTestPrediccio = zipWith (==) classesTest classesPrediccio
        prediccionsCorrectes = foldl (\acc x -> if x then acc+1 else acc) 0 comparacioTestPrediccio
        prediccionsIncorrectes = length classesTest - prediccionsCorrectes


creaConjunt :: String -> Conjunt
creaConjunt contingut = Conjunt llistaFlors
    where
        contingutSeparat = words contingut
        llistaFlors = map (\florString -> creaFlor florString) contingutSeparat


creaFlor :: String -> Flor
creaFlor florString = Flor parametres classe
    where
        llistaComponents = words' ',' florString
        classe = last llistaComponents
        parametres = map (\v -> read v ::MesuraFlor) $ init llistaComponents


words' :: Char -> String -> [String]
words' separador cadena = 
    case dropWhile (== separador) cadena of
        "" -> []
        subcadena -> elem:words' separador resta
            where
                (elem,resta) = span (/= separador) subcadena


main = do

    putStrLn "Introdueix els paràmetres del kNN"
    putStrLn "Nombre de veïns més propers a considerar:"
    k <- getLine
    putStrLn "Funció de distància a utilitzar (Euclidea - Manhattan):"
    funcioDist <- getLine
    putStrLn "Funció de votació a utiltizar (Simple - Ponderada):"
    funcioVot <- getLine


    contingutTrain <- readFile "iris.train.txt"
    contingutTest <- readFile "iris.test.txt"
    
    let
        kInteger = read k ::Int
        conjuntTrain = creaConjunt contingutTrain
        conjuntTest = creaConjunt contingutTest
        resultatPrediccio = kNearestNeighbours conjuntTest conjuntTrain kInteger funcioDist funcioVot
        percentatgeEncerts = avaluaBondatClassificador conjuntTest resultatPrediccio []

    sequence $ map putStrLn resultatPrediccio
    putStrLn "Percentatge d'encerts del classificador"
    print percentatgeEncerts

    