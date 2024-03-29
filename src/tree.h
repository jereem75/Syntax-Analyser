/* tree.h */

typedef enum {
  Prog,                 
  DeclVars,        
  Declarateurs,           
  DeclFoncts,     
  DeclFonct,            
  EnTeteFonct,          
  Parametres,                
  ListTypVar,           
  Corps,         
  SuiteInstr, 
  Instr,          
  Exp,                   
  Arguments,
  ListExp,
  If,
  Else,
  While,
  Return,
  Or,
  And,
  Void,
  Equal,
  Tab,
  Not,
  Ident,
  Type,
  Order,
  BYte,
  Num,
  Char
  /* list all other node labels, if any */
  /* The list must coincide with the string array in tree.c */
  /* To avoid listing them twice, see https://stackoverflow.com/a/10966395 */
} label_t;

union u {
  char ident[64];
  char type[5];
  char order[3];
  char charactere[4];
  char byte;
  int num;
};

typedef struct Node {
  label_t label;
  union u type_elem;
  struct Node *firstChild, *nextSibling;
  int lineno;
} Node;

Node *makeNode(label_t label);
void addSibling(Node *node, Node *sibling);
void addChild(Node *parent, Node *child);
void deleteTree(Node*node);
void printTree(Node *node);

#define FIRSTCHILD(node) node->firstChild
#define SECONDCHILD(node) node->firstChild->nextSibling
#define THIRDCHILD(node) node->firstChild->nextSibling->nextSibling
