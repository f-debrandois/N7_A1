#ifndef CARTE_H
#define CARTE_H

#include <stdbool.h>


#define NB_VALEURS 10

//Définition du type enseigne
enum couleur {JAUNE, ROUGE, VERT, BLEU};
typedef enum couleur couleur;

//Tableau de caractères représentant les couleurs
char C[4] = {'J', 'R', 'V', 'B'};

//Définition du type carte
struct carte {
    couleur couleur;
    int valeur; // Invariant : valeur >= 0 && valeur < NB_VALEURS
    bool presente; // la carte est-elle presente dans le jeu ?
};
typedef struct carte carte;

/**
 * \brief Initialiser une carte avec une couleur et une valeur. 
 * \param[in] c couleur de la carte
 * \param[in] v valeur de la carte
 * \param[in] ej booléen presente
 * \param[out] la_carte 
 */
void init_carte(carte* la_carte, couleur c, int v, bool pr);

/**
 * \brief Vérifie si la valeur de la carte est conforme à l'invariant.
 * \param[in] c la carte
 * \return bool vrai si la valeur est conforme, faux sinon.
 */
bool est_conforme(carte c);

/**
 * \brief Copie les valeurs de la carte src dans la carte dest.
 * \param[in] src carte à copier
 * \param[out] dest carte destination de la copie 
 */
void copier_carte(carte* dest, carte src);

void afficher_carte(carte cte);

#endif
