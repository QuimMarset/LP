/*
 * A n t l r  S e t s / E r r o r  F i l e  H e a d e r
 *
 * Generated from: examen16A.g
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
	/* 03 */	"GRID",
	/* 04 */	"ORIENT",
	/* 05 */	"MOVE",
	/* 06 */	"PLACE",
	/* 07 */	"FITS",
	/* 08 */	"HEIGHT",
	/* 09 */	"WHILE",
	/* 10 */	"AT",
	/* 11 */	"DEF",
	/* 12 */	"ENDEF",
	/* 13 */	"GT",
	/* 14 */	"LT",
	/* 15 */	"AND",
	/* 16 */	"LBR",
	/* 17 */	"RBR",
	/* 18 */	"LPAR",
	/* 19 */	"RPAR",
	/* 20 */	"COMMA",
	/* 21 */	"ASSIGN",
	/* 22 */	"ID",
	/* 23 */	"SPACE"
};
SetWordType zzerr1[4] = {0x0,0x0,0x44,0x0};
SetWordType zzerr2[4] = {0x22,0x1a,0x62,0x0};
SetWordType setwd1[24] = {0x0,0xfb,0x0,0x0,0x0,0xf6,0x0,
	0x0,0x0,0xf6,0x0,0xfa,0xf8,0x0,0x0,
	0x0,0x0,0xf8,0x0,0x0,0x0,0x0,0xf6,
	0x0};
SetWordType zzerr3[4] = {0x0,0x60,0x0,0x0};
SetWordType zzerr4[4] = {0x84,0x1,0x0,0x0};
SetWordType zzerr5[4] = {0x4,0x1,0x0,0x0};
SetWordType zzerr6[4] = {0x0,0x0,0x18,0x0};
SetWordType setwd2[24] = {0x0,0xc0,0x2,0x0,0x0,0x0,0x0,
	0x0,0x2,0x0,0x0,0x80,0x0,0x10,0x10,
	0x1c,0x0,0x0,0x0,0x3d,0x0,0x0,0x0,
	0x0};
