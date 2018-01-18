#ifndef tokens_h
#define tokens_h
/* tokens.h -- List of labelled tokens and stuff
 *
 * Generated from: examen16A.g
 *
 * Terence Parr, Will Cohen, and Hank Dietz: 1989-2001
 * Purdue University Electrical Engineering
 * ANTLR Version 1.33MR33
 */
#define zzEOF_TOKEN 1
#define NUM 2
#define GRID 3
#define ORIENT 4
#define MOVE 5
#define PLACE 6
#define FITS 7
#define HEIGHT 8
#define WHILE 9
#define AT 10
#define DEF 11
#define ENDEF 12
#define GT 13
#define LT 14
#define AND 15
#define LBR 16
#define RBR 17
#define LPAR 18
#define RPAR 19
#define COMMA 20
#define ASSIGN 21
#define ID 22
#define SPACE 23

#ifdef __USE_PROTOS
void game(AST**_root);
#else
extern void game();
#endif

#ifdef __USE_PROTOS
void grid(AST**_root);
#else
extern void grid();
#endif

#ifdef __USE_PROTOS
void linst(AST**_root);
#else
extern void linst();
#endif

#ifdef __USE_PROTOS
void assignExecute(AST**_root);
#else
extern void assignExecute();
#endif

#ifdef __USE_PROTOS
void move(AST**_root);
#else
extern void move();
#endif

#ifdef __USE_PROTOS
void iter(AST**_root);
#else
extern void iter();
#endif

#ifdef __USE_PROTOS
void condicBool(AST**_root);
#else
extern void condicBool();
#endif

#ifdef __USE_PROTOS
void condicBool2(AST**_root);
#else
extern void condicBool2();
#endif

#ifdef __USE_PROTOS
void fits(AST**_root);
#else
extern void fits();
#endif

#ifdef __USE_PROTOS
void terme(AST**_root);
#else
extern void terme();
#endif

#ifdef __USE_PROTOS
void coords(AST**_root);
#else
extern void coords();
#endif

#ifdef __USE_PROTOS
void defs(AST**_root);
#else
extern void defs();
#endif

#ifdef __USE_PROTOS
void def(AST**_root);
#else
extern void def();
#endif

#endif
extern SetWordType zzerr1[];
extern SetWordType zzerr2[];
extern SetWordType setwd1[];
extern SetWordType zzerr3[];
extern SetWordType zzerr4[];
extern SetWordType zzerr5[];
extern SetWordType zzerr6[];
extern SetWordType setwd2[];
