/*
 * A n t l r  T r a n s l a t i o n  H e a d e r
 *
 * Terence Parr, Will Cohen, and Hank Dietz: 1989-2001
 * Purdue University Electrical Engineering
 * With AHPCRC, University of Minnesota
 * ANTLR Version 1.33MR33
 *
 *   antlr -gt mountains.g
 *
 */

#define ANTLR_VERSION	13333
#include "pcctscfg.h"
#include "pccts_stdio.h"

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
#define GENAST

#include "ast.h"

#define zzSET_SIZE 8
#include "antlr.h"
#include "tokens.h"
#include "dlgdef.h"
#include "mode.h"

/* MR23 In order to remove calls to PURIFY use the antlr -nopurify option */

#ifndef PCCTS_PURIFY
#define PCCTS_PURIFY(r,s) memset((char *) &(r),'\0',(s));
#endif

#include "ast.c"
zzASTgvars

ANTLR_INFO

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
  bool acabatId;
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

    if (node->kind == ";" or node->kind == "Peak" or node->kind == "Valley")
throw(Excepcio(ErrorExpressioAritmeticaMalConstruida));
else {
if (node->kind == "id") {
if (node->text[0] == 'M')
throw(Excepcio(ErrorExpressioAritmeticaMalConstruida));

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
else { //producte
AST* fillDret = child(node,1);
if (fillDret->kind == "\\" or ((fillDret->kind == "/" or fillDret->kind == "-") 
and fillDret->down == NULL))
throw(Excepcio(ErrorExpressioAritmeticaMalConstruida));

            return evaluarExpressioAritmetica(child(node,0)) *
evaluarExpressioAritmetica(child(node,1));
}
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

    if (node->kind == "+" or node->kind == "-" or node->kind == "/" or node->kind == "intconst")
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
if (node->text[0] != 'M')
throw(Excepcio(ErrorDefMuntanyaIncorrecta));

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
or ((fillDret->kind == "/" or fillDret->kind == "-") and child(node,1)->down != NULL))
throw(Excepcio(ErrorDefMuntanyaIncorrecta));

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


void creacioIs(AST* node) {

    string id = node->text;
if (id[0] == 'M') { //Definim una muntanya
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
bool pic;
int alturaComencamentPujada,alturaComencamentBaixada,alturaComencamentCentre;
for (int j = m.altura+1;j >= 0;--j) { 
for (int i = 0;i < m.definicio.size();i+= 3) {
if (m.definicio[i].simbol == "/") {
pic = true;
alturaComencamentPujada = m.comencaments[i/3] + 1; 
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

void
#ifdef __USE_PROTOS
mountains(AST**_root)
#else
mountains(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    while ( (setwd1[LA(1)]&0x1) ) {
      inst(zzSTR); zzlink(_root, &_sibling, &_tail);
      zzLOOP(zztasp2);
    }
    zzEXIT(zztasp2);
    }
  }
  (*_root) = createASTlist(_sibling);
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd1, 0x2);
  }
}

void
#ifdef __USE_PROTOS
inst(AST**_root)
#else
inst(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  if ( (LA(1)==ID) ) {
    assign(zzSTR); zzlink(_root, &_sibling, &_tail);
  }
  else {
    if ( (LA(1)==IF) ) {
      condic(zzSTR); zzlink(_root, &_sibling, &_tail);
    }
    else {
      if ( (LA(1)==DRAWFUNC) ) {
        draw(zzSTR); zzlink(_root, &_sibling, &_tail);
      }
      else {
        if ( (LA(1)==WHILE) ) {
          iter(zzSTR); zzlink(_root, &_sibling, &_tail);
        }
        else {
          if ( (LA(1)==COMPLETEFUNC) ) {
            complete(zzSTR); zzlink(_root, &_sibling, &_tail);
          }
          else {zzFAIL(1,zzerr1,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
        }
      }
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd1, 0x4);
  }
}

void
#ifdef __USE_PROTOS
assign(AST**_root)
#else
assign(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(ID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(IS); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  assignedValue(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd1, 0x8);
  }
}

void
#ifdef __USE_PROTOS
assignedValue(AST**_root)
#else
assignedValue(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  part(zzSTR); zzlink(_root, &_sibling, &_tail);
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    while ( (LA(1)==CONCAT) ) {
      zzmatch(CONCAT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
      part(zzSTR); zzlink(_root, &_sibling, &_tail);
      zzLOOP(zztasp2);
    }
    zzEXIT(zztasp2);
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd1, 0x10);
  }
}

void
#ifdef __USE_PROTOS
part(AST**_root)
#else
part(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  if ( (LA(1)==REF) ) {
    zzmatch(REF);  zzCONSUME;
    zzmatch(ID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
  }
  else {
    if ( (LA(1)==CREATEFUNC) ) {
      peakOrValley(zzSTR); zzlink(_root, &_sibling, &_tail);
    }
    else {
      if ( (setwd1[LA(1)]&0x20) ) {
        plusMinusOp(zzSTR); zzlink(_root, &_sibling, &_tail);
      }
      else {zzFAIL(1,zzerr2,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd1, 0x40);
  }
}

void
#ifdef __USE_PROTOS
plusMinusOp(AST**_root)
#else
plusMinusOp(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  productDivOp(zzSTR); zzlink(_root, &_sibling, &_tail);
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    while ( (setwd1[LA(1)]&0x80) ) {
      {
        zzBLOCK(zztasp3);
        zzMake0;
        {
        if ( (LA(1)==PLUS) ) {
          zzmatch(PLUS); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
        }
        else {
          if ( (LA(1)==HIPHEN) ) {
            zzmatch(HIPHEN); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
          }
          else {zzFAIL(1,zzerr3,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
        }
        zzEXIT(zztasp3);
        }
      }
      productDivOp(zzSTR); zzlink(_root, &_sibling, &_tail);
      zzLOOP(zztasp2);
    }
    zzEXIT(zztasp2);
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd2, 0x1);
  }
}

void
#ifdef __USE_PROTOS
productDivOp(AST**_root)
#else
productDivOp(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  operand(zzSTR); zzlink(_root, &_sibling, &_tail);
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    while ( (setwd2[LA(1)]&0x2) ) {
      {
        zzBLOCK(zztasp3);
        zzMake0;
        {
        if ( (LA(1)==STAR) ) {
          zzmatch(STAR); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
        }
        else {
          if ( (LA(1)==BAR) ) {
            zzmatch(BAR); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
          }
          else {zzFAIL(1,zzerr4,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
        }
        zzEXIT(zztasp3);
        }
      }
      operand(zzSTR); zzlink(_root, &_sibling, &_tail);
      zzLOOP(zztasp2);
    }
    zzEXIT(zztasp2);
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd2, 0x4);
  }
}

void
#ifdef __USE_PROTOS
operand(AST**_root)
#else
operand(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  if ( (LA(1)==NUM) ) {
    symbol(zzSTR); zzlink(_root, &_sibling, &_tail);
  }
  else {
    if ( (LA(1)==ID) ) {
      zzmatch(ID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
    }
    else {
      if ( (LA(1)==LPAR) ) {
        zzmatch(LPAR);  zzCONSUME;
        plusMinusOp(zzSTR); zzlink(_root, &_sibling, &_tail);
        zzmatch(RPAR);  zzCONSUME;
      }
      else {zzFAIL(1,zzerr5,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd2, 0x8);
  }
}

void
#ifdef __USE_PROTOS
symbol(AST**_root)
#else
symbol(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(NUM); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    if ( (setwd2[LA(1)]&0x10) ) {
    }
    else {
      if ( (LA(1)==AND) ) {
        zzmatch(AND); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
        {
          zzBLOCK(zztasp3);
          zzMake0;
          {
          if ( (LA(1)==BAR) ) {
            zzmatch(BAR); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
          }
          else {
            if ( (LA(1)==HIPHEN) ) {
              zzmatch(HIPHEN); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
            }
            else {
              if ( (LA(1)==DOWN) ) {
                zzmatch(DOWN); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
              }
              else {zzFAIL(1,zzerr6,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
            }
          }
          zzEXIT(zztasp3);
          }
        }
      }
      else {zzFAIL(1,zzerr7,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
    }
    zzEXIT(zztasp2);
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd2, 0x20);
  }
}

void
#ifdef __USE_PROTOS
peakOrValley(AST**_root)
#else
peakOrValley(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(CREATEFUNC); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(LPAR);  zzCONSUME;
  assignedValue(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzmatch(COMMA);  zzCONSUME;
  assignedValue(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzmatch(COMMA);  zzCONSUME;
  assignedValue(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzmatch(RPAR);  zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd2, 0x40);
  }
}

void
#ifdef __USE_PROTOS
condic(AST**_root)
#else
condic(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(IF); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(LPAR);  zzCONSUME;
  expBool(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzmatch(RPAR);  zzCONSUME;
  mountains(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzmatch(ENDIF);  zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd2, 0x80);
  }
}

void
#ifdef __USE_PROTOS
iter(AST**_root)
#else
iter(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(WHILE); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(LPAR);  zzCONSUME;
  expBool(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzmatch(RPAR);  zzCONSUME;
  mountains(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzmatch(ENDWHILE);  zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd3, 0x1);
  }
}

void
#ifdef __USE_PROTOS
expBool(AST**_root)
#else
expBool(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    if ( (LA(1)==NOT) ) {
      zzmatch(NOT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
    }
    else {
      if ( (setwd3[LA(1)]&0x2) ) {
      }
      else {zzFAIL(1,zzerr8,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
    }
    zzEXIT(zztasp2);
    }
  }
  termBoolOR(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd3, 0x4);
  }
}

void
#ifdef __USE_PROTOS
termBoolOR(AST**_root)
#else
termBoolOR(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  termBoolAND(zzSTR); zzlink(_root, &_sibling, &_tail);
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    while ( (LA(1)==OR) ) {
      zzmatch(OR); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
      termBoolAND(zzSTR); zzlink(_root, &_sibling, &_tail);
      zzLOOP(zztasp2);
    }
    zzEXIT(zztasp2);
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd3, 0x8);
  }
}

void
#ifdef __USE_PROTOS
termBoolAND(AST**_root)
#else
termBoolAND(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  termBoolLessPrecedence(zzSTR); zzlink(_root, &_sibling, &_tail);
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    while ( (LA(1)==AND) ) {
      zzmatch(AND); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
      termBoolLessPrecedence(zzSTR); zzlink(_root, &_sibling, &_tail);
      zzLOOP(zztasp2);
    }
    zzEXIT(zztasp2);
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd3, 0x10);
  }
}

void
#ifdef __USE_PROTOS
termBoolLessPrecedence(AST**_root)
#else
termBoolLessPrecedence(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  if ( (LA(1)==MATCHFUNC) ) {
    match(zzSTR); zzlink(_root, &_sibling, &_tail);
  }
  else {
    if ( (LA(1)==WELLFORMEDFUNC) ) {
      wellformed(zzSTR); zzlink(_root, &_sibling, &_tail);
    }
    else {
      if ( (setwd3[LA(1)]&0x20) ) {
        relationTerm(zzSTR); zzlink(_root, &_sibling, &_tail);
        {
          zzBLOCK(zztasp2);
          zzMake0;
          {
          if ( (LA(1)==GT) ) {
            zzmatch(GT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
          }
          else {
            if ( (LA(1)==LT) ) {
              zzmatch(LT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
            }
            else {
              if ( (LA(1)==EQ) ) {
                zzmatch(EQ); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
              }
              else {zzFAIL(1,zzerr9,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
            }
          }
          zzEXIT(zztasp2);
          }
        }
        relationTerm(zzSTR); zzlink(_root, &_sibling, &_tail);
      }
      else {zzFAIL(1,zzerr10,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd3, 0x40);
  }
}

void
#ifdef __USE_PROTOS
relationTerm(AST**_root)
#else
relationTerm(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  if ( (LA(1)==NUM) ) {
    zzmatch(NUM); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
  }
  else {
    if ( (LA(1)==HEIGHTFUNC) ) {
      height(zzSTR); zzlink(_root, &_sibling, &_tail);
    }
    else {zzFAIL(1,zzerr11,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd3, 0x80);
  }
}

void
#ifdef __USE_PROTOS
draw(AST**_root)
#else
draw(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(DRAWFUNC); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(LPAR);  zzCONSUME;
  assignedValue(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzmatch(RPAR);  zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd4, 0x1);
  }
}

void
#ifdef __USE_PROTOS
complete(AST**_root)
#else
complete(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(COMPLETEFUNC); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(LPAR);  zzCONSUME;
  zzmatch(ID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(RPAR);  zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd4, 0x2);
  }
}

void
#ifdef __USE_PROTOS
height(AST**_root)
#else
height(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(HEIGHTFUNC); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(LPAR);  zzCONSUME;
  assignedValue(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzmatch(RPAR);  zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd4, 0x4);
  }
}

void
#ifdef __USE_PROTOS
match(AST**_root)
#else
match(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(MATCHFUNC); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(LPAR);  zzCONSUME;
  assignedValue(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzmatch(COMMA);  zzCONSUME;
  assignedValue(zzSTR); zzlink(_root, &_sibling, &_tail);
  zzmatch(RPAR);  zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd4, 0x8);
  }
}

void
#ifdef __USE_PROTOS
wellformed(AST**_root)
#else
wellformed(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(WELLFORMEDFUNC); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(LPAR);  zzCONSUME;
  zzmatch(ID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
  zzmatch(RPAR);  zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd4, 0x10);
  }
}
