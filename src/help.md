# Description:
tpcas est un analyseur lexical et syntaxique qui permet de reconnaitre ou d'indiquer les erreurs d'un code écris en tpc.

# Mode d'emploi:
pour lancer le programme, vous devez procéder ainsi:
./tpcas [OPTIONS] FILE.tpc [OPTIONS]

OPTIONS:
    -t ou --tree: Active l'affichage de l'arbre abstrait.
    -h ou --help: Affiche une description de l’interface utilisateur et termine l’exécution

FILE.tpc ou FILE.TPC:
    Chemin vers le fichier contenant le code à analyser.

Si vous ne spécifiez pas de FILE en entrée, vous pourrez écrire votre programme directement dans le terminal. Une fois la saisie terminée, appuyez sur CTRL+D pour finaliser la saisie et lancer l'analyse du programme.
