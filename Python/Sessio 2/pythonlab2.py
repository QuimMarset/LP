

class Punt:

	a = 846 # Atribut estàtic de la classe -> Consultar a través de Punt.a

# Atributs definits dins el init
	def __init__(self, x, y):
		self.x = x
		self.y = y

	def moure(self, dx, dy):
		self.x += dx
		self.y += dy

	def escriure(self):
		print(self.x, self.y)

	def __repr__ (self):
		return "soc el punt " + str(self.x) + "," + str(self.y)
		
#self es el paràmetre implícit, es passa a les funcions de la declaració de la classe
# en les crides no ja que la instància ja ho serà

# tots els atributs són públics, no hi ha visibilitat -> conveni de posar-hi un subratllat davant

#Herència

class PuntAmbColor(Punt):

	def __init__(self, x, y, c):
		self.x = x
		self.y = y
		self.c = c


p = Punt(3, 6)
p.escriure()


# Funcio dins d'una altre, la interior té la informació que té la exterior -> Clausura
# La f i la d no es perd i dins les podem fer servir

def memo(f):

	d = {}

	def aux(x):
		if x in d:
			return d[x]
		else:
			r = f(x)
			d[x] = r
			return r

	return aux

# retorna una nova funció, i quan es fa fib(n-2) i fib(n-1) es criden a la que retorna memo
# fib s'anirà omplint a mesura que es calculin

fib = memo(fib)



def f (x = []):
	x.append(3)
	return x

# Variables per defecte -> El valor es calcula una sola vegada -> print f() [3], print f() [3,3]