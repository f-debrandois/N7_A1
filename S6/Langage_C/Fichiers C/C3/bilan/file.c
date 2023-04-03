/**
 *  \author Xavier Cregut <nom@n7.fr>
 *  \file file.c
 *
 *  Objectif :
 *	Implantation des operations de la file
*/

#include <malloc.h>
#include <assert.h>

#include "file.h"


void initialiser(File *f)
{
    f->tete = NULL;
    f->queue = NULL;
    assert(est_vide(*f));
}


void detruire(File *f)
{
    while (! est_vide(*f)) {
        char v;
        extraire(f, &v);
    }
}


char tete(File f)
{
    assert(! est_vide(f));
    return f.tete->valeur;
}


bool est_vide(File f)
{
    return f.tete == NULL && f.queue == NULL;
}

/**
 * Obtenir une nouvelle cellule allouee dynamiquement
 * initialisee avec la valeur et la cellule suivante precise en parametre.
 */
static Cellule * cellule(char valeur, Cellule *suivante)
{
    Cellule *c = malloc(sizeof(Cellule));
    c->valeur = valeur;
    c->suivante = suivante;
    return c;
}


void inserer(File *f, char v)
{
    assert(f != NULL);

    Cellule *c = cellule(v, NULL);

    if (est_vide(*f)) {
        f->tete = c;
    } else {
        f->queue->suivante = c;
    }

    f->queue = c;
}

void extraire(File *f, char *v)
{
    assert(f != NULL);
    assert(! est_vide(*f));

    Cellule *c = f->tete;
    *v = c->valeur;

    f->tete = c->suivante;
    if (f->tete == NULL) {
        f->queue = NULL;
    }

    free(c);
}


int longueur(File f)
{
    int len = 0;
    Cellule *c = f.tete;
    while (c != NULL) {
        len++;
        c = c->suivante;
    }
    return len;
}
