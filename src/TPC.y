%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../obj/bison.h"
#include "../src/tree.h"
#include "../src/option.h"

int afficheArbre = 0;
int yylex();
extern int lineno;
extern int nochar;
void yyerror(const char *msg) {
    fprintf(stderr, "%s at line %d, char number %d\n", msg, lineno, nochar);
}
    
    
%}

%define parse.error verbose

%union {
struct Node *node;
char ident[64];
char type[5];
char order[3];
char charactere[4];
char byte;
int num;
}

%type <node> Prog DeclVars Declarateurs DeclFoncts DeclFonct EnTeteFonct Parametres After_Decla After_Lvalue
%type <node> ListTypVar Corps SuiteInstr Instr Exp TB FB M E T F LValue Arguments ListExp After_List


%token <type> TYPE
%token <ident> IDENT
%token VOID
%token IF
%token ELSE
%token WHILE
%token RETURN
%token OR
%token AND
%token <order> ORDER EQ
%token <byte> ADDSUB DIVSTAR 
%token <charactere> CHARACTER
%token <num> NUM
%right THEN ELSE


%%
Prog:  
        DeclVars DeclFoncts
        {
            $$ = makeNode(Prog);
            addChild($$, $1);
            addSibling($1, $2);
            if (afficheArbre == 1)
                printTree($$);
            deleteTree($$);
        }
    ;
DeclVars:
        DeclVars TYPE Declarateurs ';'
        {
            Node *new_type = makeNode(Type);
            strcpy(new_type->type_elem.type, $2);
            addChild($1, new_type);
            addChild(new_type, $3);
        }
    |  
        {
            $$ = makeNode(DeclVars);
        }
    ;
Declarateurs:
        Declarateurs ',' IDENT After_Decla
        {
            Node *new_ident = makeNode(Ident);
            strcpy(new_ident->type_elem.ident, $3);
            if( $4 != NULL) {
                Node *tab = makeNode(Tab);
                addChild(tab, new_ident);
                addSibling(new_ident, $4);
                addSibling($1, tab);
            }
            else
                addSibling($1, new_ident);
        }
    |   IDENT After_Decla
        {
            $$ = makeNode(Ident);
            strcpy($$->type_elem.ident, $1);
            if($2 != NULL) 
                addChild($$, $2);
        }
    ;
After_Decla:
        '['NUM']'
        {
            $$ = makeNode(Num);
            $$->type_elem.num = $2;
        }
    |
        {
            $$ = NULL;
        }
    ;
DeclFoncts:
        DeclFoncts DeclFonct
        {
            $$ = $1;
            addChild($$, $2);
        }
    |   DeclFonct
        {
            $$ = makeNode(DeclFoncts);
            addChild($$, $1);
        }
    ;
DeclFonct:
        EnTeteFonct Corps
        {
            $$ = makeNode(DeclFonct);
            addChild($$, $1);
            addSibling($1, $2);
        }
    ;
EnTeteFonct:
        TYPE IDENT '(' Parametres ')'
        {
            $$ = makeNode(EnTeteFonct);
            Node *type = makeNode(Type);
            strcpy(type->type_elem.type, $1);
            Node *ident = makeNode(Ident);
            strcpy(ident->type_elem.ident, $2);
            addSibling(type, ident);
            addChild($$, type);
            addSibling(ident, $4);
        }
    |   VOID IDENT '(' Parametres ')'
        {
            $$ = makeNode(EnTeteFonct);
            Node *type = makeNode(Void);
            Node *ident = makeNode(Ident);
            strcpy(ident->type_elem.ident, $2);
            addSibling(type, ident);
            addChild($$, type);
            addSibling(ident, $4);
        }
    ;
Parametres:
        VOID
        {
            $$ = makeNode(Parametres);
            Node* aucun = makeNode(Void);
            addChild($$, aucun);
        }
    |   ListTypVar
        {
            $$ = makeNode(Parametres);
            addChild($$, $1);
        }
    ;
ListTypVar:
        ListTypVar ',' TYPE IDENT After_List
        {
            Node *type = makeNode(Type);
            strcpy(type->type_elem.type, $3);
            Node *ident = makeNode(Ident);
            strcpy(ident->type_elem.ident, $4);
            if($5 != NULL) {
                addChild($5, ident);
                addChild(type, $5);
            }
            else
                addChild(type, ident);
            addSibling($1, type);

        }
    |   TYPE IDENT After_List
        {
            $$ = makeNode(Type);
            strcpy($$->type_elem.type, $1);
            Node *ident = makeNode(Ident);
            strcpy(ident->type_elem.ident, $2);
            if ($3 != NULL)
                addChild(ident, $3);
            addChild($$, ident);
        }
    ;
After_List:
        '['']'
        {
            $$ = makeNode(Tab);
        }
    |
        {
            $$ = NULL;
        }
    ;
Corps: 
        '{' DeclVars SuiteInstr '}'
        {
            $$ = makeNode(Corps);
            addChild($$, $2);
            addSibling($2, $3);
        }
    ;
SuiteInstr:
        SuiteInstr Instr
        {
            $$ = $1;
            addChild($$, $2);
        }
    |   
        {
            $$ = makeNode(SuiteInstr);
        }
    ;
Instr:
        LValue '=' Exp ';'
        {
            $$ = makeNode(Equal);
            addChild($$, $1);
            addSibling($1, $3);
        }
    |   IF '(' Exp ')' Instr %prec THEN
        {
            $$ = makeNode(If);
            addChild($$, $3);
            addSibling($3, $5);
        }
    |   IF '(' Exp ')' Instr ELSE Instr
        {
            $$ = makeNode(If);
            addChild($$, $3);
            addSibling($3, $5);
            addSibling($5, $7);
        }
    |   WHILE '(' Exp ')' Instr
        {
            $$ = makeNode(While);
            addChild($$, $3);
            addSibling($3, $5);
        }
    |   IDENT '(' Arguments  ')' ';'
        {
            $$ = makeNode(Ident);
            strcpy($$->type_elem.ident, $1);
            addChild($$, $3);
        }
    |   RETURN Exp ';'
        {
            $$ = makeNode(Return);
            addChild($$, $2);
        }
    |   RETURN ';'
        {
            $$ = makeNode(Return);
        }
    |   '{' SuiteInstr '}'
        {
            $$ = $2;
        }
    |   ';'
        {
            $$ = NULL;
        }
    ;
Exp :  
        Exp OR TB
        {
            $$ = makeNode(Or);
            addChild($$, $1);
            addSibling($1, $3);
        }
    |   TB
        {
            $$ = $1;
        }
    ;
TB  :  
        TB AND FB
        {
            $$ = makeNode(And);
            addChild($$, $1);
            addSibling($1, $3);
        }
    |   FB
        {
            $$ = $1;
        }
    ;
FB  :  
        FB EQ M
        {
            $$ = makeNode(Order);
            strcpy($$->type_elem.order, $2);
            addChild($$, $1);
            addSibling($1, $3);
        }
    |   M
        {
            $$ = $1;
        }
    ;
M   :  
        M ORDER E
        {
            $$ = makeNode(Order);
            strcpy($$->type_elem.order, $2);
            addChild($$, $1);
            addSibling($1, $3);
        }
    |   E
        {
            $$ = $1;
        }
    ;
E   :  
        E ADDSUB T
        {
            $$ = makeNode(BYte);
            $$->type_elem.byte = $2;
            addChild($$, $1);
            addSibling($1, $3);
        }
    |   T
        {
            $$ = $1;
        }
    ;    
T   :  
        T DIVSTAR F 
        {
            $$ = makeNode(BYte);
            $$->type_elem.byte = $2;
            addChild($$, $1);
            addSibling($1, $3);
        }
    |   F 
        {
            $$ = $1;
        }
    ;
F   :  
        ADDSUB F
        {
            $$ = makeNode(Order);
            $$->type_elem.byte = $1;
            addChild($$, $2);
        }
    |   '!' F
        {
            $$ = makeNode(Not);
            addChild($$, $2);
        }
    |   '(' Exp ')'
        {
            $$ = $2;
        }
    |   NUM
        {
            $$ = makeNode(Num);
            $$->type_elem.num = $1;
        }
    |   CHARACTER
        {
            $$ = makeNode(Char);
            strcpy($$->type_elem.charactere, $1);
        }
    |   LValue
        {
            $$ = $1;
        }
    |   IDENT '(' Arguments  ')'
        {
            $$ = makeNode(Ident);
            strcpy($$->type_elem.ident, $1);
            addChild($$, $3);
        }
    ;
LValue:
        IDENT After_Lvalue
        {
            Node *ident = makeNode(Ident);
            strcpy(ident->type_elem.ident, $1);
            if ($2 != NULL) {
                Node *tab = makeNode(Tab);
                addChild(tab, ident);
                addSibling(ident, $2);
                $$ = tab;
            }
            else
                $$ = ident;
        }
    ;
After_Lvalue:
        '['Exp']'
        {
            $$ = $2;
        }
    |
        {
            $$ = NULL;
        }
    ;
Arguments:
        ListExp
        {
            $$ = makeNode(Arguments);
            addChild($$, $1);
        }
    |
        {
            $$ = makeNode(Arguments);
            addChild($$, makeNode(Void));
        }
    ;
ListExp:
        ListExp ',' Exp
        {
            addSibling($1, $3);
        }
    |   Exp
        {
            $$ = $1; 
        }
    ;
%%

int main(int argc, char *argv[]) {
    if (argc > 1) {
        int arguments = option(argc, argv);
        if (arguments != 3)
            return arguments;
    }
    return yyparse();
}