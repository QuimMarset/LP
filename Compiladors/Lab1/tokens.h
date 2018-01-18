#ifndef tokens_h
#define tokens_h
/* tokens.h -- List of labelled tokens and stuff
 *
 * Generated from: example1_3.g
 *
 * Terence Parr, Will Cohen, and Hank Dietz: 1989-2001
 * Purdue University Electrical Engineering
 * ANTLR Version 1.33MR33
 */
#define zzEOF_TOKEN 1
#define NUM 2
#define PLUS 3
#define MINUS 4
#define TIMES 5
#define DIV 6
#define RPAR 7
#define LPAR 8
#define SPACE 9
#define WRITE 10
#define ID 11
#define ASIG 12
#define WHILE 13
#define DO 14
#define ENDWHILE 15
#define IF 16
#define THEN 17
#define ENDIF 18
#define GT 19
#define LT 20
#define EQ 21
#define GET 22
#define LET 23

#ifdef __USE_PROTOS
void program(AST**_root);
#else
extern void program();
#endif

#ifdef __USE_PROTOS
void instruction(AST**_root);
#else
extern void instruction();
#endif

#ifdef __USE_PROTOS
void expB(AST**_root);
#else
extern void expB();
#endif

#ifdef __USE_PROTOS
void expr(AST**_root);
#else
extern void expr();
#endif

#ifdef __USE_PROTOS
void term(AST**_root);
#else
extern void term();
#endif

#ifdef __USE_PROTOS
void exprP(AST**_root);
#else
extern void exprP();
#endif

#endif
extern SetWordType zzerr1[];
extern SetWordType zzerr2[];
extern SetWordType zzerr3[];
extern SetWordType setwd1[];
extern SetWordType zzerr4[];
extern SetWordType zzerr5[];
extern SetWordType setwd2[];
