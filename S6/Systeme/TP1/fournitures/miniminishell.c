#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    
    char buf[30] ; /* contient la commande saisie au clavier */
    int ret ; /* valeur de retour de scanf */
    ret = scanf ("%s", buf) ; /* lit et range dans buf la chaine entrée au clavier */
}
