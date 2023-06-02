#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include <sys/wait.h>
#include <signal.h>

#include "readcmd.h"
#include "jobManager.h"


// Fonctions commandes internes
void execute_cd(char* directory) {
    if (directory == NULL || strcmp(directory, "~") == 0) {
        chdir(getenv("HOME"));
    } else if (chdir(directory) != 0) {
        printf("Répertoire invalide\n");
    }
}

int main() {

    // Initialize the job manager
    initializeJobManager();

    // Initialisation des variables
    struct cmdline *cmd;
    pid_t pid;

    while (1) {

        // Display the current directory
        char cwd[1024];
        if (getcwd(cwd, sizeof(cwd)) != NULL) {
            printf("%s >>> ", cwd);
        } else {
            perror("getcwd() error");
            return 1;
        }

        // Flush the standard output stream
        fflush(stdout);

        // Read the command
        cmd = readcmd();

        // Handle null command
        if (cmd == NULL) {
            continue;
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
                // Commande "lj" (list jobs)
                else if (strcmp(cmd->seq[0][0], "lj") == 0) {
                    listJobs();
                    continue;
                }
                // Commande "sj" (stop job)
                else if (strcmp(cmd->seq[0][0], "sj") == 0) {
                    if (cmd->seq[0][1] != NULL) {
                        int id = atoi(cmd->seq[0][1]);
                        stopJob(id);
                    } else {
                        printf("Erreur : sj [ID Minishell]\n");
                    }
                    continue;
                }
                // Commande "bg" (background)
                else if (strcmp(cmd->seq[0][0], "bg") == 0) {
                    if (cmd->seq[0][1] != NULL) {
                        int id = atoi(cmd->seq[0][1]);
                        backgroundJob(id);
                    } else {
                        printf("Erreur : bg [ID Minishell]\n");
                    }
                    continue;
                }
                // Commande "fg" (foreground)
                else if (strcmp(cmd->seq[0][0], "fg") == 0) {
                    if (cmd->seq[0][1] != NULL) {
                        int id = atoi(cmd->seq[0][1]);
                        foregroundJob(id);
                    } else {
                        printf("Erreur : fg [ID Minishell]\n");
                    }
                    continue;
                }
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
                addJob(pid, cmd->seq[0][0]);

                // Attendre la fin du processus fils (foreground)
                if (cmd->backgrounded == NULL) {
                    int status;
                    waitpid(pid, &status, 0);
                    removeJob(pid);
                }
            } else {
                printf("Fork error\n");
                exit(1);
            }

        }
    }

    return 0;
}
