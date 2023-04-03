/**
 *  \author Xavier Cregut <nom@n7.fr>
 *  \file file.h
 * 
 *  Objectifs :
 *	.  Definition et utilisation des modules
 *	.  Allocation dynamique de memoire
 */

#include <stdbool.h>

struct Cellule {
    char valeur;
    struct Cellule *suivante;
};
typedef struct Cellule Cellule;

struct File {
    Cellule *tete;
    Cellule *queue;
    /** Invariant :
      *	 file vide :	tete == NULL && queue == NULL
      */
};
typedef struct File File;


/**
 * Initialiser la file \a f.
 * La file est vide.
 *
 * Assure
 *	est_vide(*f);
 */
void initialiser(File *f);

/**
 * Detruire la file \a f.
 * Elle ne pourra plus etre utilisee (sauf etre de nouveau initialisee)
 */
void detruire(File *f);

/**
 * L'element en tete de la file.
 * Necessite :
 *	! est_vide(f);
 */
char tete(File f);

/**
 * Ajouter dans la file \a f l'element \a v.
 *
 * Necessite :
 *	f != NULL;
 */
void inserer(File *f, char v);

/**
 * Extraire l'element \a v en tete de la file \a f.
 * Necessite
 *	f != NULL;
 *	! est_vide(*f);
 */
void extraire(File *f, char *v);

/**
 * Est-ce que la file \a f  est vide ?
 */
bool est_vide(File f);

/**
 * Obtenir la longueur de la file.
 */
int longueur(File f);
