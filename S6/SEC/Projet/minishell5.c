#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include <sys/wait.h>
#include "readcmd.h"

int main(int argc, char *argv[]) {

    struct cmdline *cmd;
    bool boucle = true;
    pid_t pidFils;
    int status;

    while(boucle) {
        printf("$ ");
        fflush(stdout);
        cmd = readcmd();

        if (cmd == NULL) {
            NULL;
        } else if (strcmp(cmd->seq[0][0], "cd") == 0) {
            // Changer de répertoire
            if (cmd->seq[0][1] == NULL || strcmp(cmd->seq[0][1], "$HOME") == 0) {
                chdir(getenv("HOME"));
            } else {
                chdir(cmd->seq[0][1]);
            }
        } else if (strcmp(cmd->seq[0][0], "exit") == 0) {
            // Quitter le minishell
            boucle = false;
        } else {
            pidFils = fork();
            if (pidFils < 0) {
		        printf("Erreur fork\n");
                    exit(1);
            }
            if (pidFils == 0) {
                /* Fils */
                execvp(cmd->seq[0][0], cmd->seq[0]);
                /* La suite est exécutée si la commande execlp a échouée */
                exit(1);
            } else {
                /* Père */
                waitpid(pidFils, &status, 0);
            }
        }
    }
    return EXIT_SUCCESS;
}