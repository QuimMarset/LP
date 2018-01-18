#ifndef tokens_h
#define tokens_h
/* tokens.h -- List of labelled tokens and stuff
 *
 * Generated from: mountains.g
 *
 * Terence Parr, Will Cohen, and Hank Dietz: 1989-2001
 * Purdue University Electrical Engineering
 * ANTLR Version 1.33MR33
 */
#define zzEOF_TOKEN 1
#define BAR 2
#define DOWN 3
#define HIPHEN 4
#define CONCAT 5
#define NUM 6
#define STAR 7
#define REF 8
#define PLUS 9
#define COMMA 10
#define LPAR 11
#define RPAR 12
#define IS 13
#define AND 14
#define OR 15
#define NOT 16
#define CREATEFUNC 17
#define MATCHFUNC 18
#define HEIGHTFUNC 19
#define WELLFORMEDFUNC 20
#define DRAWFUNC 21
#define COMPLETEFUNC 22
#define IF 23
#define ENDIF 24
#define WHILE 25
#define ENDWHILE 26
#define ID 27
#define GT 28
#define LT 29
#define EQ 30
#define SPACE 31

#ifdef __USE_PROTOS
void mountains(AST**_root);
#else
extern void mountains();
#endif

#ifdef __USE_PROTOS
void inst(AST**_root);
#else
extern void inst();
#endif

#ifdef __USE_PROTOS
void assign(AST**_root);
#else
extern void assign();
#endif

#ifdef __USE_PROTOS
void assignedValue(AST**_root);
#else
extern void assignedValue();
#endif

#ifdef __USE_PROTOS
void part(AST**_root);
#else
extern void part();
#endif

#ifdef __USE_PROTOS
void plusMinusOp(AST**_root);
#else
extern void plusMinusOp();
#endif

#ifdef __USE_PROTOS
void productDivOp(AST**_root);
#else
extern void productDivOp();
#endif

#ifdef __USE_PROTOS
void operand(AST**_root);
#else
extern void operand();
#endif

#ifdef __USE_PROTOS
void symbol(AST**_root);
#else
extern void symbol();
#endif

#ifdef __USE_PROTOS
void peakOrValley(AST**_root);
#else
extern void peakOrValley();
#endif

#ifdef __USE_PROTOS
void condic(AST**_root);
#else
extern void condic();
#endif

#ifdef __USE_PROTOS
void iter(AST**_root);
#else
extern void iter();
#endif

#ifdef __USE_PROTOS
void expBool(AST**_root);
#else
extern void expBool();
#endif

#ifdef __USE_PROTOS
void termBoolOR(AST**_root);
#else
extern void termBoolOR();
#endif

#ifdef __USE_PROTOS
void termBoolAND(AST**_root);
#else
extern void termBoolAND();
#endif

#ifdef __USE_PROTOS
void termBoolLessPrecedence(AST**_root);
#else
extern void termBoolLessPrecedence();
#endif

#ifdef __USE_PROTOS
void relationTerm(AST**_root);
#else
extern void relationTerm();
#endif

#ifdef __USE_PROTOS
void draw(AST**_root);
#else
extern void draw();
#endif

#ifdef __USE_PROTOS
void complete(AST**_root);
#else
extern void complete();
#endif

#ifdef __USE_PROTOS
void height(AST**_root);
#else
extern void height();
#endif

#ifdef __USE_PROTOS
void match(AST**_root);
#else
extern void match();
#endif

#ifdef __USE_PROTOS
void wellformed(AST**_root);
#else
extern void wellformed();
#endif

#endif
extern SetWordType zzerr1[];
extern SetWordType zzerr2[];
extern SetWordType zzerr3[];
extern SetWordType setwd1[];
extern SetWordType zzerr4[];
extern SetWordType zzerr5[];
extern SetWordType zzerr6[];
extern SetWordType zzerr7[];
extern SetWordType setwd2[];
extern SetWordType zzerr8[];
extern SetWordType zzerr9[];
extern SetWordType zzerr10[];
extern SetWordType zzerr11[];
extern SetWordType setwd3[];
extern SetWordType setwd4[];
