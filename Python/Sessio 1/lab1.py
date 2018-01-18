
import jutge #sudo pip install jutge

def factorial (n):
    if n == 0:
        return 1
    else:
        return n*factorial(n-1)

def factorialIt (n):
    f = 1
    for i in range (2,n+1): # for nomes pots de una variable a un rang
        f *= i
    return f


n = jutge.read(int)
while n is not None:
    print(factorial(n))
    n = jutge.read(int)


# tuples -> a =  (8,'Jordi') -> a[1] = 'Jordi'
# z = 34, 56 -> (34,56)
# a = 9 i b = 2 -> swap : a,b = b,a


''' Llistes : llistes mutables i heterogenies [1, 'Jordi', 56] [1,'Jordi',[4,5]]
    acces a elements des del 0 [i]
    a = [1,2]
    b = [a,a] -> b = [[1,2],[1,2]]. Si ara a[0] = 99 tenim que b = [[99,2],[99,2]]
    Llistes son vectors de referencia
    Concatenar llistes -> operador +
    Afegir element -> append
    Subllistes -> a = [10,20,30,40,8] -> Sera una llista nova
                  a[1:4] = [20,30,40] -> del 1 fins abans del 4 -> 1,2,3
                  a[:4] = [10,20,30,40]
                  a[1:] = [20,30,40,8]
                  a[:] = [10,20,30,40,8]
                  a[:-1] = [10,20,30,40]
    3 in llista


    Rangs
        list(range(10)) -> [0..9] L'ultim mai s'inclu
        list(range(3,10)) -> [3..9]
        list(range(30,10,2)) -> [3,5,7,9] -> 2 es els passos entre cada
        range(10) -> range(0,10) -> Es un iterador que va retornant el seguent element
                                 -> Iterar amb un for
                                        -> for x in range(10): print(x) 


    Map
        map(doble,a) -> doble es una funcio que multiplica per 2
        list(map(double,a)) -> [10,20,30,40] -> [20,40,60,80]

    Lambda -> lambda x: 2*x, a
              lambda x: (x//2 if x%2 == 0 else 3*x+1), a


    Diccionari -> d = {}
                  d = {"dos":2, "tres":3}
                  d["tres"]
                  d["quatre"] = 4 -> Afegeix l'element
                  d.get("cinc") -> si no hi es retorna None
                  "dos" in d -> Comprovar si la clau hi es, no val per valor
                  for k in d: print(k)
                  for k,v in d.items(): print(k,v) -> imprimir el contingut del diccionari 

    Llistes per comprensio -> [2*i | i <- [1..100] ==== [2*i for i in range(1,101)]'''


