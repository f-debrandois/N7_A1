#include "main.h"

bool init_main(t_main* la_main, int N){
    assert(N <= (NB_CARTES-1)/2);
    la_main->main = malloc(N*sizeof(carte));
    la_main->nb = N;
    return (la_main==NULL); //allocation réussie ?
}

void afficher_main(t_main la_main){
    for (int k=0; k<la_main.nb; k++){
        afficher_carte(la_main.main[k]);
    }
    printf("\n");
}
