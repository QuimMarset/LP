from functools import reduce

# Examen 16-17 Q1

def evaluate(e):
	if isinstance(e, int):
		return e
	elif isinstance(e, list):
		if not e: return 1
		else:
			evalElem = list(map(evaluate, e))
			return reduce(lambda acc, x: acc*x if x is not None else acc, evalElem, 1)
	elif isinstance(e, tuple):
		if not e: return 0
		else:
			evalElem = list(map(evaluate, e))
			return reduce(lambda acc, x: acc + x if x is not None else acc, evalElem, 0)

print(evaluate([3,(2,[8,"sol"],{}),7,([2,(1,1)],11)]))
print(evaluate(([(),7],[])))

def s(*xs):
	m = 0
	for x in xs:
		m += x
	return m

def partial(f, x):
	mem = [x]
	def aux(*ys):
		for y in ys:
			mem.append(y)
		print(mem)
		return f(*mem)
	return aux


# Examen 15-16 Q2

def invert(elem):
	if isinstance(elem, list):
		mapElem = map(invert, elem)
		return tuple(mapElem)
	elif isinstance(elem, tuple):
		mapElem = map(invert, elem)
		return list(mapElem)
	else:
		return elem

print(invert(([3,3,(2,1)],5,[1,1,[1,1]])))
print(invert(invert(([3,3,(2,1)],5,[1,1,[1,1]]))))

class Trie:

	def __init__(self):
		self.val = None
		self.entries = {}

	def value(self, k):
		if len(k) == 0:
			return self.val
		elif k[0] not in self.entries:
			return None
		else:
			return self.entries[k[0]].value(k[1:])

	def insert(self, key, value):

		if len(key) == 1:
			if key not in self.entries:
				aux = Trie()
				aux.val = value
				self.entries[key] = aux
			else:
				self.entries[key].val = value
		else:
			if key[0] in self.entries:
				self.entries[key[0]].insert(key[1:], value)
			else:
				aux = Trie()
				self.entries[key[0]] = aux
				aux.insert(key[1:], value)

a = Trie()
a.insert("sala", 16)
print(a.value("sala"))
a.insert("sala", 21)
a.insert("sal", 17)
a.insert("sol", 38)
a.insert("son", 57)
print(a.value("sol"))
print(a.value("sala"))
print(a.value("salsa"))
print(a.value("son"))
print(a.value("sal"))
		
# Examen 15-16 Q1

class BTree:
	def __init__(self, x):
		self.rt = x
		self.left = None
		self.right = None
	def setLeft(self, a):
		self.left = a
	def setRight(self, a):
		self.right = a
	def root(self):
		return self.rt
	def leftChild(self):
		return self.left
	def rightChild(self):
		return self.right

class SBTree(BTree):
	def __init__(self, x):
		self.size = 1
		super().__init__(x)
	def getSize(self):
		return self.size
	def setLeft(self, a):
		self.left = a
		self.size += a.size
	def setRight(self, a):
		self.right = a
		self.size += a.size

def minOccur(a):

	dicc = {}
	def cerca(node):
		if node is not None:
			root = node.root()
			if root not in dicc:
				dicc[root] = 1
			else:
				dicc[root] += 1
			cerca(node.leftChild())
			cerca(node.rightChild())
	cerca(a)
	minKey = min(dicc, key = dicc.get)
	return (minKey, dicc[minKey])

a = SBTree(8)
a1 = SBTree(5)
a2 = SBTree(8)
a3 = SBTree(3)
a4 = SBTree(8)
a5 = SBTree(3)
a6 = SBTree(5)
a5.setRight(a6)
a3.setRight(a4)
a3.setLeft(a5)
a1.setLeft(a3)
a1.setRight(a2)
a.setLeft(a1)
print("Mida:", a.getSize())
print(minOccur(a))



# Examen 14-15 Q2

def classify(obj):

	dicc = {}
	def ompleDiccionari(elem):
		if isinstance(elem, str):
			if elem in dicc:
				dicc[elem] = dicc[elem] + 1
			else:
				dicc[elem] = 1
		elif isinstance(elem, (list, tuple)):
			for elemAux in elem:
				ompleDiccionari(elemAux)

	ompleDiccionari(obj)
	diccR = {}
	for k, v in dicc.items():
		if v in diccR:
			diccR[v].append(k)
		else:
			diccR[v] = [k]
	return diccR

print(classify(['dia',(2,"hola"),[3,"hola",3],'dia',5,(3.6,"mes"),("dia",1),["hotel",2,("hola"),{1:'hola'}]]))


class Poly:

	def __init__(self):
		self.coeffs = {}
		self.degree = 0

	def add_coeff(self,degree,coeff):
		self.coeffs[degree] = coeff
		self.degree = degree if degree > self.degree else self.degree

	def get_degree(self):
		return self.degree

class PolyEval(Poly):

	def eval(self, x):
		resultat = 0
		for k, v in self.coeffs.items():
			resultat += (x**k) * v
		return resultat

p = PolyEval()
p.add_coeff(1, 2)
p.add_coeff(3, 3.5)
p.add_coeff(0, 3)
print(p.get_degree())
print(p.eval(2))

# Examen 14-15 Q1

def profunditat(llista):

	dicc = {}

	def eval(elem, depth):
		if isinstance(elem, list):
			maxDepth = depth + 1
			for elemAux in elem:
				depthAct = eval(elemAux, depth + 1)
				maxDepth = depthAct if depthAct > maxDepth else maxDepth
			return maxDepth
		else:
			return depth

	for elem in llista:
		depth = 0

		if isinstance(elem, list):
			depth = eval(elem, 0)

		if depth not in dicc:
			dicc[depth] = 1
		else:
			dicc[depth] += 1
	return dicc

print(profunditat([[3,4],[[6]],[[5,[]],[]],[[1,2],[]],3]))
print(profunditat([[1, [[[3, [4]]]]],2,3,4,5]))

class Tree:

	def __init__(self, x):
		self.rt = x
		self.child = []
	def addChild(self, a):
		self.child.append(a)
	def root(self):
		return self.rt
	def ithChild(self, i):
		return self.child[i]
	def numChildren(self):
		num = 0
		for ch in self.child:
			num += 1 + ch.numChildren()
		return num

class Pre(Tree):

	def preorder(self):
		preord = [self.rt]
		for child in self.child:
			preord += child.preorder()
		return preord

a = Pre(2)
b = Pre(3)
b.addChild(Pre(4))
b.addChild(Pre(5))
a.addChild(b)
c = Pre(6)
c.addChild(Pre(7))
c.addChild(Pre(8))
a.addChild(c)
print(a.preorder())
print(a.numChildren())

# Examen 13-14 Q1

def substring(llista, s):

	return list(filter(lambda x: s in x, llista))

print(substring(["abre", "arbvet", "arbori"], "ar"))

def zip2(llista1, llista2):
	llistaTupl = []
	len1 = len(llista1)
	len2 = len(llista2)
	minimaLen = len1 if len1 < len2 else len2
	for i in range(0,minimaLen):
		llistaTupl.append((llista1[i], llista2[i]))
	return llistaTupl

print(zip2([1,2,3,4], [5,6,7]))
