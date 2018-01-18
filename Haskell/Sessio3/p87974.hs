 


main = do
    nom <- getLine
    let
        ultima = last nom
    if ultima == 'a' || ultima == 'A'
        then putStrLn "Hola maca!"
        else putStrLn "Hola maco!"

