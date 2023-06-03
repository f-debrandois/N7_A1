#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include <sys/wait.h>
#include <signal.h>
#include <fcntl.h>
#include <bits/sigaction.h>

#include "readcmd.h"
#include "jobManager.h"

// Indicateur permettant de savoir si l'interpréteur de commandes est suspendu
bool shellSuspended = false;

// PID du processus fils en cours d'exécution (foreground)
pid_t foregroundPID;

// Gestionnaire de signal pour SIGTSTP (Ctrl-Z)
void handleSIGTSTP(int signum) {
    if (!shellSuspended) {
        // Suspendre le shell
        printf("\nSuspension du processus.\n");
        shellSuspended = true;
    }
}

// Gestionnaire de signal pour SIGINT (Ctrl-C)
void handleSIGINT(int signum) {
    if (foregroundPID != 0) {
        // Terminer le processus foreground
        printf("\nTerminaison du processus.\n");
        kill(foregroundPID, SIGINT);
    }
}

// Commande change directory
void execute_cd(char* directory) {
    if (directory == NULL || strcmp(directory, "~") == 0) {
        chdir(getenv("HOME"));
    } else if (chdir(directory) != 0) {
        printf("Répertoire invalide !\n");
    }
}

// Commande "susp" pour suspendre le shell
void suspendShell() {
    if (!shellSuspended) {
        // Suspendre le shell
        printf("\nShell suspendu.\n");
        shellSuspended = true;
        raise(SIGSTOP); // Envoyer le signal SIGSTOP pour suspendre le processus shell
    }
}

int main() {

    // Initialisation du job manager
    initializeJobManager();

    // Mise en place du gestionnaire du signal SIGTSTP
    struct sigaction saTSTP;
    saTSTP.sa_handler = handleSIGTSTP;
    sigemptyset(&saTSTP.sa_mask);
    saTSTP.sa_flags = 0;
    sigaction(SIGTSTP, &saTSTP, NULL);

    // Mise en place du gestionnaire du signal SIGINT
    struct sigaction saINT;
    saINT.sa_handler = handleSIGINT;
    sigemptyset(&saINT.sa_mask);
    saINT.sa_flags = 0;
    sigaction(SIGINT, &saINT, NULL);

    // Initialisation des variables
    struct cmdline *cmd;
    pid_t pid;
    int pipefd[2];

    while (1) {

        // Afficher le répertoire courant
        char cwd[1024];
        if (getcwd(cwd, sizeof(cwd)) != NULL) {
            printf("%s >>> ", cwd);
        } else {
            perror("getcwd() error");
            return 1;
        }

        // Vider le flux de sortie standard
        fflush(stdout);

        // Lire la commande
        cmd = readcmd();

        // Gérer la commande nulle
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
                    printf("Sortie du Shell...\n");
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
                // Commande "susp" to suspend the shell
                else if (strcmp(cmd->seq[0][0], "susp") == 0) {
                    suspendShell();
                    continue;
                }
            }

            // Créer le processus fils
            pid = fork();

            if (pid == 0) {
                // Fils

                if (cmd->in != NULL) {
                    // Redirection d'entrée
                    int fd = open(cmd->in, O_RDONLY);
                    if (fd == -1) {
                        perror("Erreur lors de l'ouverture du fichier d'entrée");
                        exit(1);
                    }
                    dup2(fd, STDIN_FILENO);
                    close(fd);
                }

                if (cmd->out != NULL) {
                    // Redirection de sortie
                    int fd = open(cmd->out, O_WRONLY | O_CREAT | O_TRUNC, 0666);
                    if (fd == -1) {
                        perror("Erreur lors de l'ouverture du fichier de sortie");
                        exit(1);
                    }
                    dup2(fd, STDOUT_FILENO);
                    close(fd);
                }

                if (cmd->seq[1][0] != NULL) {
                    // Tube
                    if (pipe(pipefd) == -1) {
                        perror("Erreur lors de la création du tube");
                        exit(1);
                    }

                    pid_t pid2 = fork();
                    if (pid2 == 0) {
                        // Fils du fils (second processus de la commande pipe)
                        close(pipefd[1]);  // Fermer l'extrémité d'écriture du tube
                        dup2(pipefd[0], STDIN_FILENO);  // Rediriger l'entrée standard vers l'extrémité de lecture du tube
                        close(pipefd[0]);  // Fermer l'extrémité de lecture du tube

                        // Exécuter la deuxième commande de la séquence
                        if (execvp(cmd->seq[1][0], cmd->seq[1]) == -1) {
                            perror("Erreur lors de l'exécution de la deuxième commande");
                            exit(1);
                        }
                    } else if (pid2 > 0) {
                        // Père du fils (premier processus de la commande pipe)
                        close(pipefd[0]);  // Fermer l'extrémité de lecture du tube
                        dup2(pipefd[1], STDOUT_FILENO);  // Rediriger la sortie standard vers l'extrémité d'écriture du tube
                        close(pipefd[1]);  // Fermer l'extrémité d'écriture du tube

                        // Exécuter la première commande de la séquence
                        if (execvp(cmd->seq[0][0], cmd->seq[0]) == -1) {
                            perror("Erreur lors de l'exécution de la première commande");
                            exit(1);
                        }
                    } else {
                        perror("Erreur lors de la création du processus fils (tube)");
                        exit(1);
                    }
                } else {
                    // Pas de tube, exécuter simplement la commande
                    if (execvp(cmd->seq[0][0], cmd->seq[0]) == -1) {
                        perror("Erreur lors de l'exécution de la commande");
                        exit(1);
                    }
                }
            } else if (pid > 0) {
                // Père
                if (cmd->backgrounded == NULL) {
                    // Attendre la fin du processus fils (foreground)
                    foregroundPID = pid;
                    int status;
                    waitpid(pid, &status, 0);
                    removeJob(pid);
                    foregroundPID = 0;
                } else {
                    // Ajouter le processus fils à la liste des jobs (background)
                    addJob(pid, cmd->seq[0][0]);
                }
            } else {
                perror("Erreur lors de la création du processus fils");
                exit(1);
            }
        }
    }

    return 0;
}
