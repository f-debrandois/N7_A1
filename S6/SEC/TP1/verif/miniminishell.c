#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    char buf[30];	/* contient la commande saisie au clavier */
    int ret;		/* valeur de retour de scanf */
    pid_t pidFils;
    int status;

    while (1) {
        printf(">>>");

        ret = scanf("%s", buf);	/* lit et range dans buf la chaine entrée au clavier */

        if (ret == EOF) {
            printf("Sortie de la boucle\n");
            break;
        }

        if (strcmp(buf, "exit") == 0) {
            printf("Sortie de la boucle\n");
            break;
        }

        pidFils = fork();

        if ( pidFils == -1) {
		printf("Erreur fork\n");
		exit(1);
	}

        if (pidFils == 0) {
		/* Fils */
            	execlp(buf, buf, NULL);
            	/* La suite est exécutée si la commande execlp a échouée */
            	printf("ECHEC : la commande %s n'a pas pu être exécutée\n", buf);
            	exit(1);

        } else {
            	/* Père */
            	wait(&status);
            	if (WIFEXITED(status)) {
                	if (WEXITSTATUS(status) == 0) {
                   	 printf("SUCCES : la commande %s a été exécutée avec succès\n", buf);
                	} else {
                   	printf("ECHEC : la commande %s n'a pas pu être exécutée\n", buf);
                	}
            	}
    	}
    }

    printf("Salut\n");

    return 0;
}
