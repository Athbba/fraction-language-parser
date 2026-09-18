%{
#include "fraction.h"
#include "fraction.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

%option noyywrap

%%

[0-9]+\/[0-9]+  {
                    /* Fraction literal: e.g. 3/4 */
                    sscanf(yytext, "%d/%d", &yylval.frac.num, &yylval.frac.den);
                    return FRAC;
                }

[0-9]+          {
                    /* Bare integer — not valid in this language */
                    yylval.ival = atoi(yytext);
                    return NUM;
                }

"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
"("             { return '('; }
")"             { return ')'; }

\n              { return '\n'; }
[ \t\r]         { /* skip whitespace */ }

.               {
                    fprintf(stderr, "Error: unknown character '%s'\n", yytext);
                }

%%
