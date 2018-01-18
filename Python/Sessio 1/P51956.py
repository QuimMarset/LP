

def myLength(L):
    if (not L):
        return 0
    else:
        return 1 + myLength(L[1:])


def myMaximum(L):
    max = L[0]
    for i in range(1, len(L)):
        if L[i] > max:
            max = L[i]
    return max


def average(L):
    sum = 0
    for i in range(0, len(L)):
        sum += L[i]
    return sum / len(L)


def buildPalindrome(L):
    return inversa(L) + L


def inversa(L):
    if (not L):
        return []
    else:
        return inversa(L[1:]) + [L[0]]


def remove(L1, L2):
    if (not L1):
        return []
    else:
        if L1[0] in L2:
            return remove(L1[1:], L2)
        else:
            return [L1[0]] + remove(L1[1:], L2)


def flatten(L):
    if (not L):
        return []
    else:
        elem1 = L[0]
        lResta = flatten(L[1:])
        if isinstance(elem1, list):
            return flatten(elem1) + lResta
        else:
            return [elem1] + lResta


def oddsNevens(L):
    if (not L):
        return ([], [])
    else:
        x = L[0]
        (sen, par) = oddsNevens(L[1:])
        if x % 2 != 0:
            return ([x] + sen, par)
        else:
            return (sen, [x] + par)


def primeDivisors(n):
    if n == 0 or n == 1:
        return []
    else:
        divisors = [i for i in range(2, n+1) if n % i == 0 and primer(i)]
        return divisors


def primer(n):
    if n <= 1:
        return False
    else:
        for i in range(2, n+1):
            if i*i > n:
                return True
            elif n % i == 0:
                return False
