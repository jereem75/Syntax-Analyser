#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "option.h"
extern int afficheArbre;

int seTerminePar(char *chaine) {
    int longueurChaine = strlen(chaine);
    if (longueurChaine < 4) {
        return 0;
    }
    int res = strcmp(chaine + longueurChaine - 4, ".tpc");
    res += strcmp(chaine + longueurChaine - 4, ".TPC");
    if (res > 0)
        return 1;
    return 0;
}



int gestionTPC(char *fichier) {
    FILE *tpc = fopen(fichier, "r");
    if (tpc == NULL){
        fprintf(stderr, "Erreur: Fichier %s introuvable\n", fichier);
        return 2;
    }
    char *debut;
    if (afficheArbre == 1) 
        debut = "./bin/tpcas -t < ";
    else
        debut = "./bin/tpcas < ";
    int debutCommande = strlen(debut);
    int finCommande = strlen(fichier);
    char commande[debutCommande + finCommande];
    strcpy(commande, debut);
    strcat(commande, fichier);
    return system(commande);
}



int option(int argc, char *argv[]) {
    int i = 1;
    char *fichier = NULL;
    for (; i < argc; i++) {
        if (strcmp(argv[i], "-t") == 0 || strcmp(argv[i], "--tree") == 0) {
            afficheArbre = 1;
        }
        else if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
            FILE *help = fopen("src/help.md", "r");
            if (help == NULL){
                fprintf(stderr, "Erreur: Fichier \"help.md\" introuvable\n");
                return 2;
            }
            fclose(help);
            system("cat src/help.md");
        }
        else if (seTerminePar(argv[i])) {
            fichier = argv[i];
        }
        else {
            fprintf(stderr, "L'option %s n'existe pas\n", argv[i]);
            return 2;
        }
    }
    if (fichier != NULL) 
        return gestionTPC(fichier);
    return 3;
}