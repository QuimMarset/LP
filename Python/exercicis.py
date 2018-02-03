from functools import reduce

# Problemes de l'apartat 7.1

def nombre_elem(llista):
	return reduce(lambda acc, _: acc + 1, llista, 0)

def maxim(llista):
	return reduce(lambda acc, x: x if x > acc else acc, llista)

def mitjana(llista):
	suma = reduce(lambda acc, x: acc + x, llista, 0)
	return suma/nombre_elem(llista)

def aplana(llista):
    if not llista:
        return llista
    else:
        resta = aplana(llista[1:])
        primer = llista[0]
        if isinstance(primer, list):
            return aplana(primer) + resta
        else:
            return [primer] + resta
        
def insereix(llista, elem):

    return ([y for y in llista if y <= elem] + 
        [elem] + [y for y in llista if y > elem])


def parells_senars(llista):

    def comprova(tupla, elem):
        if elem % 2 == 0:
            tupla[0] = tupla[0] + [elem]
            return tupla
        else:
            tupla[1] = tupla[1] + [elem]
            return tupla
    return reduce(comprova, llista, [[], []])

def divisors_primers(nombre):

    def garbell(llista):
        if not llista:
            return llista
        else:
            primer = llista[0]
            filtrats = [x for x in llista[1:] if x%primer != 0]
            return [primer] + garbell(filtrats)

    primers = garbell(list(range(2, nombre+1)))
    return [primer for primer in primers if nombre%primer == 0]

def merge(llista1, llista2):

    if not llista1:
        return llista2
    elif not llista2:
        return llista1
    else:
        if llista1[0] <= llista2[0]:
            return llista1[0:1] + merge(llista1[1:], llista2)
        else:
            return llista2[0:1] + merge(llista1, llista2[1:])

def mergesort(llista):

    if not llista:
        return llista
    elif len(llista) == 1:
        return llista
    else:

        def separa(llista):
            if not llista:
                return [[], []]
            elif len(llista) == 1:
                return [llista, []]

            [esq, dre] = separa(llista[2:])
            return [llista[0:1] + esq, llista[1:2] + dre]

        (esq, dre) = separa(llista)
        esqOrd = mergesort(esq)
        dreOrd = mergesort(dre)
        return merge(esqOrd, dreOrd)

def quicksort(llista):

    if not llista or len(llista) == 1:
        return llista
    else:
        primer = llista[0]
        esqOrd = quicksort([x for x in llista[1:] if x <= primer])
        dreOrd = quicksort([x for x in llista[1:] if x > primer])
        return esqOrd + [primer] + dreOrd

# Problemes de l'apartat 7.2

def producte(llista):
    return reduce(lambda acc, x: acc*x, llista)

def producte_parells(llista):
    return reduce(lambda acc, x: acc*x if x%2 == 0 else acc, llista)

def reversa(llista):
    return reduce(lambda acc, x: [x] + acc, llista, [])

def aparicions_llista(llistes, elem):

    def compta_aparicions(llista, elem):
        return reduce(lambda acc, x: acc + 1 if x == elem else acc, llista, 0)

    return list(map(lambda llista: compta_aparicions(llista, elem), llistes))

# Problemes de l'apartat 7.3

def zipWith(f, llista1, llista2):

    llistaDuplas = list(zip(llista1, llista2))
    return list(map(lambda dupla: f(dupla[0], dupla[1]), llistaDuplas))

def takeWhile(pred, llista):
    llistaAux = list(map(lambda x: (x, pred(x)), llista))
    resultat = []
    for (elem, cond) in llistaAux:
        if cond:
            resultat += [elem]
        else:
            break
    return resultat

def dropWhile(pred, llista):

    llistaAux = list(map(lambda x: (x, pred(x)), llista))
    resultat = []
    for (elem, cond) in llistaAux:
        if not cond:
            resultat += [elem]
        else:
            break
    return resultat

def foldl(f, llista, acc):
    return reduce(f, llista, acc)

def foldr(f, llista, acc):
    return reduce(f, list(reversed(llista)), acc)

def scanl(f, llista, acc):
    return reduce(lambda acc, x: acc + [f(acc[-1], x)], llista, [acc])

def countIf(pred, llista):
    return reduce(lambda acc, x: acc + 1 if pred(x) else acc, llista, 0)


# Problemes de l'apartat 7.4

def mapC(f, llista):
    return [f(x) for x in llista]

def filterC(pred, llista):
    return [x for x in llista if pred(x)]

def parells(llista1, llista2):
    return [(x, y) for x in llista1 for y in llista2 if x % y == 0]


