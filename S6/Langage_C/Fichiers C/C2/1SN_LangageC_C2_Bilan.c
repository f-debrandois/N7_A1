#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <assert.h>
#include <string.h>

// Consignes :
//      - Compléter les instructions pour réaliser les fonctions et 
//        procédures de ce fichier de façon à exécuter les tests avec succès.
// Vous pouvez utiliser les sous-programmes de la bibliothèque string.h pour réaliser 
// les principales opérations (copie, recherche, etc.)

struct string {
    char *str; // tableau de caracteres. Doit se terminer par `\0`.
    int N; // nombre de caractères, `\0` inclus.
};
typedef struct string string;

/**
 * \brief Initialiser à partir d’une chaîne de caractères classique 
 * (tableau de caractères terminé par le caractère nul)
 * \param[out] chaine_dest string initialisé
 * \param[in] chaine_src chaine conventionnelle
 */
void create(string *chaine_dest, char *chaine_src){
    chaine_dest->str = malloc(sizeof(char) * chaine_dest->N);
    strcpy(chaine_dest->str, chaine_src);
    chaine_dest->N = strlen(chaine_src) + 1; // + 1 pour '\0'
}

/**
 * \brief obtenir le nombre de caractères de la chaîne
 * \param[in] str chaine
 */
int length(string chaine){
    return chaine.N - 1;
}

/**
 * \brief ajouter un nouveau caractère à la fin de la chaîne. Sa longueur est donc augmentée de 1.
 * \param[inout] chaine
 * \param[in] c le caractère à ajouter en fin de chaine.
*/
void add(string *chaine, char c){
    chaine->str = realloc(chaine->str, sizeof(char) * chaine->N+1);
    chaine->str[chaine->N-1] = c;
    chaine->N++;
}


/**
 * \brief supprimer le caractère à la position i.
 * \param[inout] chaine
 * \param[in] i position du caractere dans la chaine 
 * (attention à la precondition).
*/
void delete(string *chaine_dest, int i){
    assert(i >= 0 && i < length(*chaine_dest));
    for (int j = i; j < length(*chaine_dest) - 1; j++) {
        chaine_dest->str[j] = chaine_dest->str[j + 1];
    }
    chaine_dest->N--;
    chaine_dest->str = realloc(chaine_dest->str, sizeof(char) * chaine_dest->N);
}

/**
 * \brief détruire, elle ne pourra plus être utilisée (sauf à être de nouveau initialisée)
 * \param[in] chaine chaine à détruire
*/
void destroy(string *chaine){
    free(chaine->str);
    chaine->str = NULL;
    chaine->N = 0;
}



void test_create(){
    string ch, ch1, ch2;
    create(&ch, "UN");
    assert(ch.N == 3);
    assert(ch.str[0] == 'U');
    create(&ch1, "DEUX");
    assert(ch1.N == 5);
    assert(ch1.str[4] == '\0');
    create(&ch2, "");
    assert(ch2.N == 1);
    assert(ch2.str[0] == '\0');
    
    destroy(&ch);
    destroy(&ch1);
    destroy(&ch2);
}


void test_length(){
    string ch, ch1;
    create(&ch, "UN");
    assert(strlen("UN")==length(ch));
    create(&ch1, "");
    assert(length(ch1)==strlen(""));
    destroy(&ch);
    destroy(&ch1);
}

void test_add(){
    string ch1;
    create(&ch1, "TROI");
    add(&ch1, 'S');
    assert(length(ch1) == 5);
    assert(ch1.str[4] == 'S');
    add(&ch1, '+');
    assert(length(ch1) == 6);
    assert(ch1.str[5] == '+');
    destroy(&ch1);
}


void test_delete(){
    string ch1;
    create(&ch1, "TROIS");
    delete(&ch1, 0); //ROIS
    assert(length(ch1) == 4);
    assert(ch1.str[0] == 'R');
    delete(&ch1, 2); //ROS
    assert(length(ch1) == 3);
    assert(ch1.str[2] == 'S');
    delete(&ch1, 2); //RO
    assert(length(ch1) == 2);
    assert(ch1.str[1] == 'O');
    delete(&ch1, 0); //O
    delete(&ch1, 0); //_
    assert(length(ch1) == 0);
    
    destroy(&ch1);
}


void test_destroy(){
    string ch, ch1;
    create(&ch, "UN");
    destroy(&ch);
    assert(ch.str == NULL);
    
    create(&ch1, "TROI");
    add(&ch1, 'S');
    destroy(&ch1);
    assert(ch1.str == NULL);
}

int main(){
    test_create();
    test_length();
    test_add();
    test_delete();
    test_destroy();
    
    printf("%s", "\n Bravo ! Tous les tests passent.\n");
    return EXIT_SUCCESS;
}
