
#header
<<
#include <string>
#include <iostream>
#include <vector>
#include <iterator>
#include <map>
using namespace std;

// struct to store information about tokens
typedef struct {
  string kind;
  string text;
} Attrib;

// function to fill token information (predeclaration)
void zzcr_attr(Attrib *attr, int type, char *text);

// fields for AST nodes
#define AST_FIELDS string kind; string text;
#include "ast.h"

// macro to create a new AST node (and function predeclaration)
#define zzcr_ast(as,attr,ttype,textt) as=createASTnode(attr,ttype,textt)
AST* createASTnode(Attrib* attr, int ttype, char *textt);
//#define createASTlist #0=new AST;(#0)->kind="list";(#0)->right=NULL;(#0)->down=_sibling;
>>

<<
#include <cstdlib>
#include <cmath>

//global structures
AST *root;

struct Component {
  int unitat;
  string simbol;

  Component() {}
  Component(int u,string s) {
    unitat = u;
    simbol = s;
  }
};

struct Muntanya {
  vector <Component> definicio;
  bool wellformed;
  bool acabatId; //Considero que si acaba en Id al no completar-se llavors no puc saber l'altura ni dibuixar-la
  int altura;
  vector <int> comencaments; //utilitzat per la funció draw on es guarda l'altitud on comença cada muntanya 
  int alturaAcabament; //utilitzat per completar muntanyes guardant l'altura on acaba l'últim símbol per poder actualitzar-la

  Muntanya() {}
  Muntanya(vector <Component> definicio,bool wellformed, int altura,bool acabatId,
   int alturaAcabament,vector <int> comencaments) {
    this->definicio = definicio;
    this->wellformed = wellformed;
    this->altura = altura;
    this->acabatId = acabatId;
    this->comencaments = comencaments;
    this->alturaAcabament = alturaAcabament;
  }
};

map <string,Muntanya> muntanyesDefinides;
map <string,int> variablesDefinides;

const int ErrorIdNoTrobat = 0;
const int ErrorExpressioAritmeticaMalConstruida = 1;
const int ErrorDefMuntanyaIncorrecta = 2;
const int ErrorMuntanyaIncompletaMig = 3;
const int ErrorMuntanyaNoWellFormed = 4;

class Excepcio
{

private:
    int codiExcepcio;


public:
    Excepcio () {}
    Excepcio (int codi) {
        codiExcepcio = codi;
    }
    const char* missatgeError() const throw() {
        if (codiExcepcio == ErrorIdNoTrobat) 
            return "Error: La muntanya o variable numèrica no existeix";
        else if (codiExcepcio == ErrorExpressioAritmeticaMalConstruida) 
            return "Error: L'expressió aritmètica està mal construida, conté caràcters no vàlids";
        else  if (codiExcepcio == ErrorDefMuntanyaIncorrecta)
            return "Error: La definicio de muntanya és incorrecte, conté caràcters no vàlids";
        else if (codiExcepcio == ErrorMuntanyaIncompletaMig)
            return "Error: La muntanya està incompleta per la meitat";
        else if (codiExcepcio == ErrorMuntanyaNoWellFormed)
            return "Error: La muntanya està incompleta pel final i no es pot saber l'altitud ni dibuixar-la";

    }
};



// function to fill token information
void zzcr_attr(Attrib *attr, int type, char *text) {
  if (type == ID) {
    attr->kind = "id";
    attr->text = text;
  }

  else if (type == NUM) {
    attr->kind = "intconst";
    attr->text = text;
  }
    
  else {
    attr->kind = text;
    attr->text = "";
  }

}

// function to create a new AST node
AST* createASTnode(Attrib* attr, int type, char* text) {
  AST* as = new AST;
  as->kind = attr->kind; 
  as->text = attr->text;
  as->right = NULL; 
  as->down = NULL;
  return as;
}

/// create a new "list" AST node with one element
AST* createASTlist(AST *child) {
  AST *as = new AST;
  as->kind = "list";
  as->right = NULL;
  as->down = child;
  return as;
}

/// get nth child of a tree. Count starts at 0.
/// if no such child, returns NULL
AST* child(AST *a, int n) {
  AST *c = a->down;
  for (int i=0; c!=NULL && i<n; i++) c = c->right;
  return c;
}


/// print AST, recursively, with indentation
void ASTPrintIndent(AST *a, string s) {
  if (a == NULL) return;

  cout << a->kind;
  if (a->text != "") cout << "(" << a->text << ")";
  cout << endl;

  AST *i = a->down;
  while (i != NULL && i->right != NULL) {
    cout << s+"  \\__";
    ASTPrintIndent(i, s+"  |"+string(i->kind.size()+i->text.size(), ' '));
    i = i->right;
  }
  
  if (i != NULL) {
    cout << s+"  \\__";
    ASTPrintIndent(i, s+"   "+string(i->kind.size()+i->text.size(), ' '));
    i = i->right;
  }
}

/// print AST 
void ASTPrint(AST *a) {
  while (a != NULL) {
    cout << " ";
    ASTPrintIndent(a, "");
    a = a->right;
  }
}


Muntanya crearMuntanya(AST* node);


int evaluarExpressioAritmetica (AST* node) {

    if (node == NULL)
        throw(Excepcio(ErrorExpressioAritmeticaMalConstruida)); /*Pel cas on tens com a pare un node del tipus "-" o "/" però
                                                                realment estàs definint ua muntanya i per tant no té fills (1*- per exemple) */

    if (node->kind == ";" or node->kind == "Peak" or node->kind == "Valley" or node->kind == "\\")
        throw(Excepcio(ErrorExpressioAritmeticaMalConstruida));

    if (node->kind == "id") {
        map <string,int>::iterator it = variablesDefinides.find(node->text);
        if (it == variablesDefinides.end())
            throw(Excepcio(ErrorIdNoTrobat));
        else 
            return it->second;
    }
    else if (node->kind == "intconst")
        return atoi(node->text.c_str());

    else if (node->kind == "+") {
        return evaluarExpressioAritmetica(child(node,0)) +
            evaluarExpressioAritmetica(child(node,1));
    }
    else if (node->kind == "-") {
        return evaluarExpressioAritmetica(child(node,0)) -
            evaluarExpressioAritmetica(child(node,1));
    }
    else if (node->kind == "/") {
        return evaluarExpressioAritmetica(child(node,0)) /
            evaluarExpressioAritmetica(child(node,1));
    }
    else if (node->kind == "Height") { //Utilitzat només en les condicions booleanas
        Muntanya m = crearMuntanya(node->down);
        if (!m.wellformed)
            throw(Excepcio(ErrorMuntanyaNoWellFormed));
        else
            return m.altura;
    }
    else {       
        return evaluarExpressioAritmetica(child(node,0)) *
            evaluarExpressioAritmetica(child(node,1));
    }
}



void actualitzaAltura(string simbol, int valor, int& altura, int& currentHeight,
    vector <int>& comencaments,bool inici) {

    if (inici) comencaments.push_back(currentHeight);

    if (simbol == "/") {
        currentHeight += valor;
        if (currentHeight > altura) altura = currentHeight;
    }
    else if (simbol == "\\") {
        currentHeight -= valor;
        if (currentHeight < 0) {
            altura = altura + currentHeight*(-1);
            for (int i = 0;i <= comencaments.size()-1;++i)
                comencaments[i] += currentHeight*(-1);
            currentHeight = 0;
        }
    }
}

void obtenirDefinicioMuntanya (AST* node, vector <Component>& definicio, int& altura, int& currentHeight,
    vector <int>& comencaments) {

    if (node->kind == "+" or node->kind == "-" or node->kind == "/" or node->kind == "intconst" or node->kind == "\\")
        throw(Excepcio(ErrorDefMuntanyaIncorrecta));
   
    if (node->kind == "Peak" or node->kind == "Valley") {
        if (definicio.size()%3 != 0)
            throw(Excepcio(ErrorMuntanyaIncompletaMig));

        int valor1 = evaluarExpressioAritmetica(child(node,0));
        int valor2 = evaluarExpressioAritmetica(child(node,1));
        int valor3 = evaluarExpressioAritmetica(child(node,2));

        if (valor1 == 0 or valor2 == 0 or valor3 == 0)
            throw(Excepcio(ErrorDefMuntanyaIncorrecta));

        Component c2 (valor2,"-");
        Component c1,c3;
        c1.unitat = valor1;
        c3.unitat = valor3;
        if (node->kind == "Peak") {
            c1.simbol = "/";
            c3.simbol = "\\";
        }
        else {
            c1.simbol = "\\";
            c3.simbol = "/";
        }
        actualitzaAltura(c1.simbol,c1.unitat,altura,currentHeight,comencaments,true);
        actualitzaAltura(c3.simbol,c3.unitat,altura,currentHeight,comencaments,false);
        definicio.push_back(c1);
        definicio.push_back(c2);
        definicio.push_back(c3);
    }
    else if (node->kind == "id") {
        if (definicio.size()%3 != 0) 
            throw(Excepcio(ErrorMuntanyaIncompletaMig));

        map <string,Muntanya>::const_iterator it = muntanyesDefinides.find(node->text);
        if (it == muntanyesDefinides.end())
            throw(Excepcio(ErrorIdNoTrobat));

        if (!it->second.wellformed and node->right != NULL) 
            throw(Excepcio(ErrorMuntanyaIncompletaMig));

        for (int i = 0;i < it->second.definicio.size();++i) {
            Component c = it->second.definicio[i];
            if (i%3 == 0)
                actualitzaAltura(c.simbol,c.unitat,altura,currentHeight,comencaments,true);
            else
                actualitzaAltura(c.simbol,c.unitat,altura,currentHeight,comencaments,false);
            definicio.push_back(c);
        }   
    }
    else if (node->kind == "*") {
        AST* fillDret = child(node,1);
        if (child(node,0)->kind != "intconst" or (fillDret->kind != "/" and fillDret->kind != "-" and fillDret->kind != "\\") 
            or ((fillDret->kind == "/" or fillDret->kind == "-") and fillDret->down != NULL))
            throw(Excepcio(ErrorDefMuntanyaIncorrecta)); //Com el * pot ser d'una expressió aritmètica comprovo que sigui realment part de la definició

        int mida = definicio.size();
        int valor = atoi(child(node,0)->text.c_str());

        if (valor == 0)
            throw(Excepcio(ErrorDefMuntanyaIncorrecta));

        string simbol = fillDret->kind;
        if (mida%3 == 0 and simbol == "-") 
            throw(Excepcio(ErrorMuntanyaIncompletaMig));
        else if (mida%3 == 1 and simbol != "-")
            throw(Excepcio(ErrorMuntanyaIncompletaMig));
        else if (mida%3 == 2 and (simbol == "-" or (simbol == "/" and definicio[mida-2].simbol != "\\") or 
            (simbol == "\\" and definicio[mida-2].simbol != "/")))
            throw(Excepcio(ErrorMuntanyaIncompletaMig));

        if (simbol != "-") {
            if (mida%3 == 0)
                actualitzaAltura(simbol,valor,altura,currentHeight,comencaments,true);
            else   
                actualitzaAltura(simbol,valor,altura,currentHeight,comencaments,false);
        }
        Component c (valor,simbol);
        definicio.push_back(c);
    }
    else { //";"
        obtenirDefinicioMuntanya(child(node,0),definicio,altura,currentHeight,comencaments);
        obtenirDefinicioMuntanya(child(node,1),definicio,altura,currentHeight,comencaments);
    }
    
}


Muntanya crearMuntanya(AST* node) {

    if (node->kind == "id") { //únicament està formada per un id
        map <string,Muntanya>::const_iterator it = muntanyesDefinides.find(node->text);
        Muntanya m;
        if (it == muntanyesDefinides.end()) {
            throw(Excepcio(ErrorIdNoTrobat));
        }
        else {
            m = it->second;
            m.acabatId = true;
            return m;
        }
    }
    else {
        int altura = 0;
        int currentHeight = 0;
        vector <Component> definicio;
        vector <int> comencaments;
        obtenirDefinicioMuntanya(node,definicio,altura,currentHeight,comencaments);

        int alturaAcabament = currentHeight;
        bool wellformed = (definicio.size()%3 == 0);
        bool acabatId = (child(node,1) != NULL and child(node,1)->kind == "id");
        Muntanya m (definicio,wellformed,altura,acabatId,alturaAcabament,comencaments);
        return m;
    }
}

bool comprovaDef (AST* node) {

    if (node->kind == "Peak" or node->kind == "Valley" or node->kind == ";" or
        (node->kind == "*" and child(node,0)->kind == "intconst" and (child(node,1)->kind == "/" or
            child(node,1)->kind == "\\" or child(node,1)->kind == "-") and child(node,1)->down == NULL)) 
        return true;
    else if (node->kind == "id") {
        map <string,Muntanya>::const_iterator it = muntanyesDefinides.find(node->text);
        if (it != muntanyesDefinides.end()) 
            return true;
        map <string,int>::const_iterator it2 = variablesDefinides.find(node->kind);
        if (it2 != variablesDefinides.end())
            return false;
        throw(Excepcio(ErrorIdNoTrobat));
    }
    else 
        return false;
}


void creacioIs(AST* node) {

    string id = node->text;
    if (comprovaDef(node->right)) { //Definim una muntanya
        Muntanya m = crearMuntanya(node->right);
        map <string,Muntanya>::iterator it = muntanyesDefinides.find(id);
        if (it == muntanyesDefinides.end())
            muntanyesDefinides.insert(make_pair(id,m));
        else
            it->second = m;
    }
    else { //Definim una variable numèrica
        int valor = evaluarExpressioAritmetica (node->right);
        map <string,int>::iterator it = variablesDefinides.find(id);
        if (it == variablesDefinides.end())
            variablesDefinides.insert(make_pair(id,valor));
        else 
            it->second = valor;
    }
}


bool evaluarExpressioBooleana (AST* node) {

    if (node->kind == "NOT")
        return !evaluarExpressioBooleana(node->down);
    else if (node->kind == "AND") {
        return evaluarExpressioBooleana(child(node,0)) &&
            evaluarExpressioBooleana(child(node,1));
    }
    else if (node->kind == "OR") {
        return evaluarExpressioBooleana(child(node,0)) ||
            evaluarExpressioBooleana(child(node,1));
    }
    else if (node->kind == ">") {
        return evaluarExpressioAritmetica(child(node,0)) >
            evaluarExpressioAritmetica(child(node,1));
    }
    else if (node->kind == "<") {
        return evaluarExpressioAritmetica(child(node,0)) <
            evaluarExpressioAritmetica(child(node,1));
    }
    else if (node->kind == "==") {
        return evaluarExpressioAritmetica(child(node,0)) ==
            evaluarExpressioAritmetica(child(node,1));
    }
    else if (node->kind == "Match") {
        Muntanya m1 = crearMuntanya(child(node,0));
        Muntanya m2 = crearMuntanya(child(node,1));
        if (m1.wellformed and m2.wellformed) {
            return (m1.altura == m2.altura);
        }
        else 
            throw(Excepcio(ErrorMuntanyaNoWellFormed));
    }
    else if (node->kind == "Wellformed") { 
        Muntanya m = crearMuntanya(node->down);
        return m.wellformed;   
    }
}


void draw (AST* node) {

    Muntanya m = crearMuntanya(node);
    if (!m.wellformed)
        throw(Excepcio(ErrorMuntanyaNoWellFormed));

    bool espaiNecessari = false; 

    /*Com pot haver pic i vall alhora necessito considerar l'altitud de la muntanya més dues unitats per quan toca
    dibuixar els cims (-) i per no fer incoherent els salts de línia per separar cada cop que es dibuixa, forço a que 
    sempre es deixi una línia en blanc després de dibuixar-la */

    bool pic;
    int alturaComencamentPujada,alturaComencamentBaixada,alturaComencamentCentre;
    for (int j = m.altura+1;j >= 0;--j) { 
        for (int i = 0;i < m.definicio.size();i+= 3) {
            if (m.definicio[i].simbol == "/") {
                pic = true;
                alturaComencamentPujada = m.comencaments[i/3] + 1; /* Com considero l'altura on comença el pic però es dibuixa cap a dalt
                                                                    li sumo 1 per dibuixar-lo a l'altura on toca. En canvi en el cas d'una vall
                                                                    com es dibuixa cap a baix no li sumo menys si és una vall sola sense concatenar
                                                                    per el tema ja comentat del salt de línia del final*/

                alturaComencamentBaixada = alturaComencamentPujada + m.definicio[i].unitat - 1;
                alturaComencamentCentre = alturaComencamentPujada + m.definicio[i].unitat;
            }
            else {
                pic = false;
                alturaComencamentBaixada = m.comencaments[i/3];
                if (m.definicio.size() == 3) 
                    alturaComencamentBaixada++;
                alturaComencamentPujada = alturaComencamentBaixada - m.definicio[i].unitat + 1;
                alturaComencamentCentre = alturaComencamentBaixada - m.definicio[i].unitat;
            }
            for (int unitat1 = 0;unitat1 < m.definicio[i].unitat;++unitat1) {
                if (pic) {
                    if (alturaComencamentPujada + unitat1 == j) cout << "/";                    
                    else cout << " ";
                }
                else {
                    if (alturaComencamentBaixada - unitat1 == j) cout << "\\";                   
                    else cout << " ";
                }
            }
            for (int unitat2 = 0;unitat2 < m.definicio[i+1].unitat;++unitat2) {
                if (alturaComencamentCentre == j) {
                    cout << "-";
                    if (!pic and j == 0) espaiNecessari = true;
                }
                else cout << " ";
            }
            for (int unitat3 = 0;unitat3 < m.definicio[i+2].unitat;++unitat3) {
                if (pic) {
                    if (alturaComencamentBaixada - unitat3 == j) cout << "\\";                   
                    else cout << " ";
                }
                else {
                    if (alturaComencamentPujada + unitat3 == j) cout << "/";            
                    else cout << " ";
                }
            }
        }
        cout << endl;
    }
    if (espaiNecessari) cout << endl;
}

void complete (AST* node) {

    map <string,Muntanya>::iterator it = muntanyesDefinides.find(node->text);
    if (it == muntanyesDefinides.end())
        throw(Excepcio(ErrorIdNoTrobat));

    Muntanya * punter = &it->second;

    if (!punter->wellformed and !punter->acabatId) {
        int mida = punter->definicio.size();
        if (punter->definicio[mida-1].simbol == "-") {
            if (punter->definicio[mida-2].simbol == "/") {
                punter->definicio.push_back(Component(1,"\\"));
                actualitzaAltura("\\",1,punter->altura,punter->alturaAcabament,punter->comencaments,false);
            }
            else {
                punter->definicio.push_back(Component(1,"/"));
                actualitzaAltura("/",1,punter->altura,punter->alturaAcabament,punter->comencaments,false);
            }
        }
        else if (punter->definicio[mida-1].simbol == "/") {
            punter->definicio.push_back(Component(1,"-"));
            punter->definicio.push_back(Component(1,"\\"));
            actualitzaAltura("\\",1,punter->altura,punter->alturaAcabament,punter->comencaments,false);
        }
        else {
            punter->definicio.push_back(Component(1,"-"));
            punter->definicio.push_back(Component(1,"/"));
            actualitzaAltura("/",1,punter->altura,punter->alturaAcabament,punter->comencaments,false);
        }

        punter->wellformed = true;
    }
}


void execute (AST* node) {
    try {
        if (node == NULL) return;
        else if (node->kind == "list")
            execute(node->down);
        else if (node->kind == "Draw") 
            draw(node->down);
        else if (node->kind == "Complete")
            complete(node->down);
        else if (node->kind ==  "is") 
            creacioIs(node->down);
        else if (node->kind == "if") {
            if (evaluarExpressioBooleana(node->down))
                execute(child(node,1));
        }
        else if (node->kind == "while") {
            while (evaluarExpressioBooleana(node->down)) 
                execute(child(node,1));
        }
    }
    catch(Excepcio& exc) {
        cout << exc.missatgeError() << endl;
    }
    execute(node->right);
}

void imprimirArbres() {
    cout << "------------------------------------------------" <<  endl;
    cout << "Altituds de les muntanyes correctament formades:" << endl;
    for (map<string,Muntanya>::const_iterator it = muntanyesDefinides.begin(); it != muntanyesDefinides.end(); ++it) {
        if (it->second.wellformed)
            cout << "L'altitud final de la muntanya " << it->first << " " << "és:" << " " << it->second.altura << endl;
    }
}



int main() {
  root = NULL;
  ANTLR(mountains(&root), stdin);
  ASTPrint(root);
  execute(root);
  imprimirArbres();
}
>>


#lexclass START
#token BAR "\/"
#token DOWN "\\"
#token HIPHEN "\-"
#token CONCAT ";"
#token NUM "[0-9]+"
#token STAR "\*"
#token REF "#"
#token PLUS "\+"
#token COMMA ","
#token LPAR "\("
#token RPAR "\)"
#token IS "is"

#token AND "AND"
#token OR "OR"
#token NOT "NOT"
#token GT ">"
#token LT "<"
#token EQ "=="

#token CREATEFUNC "Peak | Valley"
#token MATCHFUNC "Match"
#token HEIGHTFUNC "Height"
#token WELLFORMEDFUNC "Wellformed"
#token DRAWFUNC "Draw"
#token COMPLETEFUNC "Complete"

#token IF "if"
#token ENDIF "endif"
#token WHILE "while"
#token ENDWHILE "endwhile"

#token ID "[a-zA-Z][a-zA-Z0-9]*";

#token SPACE "[\ \t \n]" << zzskip(); >>


mountains: (inst)* << #0 = createASTlist(_sibling); >>;
inst: assign | condic | draw | iter | complete ;

assign: ID IS^ assignedValue;

assignedValue: part (CONCAT^ part)*;
part : REF! ID | peakOrValley | plusMinusOp;

plusMinusOp: starBarOp ((PLUS^ | HIPHEN^) starBarOp)*;
starBarOp: operand ((STAR^ | BAR^) operand)*;
operand: NUM | BAR | HIPHEN | DOWN | ID | LPAR! plusMinusOp RPAR!;
//Conté els simbols de definició de muntanya per poder fer les definicions del tipus 1*/


peakOrValley: CREATEFUNC^ LPAR! plusMinusOp COMMA! plusMinusOp COMMA! plusMinusOp RPAR!;

condic: IF^ LPAR! expBool RPAR! mountains ENDIF!;
iter: WHILE^ LPAR! expBool RPAR! mountains ENDWHILE!;

expBool: (NOT^ | ) termBoolOR ;
termBoolOR: termBoolAND (OR^ termBoolAND)* ;
termBoolAND: termBoolLessPrecedence (AND^ termBoolLessPrecedence)* ;
termBoolLessPrecedence: match | wellformed | relationTerm (GT^ | LT^ | EQ^) relationTerm ;
relationTerm: plusMinusOp | height;

draw: DRAWFUNC^ LPAR! assignedValue RPAR! ; 

complete: COMPLETEFUNC^ LPAR! ID RPAR! ;

height: HEIGHTFUNC^ LPAR! assignedValue RPAR! ; 

match: MATCHFUNC^ LPAR! assignedValue COMMA! assignedValue RPAR! ; 

wellformed: WELLFORMEDFUNC^ LPAR! ID RPAR! ;