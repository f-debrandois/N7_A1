#define XXX 1

// Consignes : 
//  1. Remplacer XXX par le bon résultat dans la suite.
//  2. Compléter avec les instructions nécessaires en lieu et place de 
//     **** TODO ****

#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <time.h>

#define NB_VALEURS 10
#define NB_CARTES 4*NB_VALEURS

//Définition du type enseigne
enum couleur {JAUNE, ROUGE, VERT, BLEU};
typedef enum couleur couleur;

//Tableau de caractères représentant les couleurs
char C[4] = {'J', 'R', 'V', 'B'};

//Définition du type carte
struct carte {
    couleur couleur;
    int valeur; //valeur >= 0 && valeur < NB_VALEURS
    bool presente; // la carte est-elle presente dans le jeu ?
};
typedef struct carte carte;

//Définition du type jeu complet pour enregistrer NB_CARTES cartes.
typedef carte jeu[NB_CARTES];

//Définition du type t_main, capable d'enregistrer un nombre variable de cartes.
struct main {
    carte * main; //tableau des cartes dans la main. 
    int nb; //monbre de cartes
};
typedef struct main t_main;


/**
 * \brief Initialiser une carte avec une couleur et une valeur. 
 * \param[in] c couleur de la carte
 * \param[in] v valeur de la carte
 * \param[in] ej booléen presente
 * \param[out] la_carte 
 */
void init_carte(carte* la_carte, couleur c, int v, bool pr){
    la_carte->couleur = c;
    la_carte->valeur = v;
    la_carte->presente = pr;
}

/**
 * \brief Vérifie si la valeur de la carte est conforme à l'invariant.
 * \param[in] c la carte
 * \return bool vrai si la valeur est conforme, faux sinon.
 */
 bool est_conforme(carte c){
    return (c.valeur>=0 && c.valeur<NB_VALEURS);
}

/**
 * \brief Initialiser une main.
 * \param[in] N nombre de cartes composant la main.  Précondition : N <= (NB_CARTES - 1) div 2
 * \param[out] la_main créée
 * \return true si l'initialisation a échouée.
 */
bool init_main(t_main* la_main, int N){
    assert(N <= (NB_CARTES-1)/2);
    // ***** TODO ***** 
    // Corriger l'initialisation du tableau main
    la_main->main = NULL;
    la_main->nb = N;
    return (la_main==NULL); //allocation réussie ?
}

/**
 * \brief Initialiser le jeu en ajoutant toutes les cartes possibles au jeu. 
 * \brief Chaque carte est alors présente dans le jeu.
 * \param[out] le_jeu tableau de cartes avec les 4 couleurs et NB_VALEURS valeurs possibles
 */
void init_jeu(jeu le_jeu){
    int k=0;
    for (int i=0 ; i<4 ; i++){
        for (int j=0 ; j<NB_VALEURS ; j++){
            init_carte(&(le_jeu[k]), i, j, true);
            k++;
        }
    }
}


/**
 * \brief Copie les valeurs de la carte src dans la carte dest.
 * \param[in] src carte à copier
 * \param[out] dest carte destination de la copie 
 */
void copier_carte(carte* dest, carte src){
    dest->couleur = src.couleur;
    dest->valeur = src.valeur;
    dest->presente = src.presente;
}

/**
 * \brief Afficher une carte.
 * \param[in] cte carte à afficher
 */
void afficher_carte(carte cte){
    printf("(%c;%d;%d)\t", C[cte.couleur], cte.valeur, cte.presente);
}


/**
 * \brief Afficher le jeu.
 * \param[in] le_jeu complet
 */
void afficher_jeu(jeu le_jeu){
    // ***** TODO ***** 
    // Afficher le jeu complet. Les carte sont listées sur une même ligne, 
    // et séparées par une tabulation \t
    for (int i = 0; i < NB_CARTES; i++) {
        afficher_carte(le_jeu[i]);
    }
}

/**
 * \brief Afficher une main.
 * \param[in] la_main la main a afficher
 */
void afficher_main(t_main la_main){
    // ***** TODO ***** 
    // Afficher le jeu complet. Les carte sont listées sur une même ligne, 
    // et séparées par une tabulation \t
    for (int i = 0; i < la_main.nb; i++) {
        afficher_carte(la_main.main[i]);
    }
}

/**
 * \brief mélange le jeu.
 * \param[in out] le_jeu complet mélangé
 */
void melanger_jeu(jeu le_jeu){
    for (int k=0; k<1000; k++){
        // Choisir deux cartes aléatoirement
        int i = rand()%NB_CARTES;
        int j = rand()%NB_CARTES;        
        // Les échanger
        // ***** TODO ****
        carte temp = le_jeu[i];
        le_jeu[i] = le_jeu[j];
        le_jeu[j] = temp;
    }
}

/**
 \brief Distribuer N cartes à chacun des deux joueurs, en alternant les joueurs.
 * \param[in out] le_jeu complet.
 *       Si la carte c est distribuée dans une main, c.presente devient faux.
 * \param[in] N nombre de cartes distribuées à chaque joueur.  Précondition : N <= (NB_CARTES - 1) div 2
 * \param[out] m1 main du joueur 1.
 * \param[out] m2 main du joueur 2.
 */
void distribuer_mains(jeu le_jeu, int N, t_main* m1, t_main* m2){
    assert(N <= (NB_CARTES-1)/2);

    //Initialiser les mains de N cartes
    bool errA = init_main(m1, N);
    bool errB = init_main(m2, N);
    assert(!errA && !errB);
    
    //Distribuer les cartes
    for (int i=0; i<N; i++){
        // ajout d'une carte dans la main m1
        copier_carte(&(m1->main[i]), le_jeu[2*i]);
        // ajout d'une carte dans la main m2
        copier_carte(&(m2->main[i]), le_jeu[2*i+1]);
        //mise à jour de presente à false dans le_jeu
        le_jeu[2*i].presente = false;
        le_jeu[2*i+1].presente = false;
    }
}

/**
 * \brief Initialise le jeu de carte, les mains des joueurs et la carte 'last'.
 * \param[out] le_jeu complet avec les 4 couleurs et 10 valeurs possibles.
 *                Ce jeu est mélangé.
 *                Si la carte est inclue dans une main ou est la derniere carte jouée,
 *                Alors carte.presente vaut faux.
 * \param[in] N nombre de cartes par main.  Precondition : N <= (NB_CARTES-1)/2);
 * \param[out] main_A main du joueur A.
 * \param[out] main_B main du joueur B.
 * \param[out] last la derniere carte jouée par un des joueurs.
 */
int preparer_jeu_UNO(jeu le_jeu, int N, t_main* main_A, t_main* main_B, carte* last){
    assert(N <= (NB_CARTES-1)/2);
    
    //Initialiser le générateur de nombres aléatoires
    time_t t;
    srand((unsigned) time(&t));
 
    //Initialiser le jeu
    init_jeu(le_jeu);
    
    //Melanger le jeu
    melanger_jeu(le_jeu);

    //Distribuer N cartes à chaque joueur
    distribuer_mains(le_jeu, N, main_A, main_B);

    //Initialiser last avec la (2N+1)-ème carte du jeu.
    copier_carte(last, le_jeu[2*N]);
    le_jeu[2*N].presente = false; //carte n'est plus presente dans le_jeu
    
    return EXIT_SUCCESS;
}

void test_preparer_jeu_UNO(){
    //Déclarer un jeu (tableau statique), les deux mains (tableaux dynamiques) et 
    //la carte last.
    jeu le_jeu;
    t_main main_A, main_B;
    carte last;
 
    //Préparer le jeu, les deux mains de 7 cartes et la carte last
    int retour = preparer_jeu_UNO(le_jeu, 7, &main_A, &main_B, &last);
    printf("\n Le jeu mélangé avec les cartes presentes (c ; v ; p) : \n");
    afficher_jeu(le_jeu);
    printf("\n Les deux mains : \n");
    afficher_main(main_A);
    afficher_main(main_B);
    printf("\n La carte last : ");
    afficher_carte(last);
    printf("\n");

    //Vérifier le jeu et les mains.
    assert(retour == EXIT_SUCCESS);
    assert(main_A.nb == 7 && main_B.nb == 7);
    assert(main_A.main != NULL && main_B.main != NULL);    
    assert(est_conforme(main_A.main[0]));
    assert(est_conforme(main_B.main[0]));
    assert(est_conforme(last));
        
    //Détruire la mémoire allouée dynamiquement
    // ***** TODO *****
    free(main_A.main);
    free(main_B.main);
    main_A.main = NULL;
    main_B.main = NULL;
    
    assert(main_A.main == NULL);
    assert(main_B.main == NULL);
 
}

int main(void) {
  
    test_preparer_jeu_UNO();
    
    printf("%s", "\n Bravo ! Tous les tests passent.\n");
    return EXIT_SUCCESS;
}

