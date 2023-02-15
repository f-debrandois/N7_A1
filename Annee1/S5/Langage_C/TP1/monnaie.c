#include <stdlib.h> 
#include <stdio.h>
#include <assert.h>
#include <stdbool.h>

#define nb_monnaie 5

// Definition du type monnaie
// TODO 

struct monnaie {
    int valeur;
    char devise;
};
typedef struct monnaie monnaie;

/**
 * \brief Initialiser une monnaie 
 * \param[out] m : monnaie à initialiser
 * \param[in] valeur : valeur de la monnaie
 * \param[in] devise : devise de la monnaie
 * \pre valeur >= 0
 */ 
void initialiser(monnaie* m, int valeur, char devise){
    assert(valeur >= 0);
    (*m).valeur = valeur;
    (*m).devise = devise;
}


/**
 * \brief Ajouter une monnaie m1 à une monnaie m2 
 * \param[in] m1 : monnaie 1
 * \param[in out] m2 : monnaie 2
 */ 
bool ajouter(monnaie m1, monnaie* m2){
    if (m1.devise == (*m2).devise){
        (*m2).valeur += m1.valeur;
    }
    return m1.devise == (*m2).devise;
}


/**
 * \brief Tester Initialiser 
 */ 
void tester_initialiser(){
    monnaie m;
    initialiser(&m, 1, 'e');
    assert(m.valeur == 1 && m.devise == 'e');
    initialiser(&m, 4, 'd');
    assert(m.valeur == 4 && m.devise == 'd');
    printf("Test initialiser ok\n");
}

/**
 * \brief Tester Ajouter 
 */ 
void tester_ajouter(){    
    monnaie m1, m2;
    initialiser(&m1, 5, 'e');
    initialiser(&m2, 7, 'e');
    ajouter(m1, &m2);
    assert(m2.valeur == 12);
    
    initialiser(&m1, 2, 'f');
    initialiser(&m2, 22, 'f');
    ajouter(m1, &m2);
    assert(m2.valeur == 24);
    
    initialiser(&m1, 2, 'z');
    initialiser(&m2, 22, 'a');
    ajouter(m1, &m2);
    assert(m2.valeur == 22);
    
    printf("Test ajouter ok\n");
}



int main(void){
    
    // Tests
    tester_initialiser();
    tester_ajouter();
    
    // Un tableau de 5 monnaies
    monnaie porte_monnaie[nb_monnaie];
    
    
    //Initialiser les monnaies
    int valeur;
    char devise;
    
    for (int i = 0; i<nb_monnaie; i++){
        printf("Valeur de la monnaie %d :", i);
        scanf(" %d", &valeur);
        printf("Devise de la monnaie %d :", i);
        scanf(" %c", &devise);
        printf("...\n");
        initialiser(&porte_monnaie[i], valeur, devise);
    }
    
    
    // Afficher la somme des toutes les monnaies qui sont dans une devise entrée par l'utilisateur.
    char devise_demandee;
    printf("Devise demandée :");
    scanf(" %c", &devise_demandee);
    
    monnaie stot;
    initialiser(&stot, 0, devise_demandee);
    
    for (int i = 0; i<nb_monnaie; i++){
         ajouter(porte_monnaie[i], &stot);
    }
    
    printf("Somme totale de la monnaie %c : %d\n", devise_demandee, stot.valeur);
    return EXIT_SUCCESS;
}
