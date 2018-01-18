import Data.List
import Data.Ord

votsMinim :: [([Char], Int)] -> Int -> Bool
votsMinim llista num = any (\(_,s) -> s < num) llista


candidatMesVotat :: [([Char], Int)] -> [Char]
candidatMesVotat llista = fst $ maximumBy (comparing snd) llista


votsIngressos :: [([Char], Int)] -> [([Char], Int)] -> [[Char]]
votsIngressos vots ingressos = map fst $ filter (\(f,_) -> not $ elem f (map fst ingressos)) vots

rics :: [([Char], Int)] -> [([Char], Int)] -> [[Char]]
rics vots ingressos = map (\nom -> comprovaAsterisc nom) $ map fst $ take 3 $ sortBy (flip $ comparing snd) ingressos
	where
		nomsVots = map fst vots
		comprovaAsterisc :: [Char] -> [Char]
		comprovaAsterisc nom
			| elem nom nomsVots = nom ++ ['*']
			| otherwise = nom