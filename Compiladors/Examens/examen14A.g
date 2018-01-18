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
  ANTLR(roomba(&root), stdin);
  ASTPrint(root);
}
>>


#lexclass START
#token POSITION "position"
#token STARTC "startcleaning"
#token DIREC "up | down | right | left"
#token MOVE "move"
#token EXECUTE "exec"
#token FLUSH "flush"
#token IF "if"
#token SENSORPROX "sensorprox"
#token SENSORLIGHT "sensorlight"
#token ON "ON"
#token OFF "OFF"
#token AND "AND"
#token OR "OR"
#token THEN "then"
#token EQ "=="
#token GT ">"
#token TASK "TASK"
#token ENDTASK "ENDTASK"
#token ENDC "endcleaning"
#token OPS "ops"
#token COMMA ","
#token LBR "\["
#token RBR "\]"
#token NUM "[0-9]*"
#token ID "t[1-9][0-9]*"
#token SPACE "[\ \t \n]" << zzskip(); >>

roomba: position STARTC! linst ENDC! tasks <<#0 = createASTlist(_sibling); >>;

position: POSITION^ NUM NUM ;
linst: (inst)* << #0 = createASTlist(_sibling); >> ;
inst: move | exec | ops | flush | condic ;
tasks: (task)* << #0 = createASTlist(_sibling); >> ;

move: MOVE^ DIREC NUM ;
exec: EXECUTE^ ID ;
condic: IF^ exprBool THEN! inst ;
exprBool: exprBoolAnd (OR^ exprBoolAnd)*;
exprBoolAnd: exprBoolRel (AND^ exprBoolRel)* ;
exprBoolRel: SENSORPROX EQ^ (ON | OFF) | SENSORLIGHT (EQ^ | GT^) NUM ;

flush: FLUSH^ NUM;
ops: OPS^ LBR! inst (COMMA! inst)* RBR! ;
task: TASK^ ID linst ENDTASK! ;
