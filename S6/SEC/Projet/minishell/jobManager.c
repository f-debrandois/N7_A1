#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include <sys/wait.h>
#include <signal.h>

#include "jobManager.h"

#define MAX_JOBS 100

// Structure pour représenter un job
typedef struct {
    int id;         // Identifiant du job
    pid_t pid;      // pid du job
    char cmdline[1024]; // Ligne de commande du job
    bool active;    // Indicateur indiquant si le job est actif ou suspendu
} Job;

Job jobs[MAX_JOBS]; // Tableau pour stocker les travaux
int numJobs = 0; // Nombre de travaux actifs

// Ajouter u job à la liste
void addJob(pid_t pid, char* cmdline) {
    if (numJobs >= MAX_JOBS) {
        printf("Nombre max de jobs atteint\n");
        return;
    }

    Job newJob;
    newJob.id = numJobs + 1;
    newJob.pid = pid;
    strncpy(newJob.cmdline, cmdline, sizeof(newJob.cmdline));
    newJob.active = true;

    jobs[numJobs++] = newJob;
}

// Retirer un job de la liste
void removeJob(int id) {
    for (int i = 0; i < numJobs; i++) {
        if (jobs[i].id == id) {
            for (int j = i; j < numJobs - 1; j++) {
                jobs[j] = jobs[j + 1];
            }
            numJobs--;
            return;
        }
    }
}

// Liste des jobs actifs
void listJobs() {
    printf("ID shell\tPID\tStatus\tCommande\n");
    for (int i = 0; i < numJobs; i++) {
        Job job = jobs[i];
        printf("[%d]\t %d\t %s\t %s\n", job.id, job.pid, (job.active ? "actif" : "suspendu"), job.cmdline);
    }
}

// Suspendre un job
void stopJob(int id) {
    for (int i = 0; i < numJobs; i++) {
        if (jobs[i].id == id) {
            kill(jobs[i].pid, SIGSTOP);
            jobs[i].active = false;
            return;
        }
    }
    printf("%d : ID de job invalide !\n", id);
}

// Reprendre un job suspendu
void backgroundJob(int id) {
    for (int i = 0; i < numJobs; i++) {
        if (jobs[i].id == id) {
            kill(jobs[i].pid, SIGCONT);
            jobs[i].active = true;
            return;
        }
    }

    printf("%d : ID de job invalide !\n", id);
}

// Mettre un job au premier plan
void foregroundJob(int id) {
    for (int i = 0; i < numJobs; i++) {
        if (jobs[i].id == id) {
            kill(jobs[i].pid, SIGCONT);
            jobs[i].active = true;
            waitpid(jobs[i].pid, NULL, 0);
            removeJob(id);
            return;
        }
    }

    printf("%d : ID de job invalide !\n", id);
}

// Initialiser le job manager
void initializeJobManager() {
    numJobs = 0;
}
