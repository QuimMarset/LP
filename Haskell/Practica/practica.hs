
data Flor = Flor [Float] String deriving (Show)
--Com les mesures només les utilitzo per calcular distància les agrupo totes en una llista
data Conjunt = Conjunt [Flor] deriving (Show)

type DistanciaAFlorTrain = (Float,String)
{- El Float representa la distància entre la flor del conjunt de prova
i la flor del conjunt d'entrenament i el String és la classe de la flor del conjunt d'entrenament-}

type VotsClasseCandidata = (Float,String)
{- En aquest cas el Float representa o bé ocurrències d'una classe de flor d'entre les de les k més properes (votació simple), 
o bé la suma dels pesos d'una classe de flor d'entre les de les k més properes (votació ponderada). El String segueix sent la classe de la flor.-}


distanciaEuclidea :: Flor -> Flor -> Float
distanciaEuclidea (Flor mesures1 _) (Flor mesures2 _) = sqrt.sum.map (** 2) $ zipWith (-) mesures1 mesures2


distanciaManhattan :: Flor -> Flor -> Float
distanciaManhattan (Flor mesures1 _) (Flor mesures2 _) = sum.map abs $ zipWith (-) mesures1 mesures2


avaluacioAccuracy :: Int -> Int -> Float
avaluacioAccuracy prediccionsCorrectes nombreExemples = fromIntegral prediccionsCorrectes / fromIntegral nombreExemples


avaluacioLost :: Int -> Int -> Float
avaluacioLost prediccionsIncorrectes nombreExemples = fromIntegral prediccionsIncorrectes / fromIntegral nombreExemples

{- En aquesta funció es determina la classe predita per una flor del conjunt de test. Llavors en el cas que pugui haver dos classes
amb el mateix nombre de vots depèn de quin s'escull, el nombre d'encerts del classificador canvia.-}
classeMajoritaria :: [VotsClasseCandidata] -> String
classeMajoritaria llista = snd seleccionat
    where
        seleccionat = foldl1 (\maximAct@(xValor,_) elem@(yValor,_) -> if xValor > yValor then maximAct else elem ) llista


sortBy :: (a -> a -> Ordering) -> [a] -> [a]
sortBy _ [] = []
sortBy _ [x] = [x]
sortBy cmp (x:xs) = sortBy cmp esq ++ [x] ++ sortBy cmp dre
    where
        esq = [y | y <- xs, y `cmp` x /= GT]
        dre = [y | y <- xs, y `cmp` x == GT]

comparing :: Ord a => (b -> a) -> b -> b -> Ordering
comparing p x y = compare (p x) (p y)


votacioSimple ::  [DistanciaAFlorTrain] -> String
votacioSimple kMesPropers = classeMajoritaria ocurrenciesClasses
    where
        classesOrdenades = map snd $ sortBy (comparing snd) kMesPropers
        ocurrenciesClasses = calculaOcurrencies classesOrdenades 1

        calculaOcurrencies :: [String] -> Float -> [VotsClasseCandidata]
        calculaOcurrencies [x] acum = [(acum,x)]
        calculaOcurrencies (x1:x2:xs) acum
            | x1 == x2  = calculaOcurrencies (x2:xs) (acum+1)
            | otherwise = (acum,x1):calculaOcurrencies (x2:xs) 1
        

votacioPonderada :: [DistanciaAFlorTrain] -> String
votacioPonderada kMesPropers = classeMajoritaria pesosAcumulatsClasses
    where
        classesAmbPesosOrdenades =  sortBy (comparing snd) $ map (\(dist,classe) -> (1/dist,classe)) kMesPropers
        pesosAcumulatsClasses = calculaPesos classesAmbPesosOrdenades 0

        {-Aqui no he canviat el nom del pair per el de VotsClasseCandidata perquè de fet no ho són encara, són els pesos de cada 
        classe de les k candidates. Llavors es sumaran els pesos de classes iguales i llavors ja si que ho considero vots de la classe.-}
        calculaPesos :: [(Float,String)] -> Float -> [VotsClasseCandidata]
        calculaPesos [x] pesAcum = [(pesAcum + fst x,snd x)]
        calculaPesos (x1:x2:xs) pesAcum
            | snd x1 == snd x2 = calculaPesos (x2:xs) (pesAcum + fst x1)
            | otherwise        = (pesAcum + fst x1,snd x1):calculaPesos (x2:xs) 0
                
{- En aquesta funció és on es calcularan les prediccions de les classes de les flors. Llavors en el cas que k sigui 1 el mètode de votació
no afectarà i per tant es tracta a part. Si és diferent ja si que s'executa segons la funció de votació.-}
calculaPrediccions :: [[DistanciaAFlorTrain]] -> Int -> String -> [String]
calculaPrediccions distanciesFlorsTest k funcioVot
    | k == 1                          = map (snd.head) kMesPropersCadaFlor
    | funcioVot == "Simple" = map votacioSimple kMesPropersCadaFlor
    | otherwise             = map votacioPonderada kMesPropersCadaFlor
    where
        kMesPropersCadaFlor = map (take k.sortBy (comparing fst)) distanciesFlorsTest

{- La idea és utilitzar duples que continguin la distància entre flors del conjunt de prova i el d'entrenament i la classe de la flor del conjunt 
d'entrenament així no cal anar treballant amb tota la informació relativa a la flor. És per això que en aquesta funció, per cada flor del conjunt de 
prova es calcula la distància a cada flor del conjunt d'entrenament, segons quina sigui la funció de distància.-}
calculaDistancies :: Conjunt -> Conjunt -> String -> [[DistanciaAFlorTrain]]
calculaDistancies (Conjunt florsTest) (Conjunt florsTrain) funcioDist
    | funcioDist == "Euclidea" = map (\florTest -> calculaEuclAFlorsTrain florTest florsTrain) florsTest
    | otherwise                = map (\florTest -> calculaManhAFlorsTrain florTest florsTrain) florsTest
    where

        calculaEuclAFlorsTrain :: Flor -> [Flor] -> [DistanciaAFlorTrain]
        calculaEuclAFlorsTrain florTest florsTrain = 
            map (\florTrain@(Flor _ classe) -> (distanciaEuclidea florTest florTrain, classe) ) florsTrain

        calculaManhAFlorsTrain :: Flor -> [Flor] -> [DistanciaAFlorTrain]
        calculaManhAFlorsTrain florTest florsTrain =
            map (\florTrain@(Flor _ classe) -> (distanciaManhattan florTest florTrain, classe) ) florsTrain


kNearestNeighbours :: Conjunt -> Conjunt -> Int -> String -> String -> [String]
kNearestNeighbours conjuntTest conjuntTrain k funcioDist funcioVot = calculaPrediccions distanciesFlorsTest k funcioVot
    where
        distanciesFlorsTest = calculaDistancies conjuntTest conjuntTrain funcioDist

{-En aquesta funció, com només hi ha dues funcions d'avaluació, simplement retorno totes dues directament.-}
avaluaBondatClassificador :: Conjunt -> [String] -> [Float] 
avaluaBondatClassificador (Conjunt florsTest) classesPredites = 
    [avaluacioAccuracy prediccionsCorrectes nombreExemples, avaluacioLost prediccionsIncorrectes nombreExemples]
    where
        classesTest = map (\(Flor _ classe) -> classe) florsTest
        nombreExemples = length classesTest
        comparacioTestPrediccio = zipWith (==) classesTest classesPredites
        prediccionsCorrectes = length $ filter (== True) comparacioTestPrediccio
        prediccionsIncorrectes = nombreExemples - prediccionsCorrectes


creaConjunt :: String -> Conjunt
creaConjunt contingut = Conjunt llistaFlors
    where
        contingutSeparat = words contingut -- Com words separa també per salts de línia, obtinc una llista amb la informació de cada flor
        llistaFlors = map creaFlor contingutSeparat

        creaFlor :: String -> Flor
        creaFlor florString = Flor parametres classe
            where
                llistaComponents = words' florString
                classe = last llistaComponents
                parametres = map (\v -> read v ::Float) $ init llistaComponents

                words' :: String -> [String] --A diferència del words base, aquest separa per comes
                words' [] = []
                words' cadena@(x:xs)
                    | x == ','  = words' xs
                    | otherwise = 
                        let 
                            (element,resta) = span (/= ',') cadena
                        in
                            element:words' resta


{-Aquestes tres funcions abans de main serveixen per detectar errors en l'entrada que afecten l'execució de l'algorisme i assegurar-se
que els paràmetres siguin correctes.-}
obtenirFuncioDist :: IO String
obtenirFuncioDist = do
    putStrLn "Funció de distància a utilitzar (Euclidea - Manhattan):"
    funcioDist <- getLine
    if funcioDist == "Euclidea" || funcioDist == "Manhattan"
        then return funcioDist
    else do
        putStrLn "La funció de distància no correspòn a cap valor vàlid"
        obtenirFuncioDist

obtenirFuncioVot :: IO String
obtenirFuncioVot = do
    putStrLn "Funció de votació a utilitzar (Simple - Ponderada):"
    funcioVot <- getLine
    if funcioVot == "Simple" || funcioVot == "Ponderada"
        then return funcioVot
    else do
        putStrLn "La funció de votació no correspòn a cap valor vàlid"
        obtenirFuncioVot

obtenirK :: IO String
obtenirK = do
    putStrLn "Valor de k:"
    k <- getLine
    if esNombre k
        then return k
    else do
        putStrLn "El valor de k no és vàlid"
        obtenirK

esNombre :: String -> Bool
esNombre cadena = (and $ map esDigit cadena) && (not.null) cadena
    where
        esDigit :: Char -> Bool
        esDigit c = c == '0' || c == '1' || c == '2' || c == '3' || c == '4' ||
            c == '5' || c == '6' || c == '7' || c == '8' || c == '9'

main = do

    putStrLn "Introdueix els paràmetres del kNN"
    k <- obtenirK
    funcioDist <- obtenirFuncioDist
    funcioVot <- obtenirFuncioVot
    contingutTrain <- readFile "iris.train.txt"
    contingutTest <- readFile "iris.test.txt"
    
    let
        kInt = read k ::Int
        conjuntTrain = creaConjunt contingutTrain
        conjuntTest = creaConjunt contingutTest
        resultatsPrediccio = kNearestNeighbours conjuntTest conjuntTrain kInt funcioDist funcioVot
        [accuracy,lost] = avaluaBondatClassificador conjuntTest resultatsPrediccio

    putStrLn "Resultat de les classes predites pel classificador:"
    mapM_ putStrLn resultatsPrediccio
    putStrLn "Accuracy:"
    print accuracy
    putStrLn "Lost:"
    print lost
    

    