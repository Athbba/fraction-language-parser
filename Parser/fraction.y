%{
#include "fraction.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ── Helpers ── */
int gcd(int a, int b) {
    if (a < 0) a = -a;
    if (b < 0) b = -b;
    while (b) { int t = b; b = a % b; a = t; }
    return a == 0 ? 1 : a;
}

Fraction simplify(Fraction f) {
    int g = gcd(f.num < 0 ? -f.num : f.num,
                f.den < 0 ? -f.den : f.den);
    f.num /= g;
    f.den /= g;
    /* keep denominator positive */
    if (f.den < 0) { f.num = -f.num; f.den = -f.den; }
    return f;
}

Fraction add_frac(Fraction a, Fraction b) {
    Fraction r;
    r.num = a.num * b.den + b.num * a.den;
    r.den = a.den * b.den;
    return simplify(r);
}

Fraction sub_frac(Fraction a, Fraction b) {
    Fraction r;
    r.num = a.num * b.den - b.num * a.den;
    r.den = a.den * b.den;
    return simplify(r);
}

Fraction mul_frac(Fraction a, Fraction b) {
    Fraction r;
    r.num = a.num * b.num;
    r.den = a.den * b.den;
    return simplify(r);
}

Fraction div_frac(Fraction a, Fraction b) {
    Fraction r;
    r.num = a.num * b.den;
    r.den = a.den * b.num;
    return simplify(r);
}

void print_fraction(Fraction f) {
    if (f.den == 1)
        printf("Result: %d\n", f.num);
    else
        printf("Result: %d/%d\n", f.num, f.den);
}

/* forward declarations */
void yyerror(const char *s);
int  yylex(void);
%}

/* ── Value types ── */
%union {
    Fraction frac;
    int      ival;
}

%token <frac> FRAC
%token <ival> NUM

%type <frac> expr term factor

/* Standard left-associativity */
%left '+' '-'
%left '*' '/'

%%

program
    : expr '\n'     { print_fraction($1); }
    | expr          { print_fraction($1); }
    ;

expr
    : expr '+' term { $$ = add_frac($1, $3); }
    | expr '-' term { $$ = sub_frac($1, $3); }
    | term          { $$ = $1; }
    ;

term
    : term '*' factor { $$ = mul_frac($1, $3); }
    | term '/' factor {
                          if ($3.num == 0) {
                              yyerror("Error: division by zero");
                              YYERROR;
                          }
                          $$ = div_frac($1, $3);
                      }
    | factor          { $$ = $1; }
    ;

factor
    : '(' expr ')'  { $$ = $2; }
    | FRAC          {
                        if ($1.den == 0) {
                            yyerror("Error: fraction denominator cannot be zero");
                            YYERROR;
                        }
                        $$ = $1;
                    }
    | NUM           {
                        char msg[128];
                        sprintf(msg,
                            "Error: '%d' is not a valid fraction -- "
                            "use the form numerator/denominator (e.g. %d/1)",
                            $1, $1);
                        yyerror(msg);
                        YYERROR;
                    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    printf("Fraction Expression Evaluator\n");
    printf("Enter an expression (e.g. 1/5 * (2/11 + 5/3)):\n");
    fflush(stdout);
    int result = yyparse();
    if (result != 0)
        fprintf(stderr, "Parsing failed.\n");
    return result;
}
