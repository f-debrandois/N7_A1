#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char *argv[]) {
    pid_t pidFils;
    pidFils = fork();

    if (pidFils == -1) {
        printf("Erreur fork/n");
        exit(1);
    }
    if (pidFils == 0) {
    execlp("ls", "lister", "-l", NULL);
    exit(EXIT_SUCCESS);
    }
    else {
    
    return EXIT_SUCCESS;
}
