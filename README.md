# Fractional Language Lexer & LALR Parser

A custom programming language front-end and expression evaluator written in C using Flex (lexical analyzer) and Bison (LALR parser).

## Features
- **Lexical Scanning (Flex)**: Tokenizes arithmetic operators, integer constants, and fraction literals (`a/b`).
- **Grammar & Precedence (Bison)**: Implements Context-Free Grammar (CFG) rules with explicit operator precedence to eliminate shift/reduce conflicts.
- **Arithmetic Evaluation**: Reduces arithmetic expressions involving mixed integer and fractional operands into simplest fractional forms.
- **Build Automation**: Includes a Unix `Makefile` targeting GCC.

## Project Structure
- `fraction.l`: Lexical analyzer specification and regex token definitions.
- `fraction.y`: Bison grammar definitions, precedence rules, and semantic actions.
- `fraction.h`: Core data structures and helper function signatures.
- `Makefile`: Compilation and linking pipeline.

## Build & Execution
Prerequisites: GCC, Flex, and Bison

```bash
make
./fraction_parser
