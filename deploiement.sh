#!/bin/bash
make clean > /dev/null
make > /dev/null

echo "######  RESULTATS  ######" > result.txt

res_juste=0
nb_test=0

for dossier in "test"/*
do
    for fichier in "$dossier"/*
    do
        nb_test=$((nb_test + 1))
        echo "Fichier: $fichier " >> result.txt
        ./bin/tpcas < $fichier >> result.txt 2>&1
        result=$?
        if [ $result -eq 0 ]
        then
            echo "Aucun problème " >> result.txt
            echo "" >> result.txt
            res_juste=$((res_juste + 1))
        else
            echo "" >> result.txt
        fi
    done
done

echo "#########################"
echo "######  RESULTATS  ######"
echo "#########################"
echo ""
echo "Nombre de testes: $nb_test"
echo "Nombre de testes reussis: $res_juste"
echo "Nombre de testes echoués: $(($nb_test-$res_juste))"
