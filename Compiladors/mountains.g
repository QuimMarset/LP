
#header
<<
#include <string>
#include <iostream>
#include <vector>
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

typedef struct {
  int unitat;
  string simbol;
} Component;

typedef struct {
  vector <Component> definicio;
  bool wellformed;
  int altura;
} Muntanya;

map <string,Muntanya> muntanyesDefinides;
map <string,int> variablesDefinides;


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


Muntanya obtenirMuntanya(string id) {

  map <string,Muntanya>::it = muntanyesDefinides.find(node->text);
  if (it != muntanyesDefinides.end()) {
    return it->second;
  }
  else {

  }


}

// =================== Height =======================

int height (vector <Component> definicio) {


}

// ==================================================

// =================== Match ========================

bool match () {

}

// ==================================================

int evaluate(AST* node) {

  if (node == NULL) 
    return 0;

  else if (node->kind == "intconst") 
    return atoi(node->text.c_str());

  else if (node->kind == "id")
    return variablesDefinides[node->text];

  else if (node->kind == "+")
    return evaluate(child(node,0)) + evaluate(child(node,1));

  else if (node->kind == "-")
    return evaluate(child(node,0)) - evaluate(child(node,1));

  else if (node->kind == "*")
    return evaluate(child(node,0)) * evaluate(child(node,1));

  else if (node->kind == "/")
    return evaluate(child(node,0)) / evaluate(child(node,1));

  else if (node->kind == "NOT")
    return !evaluate(child(node,0));

  else if (node->kind == "AND")
    return (evaluate(child(node,0)) && evaluate(child(node,1));

  else if (node->kind == "OR")
    return (evaluate(child(node,0)) || evaluate(child(node,1));

  else if (node->kind == "<")
    return (evaluate(child(node,0)) < evaluate(child(node,1));

  else if (node->kind == ">")
    return (evaluate(child(node,0)) > evaluate(child(node,1));

  else if (node->kind == "==")
    return (evaluate(child(node,0)) == evaluate(child(node,1));

  else if (node->kind == "Match") {
    
  }
    

  else if (node->kind == "Height") {
   

  }

}



// ============== Creació/Modificació de muntanya =====================

vector <Component> preProces(AST* node) {

  if (node->kind == "id") {

    map <string,Muntanya>::it = muntanyesDefinides.find(node->text);
    if (it != muntanyesDefinides.end())
      return (it->second).definicio;
  }

  else if (node->kind == "*") {

    int unitat = evaluate(child(node,0));
    string simbol = (child(node,1))->text;
    Component c = Component(unitat,simbol);
    vector <Component> definicio;
    definicio.push_back(c);
    return definicio;

  }
  else if (node->kind == "Peak") {
    Muntanya m = peak(node);
    return m.definicio;

  }
  else if (node->kind == "Valley") {
    Muntanya m = valley(node);
    return m.definicio;

  }
  else if (node->kind == ";") {

    vector <Component> defFill0 = preProces(child(node,0));
    vector <Component> defFill1 = preProces(child(node,1));
    vector <Component> definicio;
    definicio.insert(definicio.end(),defFill0);
    definicio.insert(definicio.end(),defFill1);
    return definicio;
  }
}



bool correctesaDefinicio(vector <Component> definicio) {

  bool incorrecte = false;
  while (i < definicio.size() and not incorrecte) {

    if (definicio[i].unitat == 0)
      incorrecte = true;

    if (i%3 == 0 and definicio[i].simbol == "-")
      incorrecte = true;
    else if (i%3 == 1 and definicio[i].simbol != "-")
      incorrecte = true;
    else if (i%3 == 2)
      if (definicio[i].simbol == "-")
        incorrecte = true;
      else 
        if (definicio[i].simbol == definicio[i-2].simbol)
          incorrecte = true;

    ++i;
  }
  return incorrecte;
}

bool wellFormed(vector <Component> definicio,bool acabamentId) {

  bool wellformed = true;
  if (definicio.size()%3 != 0) {
    if (!acabamentId) {
      wellformed = false;
    }
    
  }
  return wellformed;
}


void crearMuntanya(AST* node) { //acabades en identificador no es completen -> canvis


  vector <Component> definicio = preProces(node);

  bool incorrecte = correctesaDefinicio(definicio);

  bool acabamentId;
  
  if (!incorrecte) {
    wellformed = wellFormed(definicio,acabamentId); //aqui mira si és incomplet o no sabent que no falta res pel mig
    int altura = 0;
    if (wellformed)
      altura = height(definicio);
    Muntanya m = Muntanya(definicio,altura,wellformed);
    map <string,Muntanya>::iterator it = muntanyesDefinides.find(id);
    if (it == muntanyesDefinides.end())
      muntanyesDefinides.insert(make_pair(id,m));
    else
      it->second = m;
  }
  else 
    cout << "La muntanya és incompleta entre mig de la definició o la definició és errònia" << endl;
}


void creacioIs(AST* node) {

  string id = (child(node,0))->text;
  AST* fillDret = child(node,1);

  if (id[0] == "M") {
    if (fillDret->kind != "+" and fillDret->kind != "-" and fillDret->kind != "/" and fillDret->kind != "intconst"
      and (fillDret->kind != "*" or (fillDret->kind == "*" and child(fillDret,1)->kind != "intconst" and child(fillDret,1)->kind != "id" ))) {

      crearMuntanya(node,id);
    }

    else {
      cout << "La definicio de " + id + "no és correcte" << endl;
    }   
  }
  else {
    if (fillDret->kind == "+" or fillDret->kind == "-" or fillDret->kind == "/" or fillDret->kind == "intconst"
      or (fillDret->kind == "*" and child(fillDret,1)->kind == "intconst")) {

      map <string,int>::iterator it = variablesDefinides.find(id);
      int valor = evaluate(fillDret);
      if (it = variablesDefinides.end()) {
        variablesDefinides.insert(make_pair(it,valor));
      }
      else {
        it->second = valor;
      }
    }

    else {
      cout << "La definicio de " + id + "no és correcte" << endl;
    }
  }

}


// =================================================================


// ============== Draw =============================================

void draw(vector <Component> definicio, int altura) {


}

void draw(AST* node) {

  if (node->kind == "id") {

    map <string,Muntanya>::it = muntanyesDefinides.find(node->text);
    if (it != muntanyesDefinides.end()) {
      Muntanya m = it->second;
      if (wellformed) {
        draw(m.definicio,m.altura);
      }
      else {
        cout << "La muntanya " + node->text + " esta incompleta" << endl; 
      }
    }
    else {
      cout << "La muntanya " + node->text + " no existeix" << endl;
    }
  }

  else if (node->kind == "Peak") {

    Muntanya m = peak(node);
    draw(m.definicio,m.altura);
  }

  else if (node->kind == "Valley") {

    Muntanya m = valley(node);
    draw(m.definicio,m.altura);
  }

  else if (node->kind == ";") {

    vector <Component> definicio = preProces(node);
    bool correcte = correctesaDefinicio(definicio);
    if (correcte) {
      wellformed = wellFormed(definicio);
      if (wellformed) {
        altura = height(definicio);
        draw(definicio,altura);
      }
      else {
        cout << "La muntanya és incompleta pel final" << endl;
      }
    }
    else {
      cout << "La muntanya és incompleta per algun punt diferent del final" << endl;
    }
  }
}


// ===========================================================


void execute (AST* node) {

  if (node == NULL)
    return;

  else if (node->kind == "list")
    execute(node->down);

  else if (node->kind == "Draw") {
    AST* fill = node->down;
    draw(fill);
  }

  else if (node->kind == "Complete")
    retun; //funcio Complete


  else if (node->kind ==  "is") {
    creacioIs(node);
  }

  else if (node->kind == "if")
    if (evaluate(child(node,0)))
      execute(node->down);

  else if (node->kind ==  "while")
    while (evaluate(child(node,0)))
      execute(node->down);


  execute(node->right);

}


Muntanya peak(AST* node) {

  int unitatPujada = evaluate(child(node,0));
  int unitatCim = evaluate(child(node,1));
  int unitatBaixada = evaluate(child(node,2));

  vector <Component> peak;
  peak[0] = Component(unitatPujada,"/");
  peak[1] = Component(unitatCim,"-");
  peak[2] = Component(unitatBaixada,"\\");

  int altura = (unitatPujada > unitatBaixada) ? unitatPujada:unitatBaixada;
  Muntanya m = Muntanya(peak,true,altura);

  return m;
 
}

Muntanya valley(AST* node) {

  int unitatBaixada = evaluate(child(node,0));
  int unitatCim = evaluate(child(node,1));
  int unitatPujada = evaluate(child(node,2));

  vector <Component> valley;
  valley[0] = Component(unitatBaixada,"\\");
  valley[1] = Component(unitatCim,"-");
  valley[2] = Component(unitatPujada,"/");

  int altura = (unitatPujada > unitatBaixada) ? unitatPujada:unitatBaixada;
  Muntanya m = Muntanya(valley,true,altura);

  return m;
  
}



int main() {
  root = NULL;
  ANTLR(mountains(&root), stdin);
  ASTPrint(root);
  //execute(root);
  //imprimirArbres();
}
>>


#lexclass START
#token BAR "\/"
#token DOWN "\\"
#token HIPHEN "\-"
#token CONCAT "\;"
#token NUM "[0-9]+"
#token STAR "\*"
#token ALM "\#" //referencia a una muntanya existent
#token PLUS "\+"
#token COMMA "\,"
#token LPAR "\("
#token RPAR "\)"
#token IS "is"
#token ID "M[1-9]* | [a-zA-LN-Z]"
//#token VAR "[a-zA-LN-Z]"

#token GT ">"
#token LT "<"
#token EQ "=="

#token AND "AND"
#token OR "OR"
#token NOT "NOT"

#token PEAKFUNC "Peak"
#token VALLEYFUNC "Valley"
#token MATCHFUNC "Match"
#token HEIGHTFUNC "Height"
#token WELLFORMEDFUNC "Wellformed"
#token DRAWFUNC "Draw"
#token COMPLETEFUNC "Complete"

#token IF "if"
#token ENDIF "endif"
#token WHILE "while"
#token ENDWHILE "endwhile"

#token SPACE "[\ \t \n]" << zzskip(); >>


mountains: (inst)* << #0 = createASTlist(_sibling); >>;
inst: assign | condic | draw | iter | complete ;

assign: ID IS^ (defMountain | aritmethicExpr | ruleNum);

rule: NUM (STAR^ ( (BAR | DOWN | HIPHEN) (CONCAT^ (ALM! ID | createMountainFunction | symbol))* |
      term ((STAR^ | BAR^) term)* ((PLUS^ | MINUS^) aritmethicExpr2)*)
      | BAR^ term ((STAR^ | BAR^) term)* ((PLUS^ | MINUS^) aritmethicExpr2)* | ) ;
 
defMountain: (ALM! ID | createMountainFunction) (CONCAT^ (ALM! ID | createMountainFunction | symbol))*; 

symbol: NUM STAR^ (BAR | DOWN | HIPHEN);

createMountainFunction: (PEAKFUNC^ | VALLEYFUNC^) LPAR! (aritmethicExpr | rule) COMMA! (aritmethicExpr | rule) COMMA! (aritmethicExpr | rule) RPAR!;

//assignNumVariable: VAR IS^ aritmethicExpr ;

draw: DRAWFUNC^ LPAR! (defMountain | rule) RPAR! ; 

complete: COMPLETEFUNC^ LPAR! ID RPAR! ;

condic: IF^ LPAR! expBool RPAR! mountains ENDIF!;
iter: WHILE^ LPAR! expBool RPAR! mountains ENDWHILE!;

expBool: (NOT^ | ) termBoolOR ;
termBoolOR: termBoolAND (OR^ termBoolAND)* ;
termBoolAND: termBoolLessPrecedence (AND^ termBoolLessPrecedence)* ;
termBoolLessPrecedence: ((NUM | ID | height) (EQ^ | LT^ | GT^) (NUM | ID | height) | match | wellformed) ;

height: HEIGHTFUNC^ LPAR! (defMountain | rule) RPAR! ; 

match: MATCHFUNC^ LPAR! (defMountain | rule) COMMA! (defMountain | rule) RPAR! ; 

wellformed: WELLFORMEDFUNC^ LPAR! ID RPAR! ;

aritmethicExpr: aritmethicExpr2ID ((PLUS^ | MINUS^) aritmethicExpr2)* ;
aritmethicExpr2ID: ID ((STAR^ | BAR^) term)*;
aritmethicExpr2: term ((STAR^ | BAR^) term)*;
term: NUM | ID ; 

