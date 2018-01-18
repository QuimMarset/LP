



main = do
    linia <- getLine
    if linia == "*"
        then return ()
        else do
            let
                (nom,(b:resta)) = span (/= ' ') linia
                (massa,b':altura) = span (/= ' ') resta
            putStrLn $ nom ++ ": " ++ interpretaIMC massa altura
            main


interpretaIMC :: String -> String -> String
interpretaIMC massa altura
    | imc < 18 = "magror"
    | imc >= 18 && imc <= 25 = "corpulencia normal"
    | imc >= 25 && imc <= 30 = "sobrepes"
    | imc >= 30 && imc <= 40 = "obesitat"
    | imc > 40 = "obesitat morbida"
    where
        massaNum = read massa ::Float
        alturaNum = read altura ::Float
        imc = massaNum / alturaNum^2
        