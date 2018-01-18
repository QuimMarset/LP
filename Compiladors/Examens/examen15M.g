#header
<<
#include <string>
#include <iostream>
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
>>

<<
#include <cstdlib>
#include <cmath>

//global structures
AST *root;


// function to fill token information
void zzcr_attr(Attrib *attr, int type, char *text) {
   if (type == ID) {
     attr->kind = "id";
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


int main() {
  root = NULL;
  ANTLR(karel(&root), stdin);
  ASTPrint(root);
}
>>


#lexclass START
#token NUM "[0-9]+"
#token ORIENT "up | down | right | left"
#token WORLD "world"
#token ROBOT "robot"
#token WALLS "walls"
#token BEEPERS "beepers"
#token DEFINE "define"
#token IF "if"
#token ITERATE "iterate"
#token AND "and"
#token OR "or"
#token NOT "not"
#token BEGIN "begin"
#token END "end"
#token INSTREXEC "move | turnleft | pickbeeper | putbeeper | turnoff"
#token INSTRCOND "isClear | anyBeepersInBag | foundBeeper"
#token LBR "\["
#token RBR "\]"
#token SEMI ";"
#token LKEY "\{"
#token RKEY "\}"
#token COMMA ","
#token ID "[a-zA-Z0-9]+"

#token SPACE "[\ \t \n]" << zzskip(); >>

karel: worldDef robotDef wallsBeepsFunctDef linstbe << #0 = createASTlist(_sibling); >> ;
worldDef: WORLD^ NUM NUM ;
robotDef: ROBOT^ NUM NUM NUM ORIENT ;
wallsBeepsFunctDef: (walls | beeps)* (defFunction)* << #0 = createASTlist(_sibling); >> ;
walls: WALLS^ LBR! NUM NUM ORIENT (COMMA! NUM NUM ORIENT)* RBR! ;
beeps: BEEPERS^ NUM NUM NUM ;
linstbe: BEGIN! linst END! ;
linst: (condic | iterate | (ID | INSTREXEC) SEMI!)* << #0 = createASTlist(_sibling); >> ;
condic: IF^ exprBool LKEY! linst RKEY! ;
iterate: ITERATE^ NUM LKEY! linst RKEY! ;
exprBool: (NOT | ) exprBoolAndOr ;
exprBoolAndOr: INSTRCOND ((AND^ | OR^) INSTRCOND)*;
defFunction: DEFINE^ ID LKEY! linst RKEY! ;