#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include <sys/wait.h>
#include "readcmd.h"

// Fonctions commandes internes
void execute_cd(char* directory) {
    if (directory == NULL || strcmp(directory, "~") == 0) {
        chdir(getenv("HOME"));
    } else if (chdir(directory) != 0) {
        printf("Répertoire invalide\n");
    }
}

int main() {
	
    // Initialisation des variables
    struct cmdline *cmd;
    pid_t pid;
    int wstatus;

    while (1) {

        // Afficher le répertoire courant
        char cwd[1024];
        if (getcwd(cwd, sizeof(cwd)) != NULL) {
            printf("\n%s >>> ", cwd);
        } else {
            perror("getcwd() error");
            return 1;
        }

        // Vider le flux standard de sortie
        fflush(stdout);

        // Lecture de la commande
        cmd = readcmd();

        // Cas commande nulle
        if (cmd == NULL) {
            NULL;
        }

        // Afficher un message d'erreur si erreur dans la commande
        if (cmd->err != NULL) {
            fprintf(stderr, "%s\n", cmd->err);

        } else {
            // Vérifier les commandes internes
            if (cmd->seq[0][0] != NULL) {
                // Commande "cd"
                if (strcmp(cmd->seq[0][0], "cd") == 0) {
                    execute_cd(cmd->seq[0][1]);
                    continue;
                }
                // Commande "exit"
                else if (strcmp(cmd->seq[0][0], "exit") == 0) {
                    printf("Sortie du shell...\n");
                    exit(0);
                }

                // Créer le processus fils
                pid = fork();

                if (pid == 0) {
                    // Fils
                    if (execvp(cmd->seq[0][0], cmd->seq[0]) == -1) {
                        printf("La commande %s n'a pas pu être exécutée\n", cmd->seq[0][0]);
                        exit(1);
                    }
                } else if (pid > 0) {
                    // Père
                    wait(NULL);

                } else {
                    printf("Erreur fork\n");
                    exit(1);
                }
            }
        }

        // Attendre la fin du processus fils au premier plan
       if (cmd->backgrounded == NULL) { 
				wait(&wstatus);
		}
    }

    return 0;
}
