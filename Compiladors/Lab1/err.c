/*
 * A n t l r  S e t s / E r r o r  F i l e  H e a d e r
 *
 * Generated from: example1_3.g
 *
 * Terence Parr, Russell Quong, Will Cohen, and Hank Dietz: 1989-2001
 * Parr Research Corporation
 * with Purdue University Electrical Engineering
 * With AHPCRC, University of Minnesota
 * ANTLR Version 1.33MR33
 */

#define ANTLR_VERSION	13333
#include "pcctscfg.h"
#include "pccts_stdio.h"

#include <string>
#include <iostream>
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
#define zzSET_SIZE 4
#include "antlr.h"
#include "ast.h"
#include "tokens.h"
#include "dlgdef.h"
#include "err.h"

ANTLRChar *zztokens[24]={
	/* 00 */	"Invalid",
	/* 01 */	"@",
	/* 02 */	"NUM",
	/* 03 */	"PLUS",
	/* 04 */	"MINUS",
	/* 05 */	"TIMES",
	/* 06 */	"DIV",
	/* 07 */	"RPAR",
	/* 08 */	"LPAR",
	/* 09 */	"SPACE",
	/* 10 */	"WRITE",
	/* 11 */	"ID",
	/* 12 */	"ASIG",
	/* 13 */	"WHILE",
	/* 14 */	"DO",
	/* 15 */	"ENDWHILE",
	/* 16 */	"IF",
	/* 17 */	"THEN",
	/* 18 */	"ENDIF",
	/* 19 */	"GT",
	/* 20 */	"LT",
	/* 21 */	"EQ",
	/* 22 */	"GET",
	/* 23 */	"LET"
};
SetWordType zzerr1[4] = {0x0,0x2c,0x1,0x0};
SetWordType zzerr2[4] = {0x0,0x0,0xf8,0x0};
SetWordType zzerr3[4] = {0x18,0x0,0x0,0x0};
SetWordType setwd1[24] = {0x0,0x92,0x0,0x40,0x40,0x0,0x0,
	0x80,0x0,0x0,0x9d,0x9d,0x0,0x9d,0xa0,
	0x90,0x9d,0xa0,0x90,0x80,0x80,0x80,0x80,
	0x80};
SetWordType zzerr4[4] = {0x60,0x0,0x0,0x0};
SetWordType zzerr5[4] = {0x4,0x9,0x0,0x0};
SetWordType setwd2[24] = {0x0,0x6,0x0,0x6,0x6,0x5,0x5,
	0x6,0x0,0x0,0x6,0x6,0x0,0x6,0x6,
	0x6,0x6,0x6,0x6,0x6,0x6,0x6,0x6,
	0x6};
