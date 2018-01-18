def absValue(x):
    if x < 0:
        return -x
    else:
        return x


def power(x, p):
    if p == 0:
        return 1
    else:
        n = p // 2
        exp = power(x, n)
        if p % 2 == 0:
            return exp*exp
        else:
            return x*exp*exp


def isPrime(x):
    if x <= 1:
        return False
    else:
        for i in range(2, x+1):
            if i*i > x:
                return True
            elif x % i == 0:
                return False


def slowFib(x):
    if x == 0:
        return 0
    elif x == 1:
        return 1
    else:
        return slowFib(x-1) + slowFib(x-2)


def quickFib(x):
    pair = (0,1)
    for i in range(1, x+1):
        pair = (pair[0] + pair[1], pair[0])
    return pair[0] 