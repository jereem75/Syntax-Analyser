/* tree.c */
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include "tree.h"
extern int lineno;       /* from lexer */

static const char *StringFromLabel[] = {
  "Prog",                 
  "DeclVars",        
  "Declarateurs",           
  "DeclFoncts",     
  "DeclFonct",            
  "EnTeteFonct",          
  "Parametres",                
  "ListTypVar",           
  "Corps",         
  "SuiteInstr", 
  "Instr",          
  "Exp",                   
  "Arguments",
  "ListExp",
  "if",
  "else",
  "while",
  "return",
  "or",
  "and",
  "void",
  "=",
  "Tab",
  "!"
  /* list all other node labels, if any */
  /* The list must coincide with the label_t enum in tree.h */
  /* To avoid listing them twice, see https://stackoverflow.com/a/10966395 */
};

Node *makeNode(label_t label) {
  Node *node = malloc(sizeof(Node));
  if (!node) {
    printf("Run out of memory\n");
    exit(2);
  }
  node->label = label;
  node-> firstChild = node->nextSibling = NULL;
  node->lineno=lineno;
  return node;
}

void addSibling(Node *node, Node *sibling) {
  Node *curr = node;
  while (curr->nextSibling != NULL) {
    curr = curr->nextSibling;
  }
  curr->nextSibling = sibling;
}

void addChild(Node *parent, Node *child) {
  if (parent->firstChild == NULL) {
    parent->firstChild = child;
  }
  else {
    addSibling(parent->firstChild, child);
  }
}

void deleteTree(Node *node) {
  if (node->firstChild) {
    deleteTree(node->firstChild);
  }
  if (node->nextSibling) {
    deleteTree(node->nextSibling);
  }
  free(node);
}

int print_special(Node node) {
  switch (node.label)
  {
  case Ident:
    printf("IDENT: %s", node.type_elem.ident);
    return 1;
    break;
  case Char:
    printf("char: %s", node.type_elem.charactere);
    return 1;
    break;
  case Type:
    printf("TYPE: %s", node.type_elem.type);
    return 1;
    break;
  case Order:
    printf("%s", node.type_elem.order);
    return 1;
    break;
  case BYte:
    printf("%c", node.type_elem.byte);
    return 1;
    break;
  case Num:
    printf("NUM: %d", node.type_elem.num);
    return 1;
    break;
  default:
    return 0;
    break;
  }
  return 0;
}

void printTree(Node *node) {
  static bool rightmost[128]; // tells if node is rightmost sibling
  static int depth = 0;       // depth of current node
  for (int i = 1; i < depth; i++) { // 2502 = vertical line
    printf(rightmost[i] ? "    " : "\u2502   ");
  }
  if (depth > 0) { // 2514 = L form; 2500 = horizontal line; 251c = vertical line and right horiz 
    printf(rightmost[depth] ? "\u2514\u2500\u2500 " : "\u251c\u2500\u2500 ");
  }
  if (!print_special(*node)) {
    printf("%s", StringFromLabel[node->label]);
  }
  printf("\n");
  depth++;
  for (Node *child = node->firstChild; child != NULL; child = child->nextSibling) {
    rightmost[depth] = (child->nextSibling) ? false : true;
    printTree(child);
  }
  depth--;
}
