#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include <sys/wait.h>
#include "readcmd.h"

int main(int argc, char *argv[]) {
	
    struct cmdline *cmd;
    pid_t pid;
    while (1) {
        printf("$ ");
        fflush(stdout);

        struct cmdline *cmd = readcmd();
        if (cmd == NULL) {
            // Null command indicates an error or end of input
            NULL;
        }

        if (cmd->err != NULL) {
            // Display error message if there was an error in the command
            fprintf(stderr, "%s\n", cmd->err);
        } else {
            // Fork a child process to execute the command
            pid = fork();
            if (pid == 0) {
                // Child process
                if (execvp(cmd->seq[0][0], cmd->seq[0]) == -1) {
                    perror("execvp");
                    exit(1);
                }
            } else if (pid > 0) {
                // Parent process
                wait(NULL);
            } else {
                perror("fork");
            }
        }

        // Free the memory allocated by readcmd()
        freecmd(cmd);
        free(cmd);
    }

    return 0;
}

