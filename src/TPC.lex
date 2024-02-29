%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../obj/bison.h"
#include "../src/tree.h"
int lineno = 1;
int nochar = 1;
%}

%option nounput
%option noinput
%x COM

%%
[/][*] BEGIN COM;

\/\/.* nochar += yyleng;

<COM>\n   {lineno++; nochar = 1;}

<COM>(.|\t|\r) ;  

<COM>[*][/] BEGIN INITIAL;

\'(.|\\t|\\n|\\r)\' {
                  nochar += yyleng;
                  strcpy(yylval.charactere, yytext);
                  return CHARACTER;
                }

void {
        nochar += yyleng;
        return VOID;
     }

while {
        nochar += yyleng;
        return WHILE;
      }

if  {
      nochar += yyleng;
      return IF;
    }

else  {
        nochar += yyleng;
        return ELSE;
      }

return  {
          nochar += yyleng;
          return RETURN;
        }

&&  {
      nochar += yyleng;
      return AND;
    }

\|\|  {
        nochar += yyleng;
        return OR;
      }

\*|\/|%   {
            nochar += yyleng;
            yylval.byte = yytext[0];
            return DIVSTAR;
          }

\<|\>|\<\=|\>\=   {
                    nochar += yyleng;
                    strcpy(yylval.order, yytext);
                    return ORDER;
                  }

\+|\-   {
          nochar += yyleng;
          yylval.byte = yytext[0];
          return ADDSUB;
        }

==|!=   { 
          nochar += yyleng;
          strcpy(yylval.order, yytext);
          return EQ;
        }

int|char  {
            nochar += yyleng;
            strcpy(yylval.type, yytext);
            return TYPE;
          }

\( nochar += yyleng; return '(';

\) nochar += yyleng; return ')';

\{ nochar += yyleng; return '{';

\} nochar += yyleng; return '}';

\[ nochar += yyleng; return '[';

\] nochar += yyleng; return ']';

; nochar += yyleng; return ';';

! nochar += yyleng; return '!';

, nochar += yyleng; return ',';

= nochar += yyleng; return '=';

[a-zA-Z_][a-zA-Z0-9_]*  {
                          nochar += yyleng;
                          strcpy(yylval.ident, yytext);
                          return IDENT;
                        }

[0-9]+  {
          nochar += yyleng;
          yylval.num = atoi(yytext);
          return NUM;
        }

\n lineno++; nochar = 1;

[ \t\r\n] ;

. return yytext[0];



%%


