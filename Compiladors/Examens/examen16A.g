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
  ANTLR(game(&root), stdin);
  ASTPrint(root);
}
>>


#lexclass START
#token NUM "[0-9]+"
#token GRID "Grid"
#token ORIENT "NORTH | SOUTH | EAST | WEST"
#token MOVE "MOVE"
#token PLACE "PLACE"
#token FITS "FITS"
#token HEIGHT "HEIGHT"
#token WHILE "WHILE"
#token AT "AT"
#token DEF "DEF"
#token ENDEF "ENDEF"
#token GT ">"
#token LT "<"
#token AND "AND"
#token LBR "\["
#token RBR "\]"
#token LPAR "\("
#token RPAR "\)"
#token COMMA ","
#token ASSIGN "="
#token ID "B[1-9]* | [A-CD-Z][A-Z0-9]*"

#token SPACE "[\ \t \n]" << zzskip(); >>


game: grid linst defs << #0 = createASTlist(_sibling); >> ;
grid: GRID^ NUM NUM ;
linst: (assignExecute | move | iter)* << #0 = createASTlist(_sibling); >> ;
assignExecute: ID ( | ASSIGN! PLACE^ LPAR! coords RPAR! AT! (ID | LPAR! coords RPAR!) );
move: MOVE^ ID ORIENT NUM ;
iter: WHILE^ LPAR! condicBool RPAR! LBR! linst RBR! ;
condicBool: condicBool2 (AND^ condicBool2)* ;
condicBool2: fits | terme (GT^ | LT^) terme ;
fits: FITS^ LPAR! ID COMMA! coords RPAR! ;
terme: NUM | HEIGHT^ LPAR! ID RPAR! ;
coords: NUM COMMA! NUM ( | COMMA! NUM) << #0 = createASTlist(_sibling); >> ;
defs: (def)* << #0 = createASTlist(_sibling); >> ;
def: DEF^ ID linst ENDEF! ;
