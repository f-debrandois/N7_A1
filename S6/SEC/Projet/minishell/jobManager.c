#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include <sys/wait.h>
#include <signal.h>
#include "jobManager.h"

#define MAX_JOBS 10

// Structure to represent a job
typedef struct {
    int id;                 // Job identifier
    pid_t pid;              // Process ID of the job
    char cmdline[1024];     // Command line of the job
    bool active;            // Flag indicating if the job is active or suspended
} Job;

Job jobs[MAX_JOBS];         // Array to store the jobs
int numJobs = 0;            // Number of active jobs

// Add a job to the list
void addJob(pid_t pid, char* cmdline) {
    if (numJobs >= MAX_JOBS) {
        printf("Maximum number of jobs reached\n");
        return;
    }

    Job newJob;
    newJob.id = numJobs + 1;
    newJob.pid = pid;
    strncpy(newJob.cmdline, cmdline, sizeof(newJob.cmdline));
    newJob.active = true;

    jobs[numJobs++] = newJob;
}

// Remove a job from the list
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

// List all the active jobs
void listJobs() {
    printf("ID shell\tPID\tStatus\tCommande\n");
    for (int i = 0; i < numJobs; i++) {
        Job job = jobs[i];
        printf("[%d]\t %d\t %s\t %s\n", job.id, job.pid, (job.active ? "actif" : "suspendu"), job.cmdline);
    }
}

// Suspend a job
void stopJob(int id) {
    for (int i = 0; i < numJobs; i++) {
        if (jobs[i].id == id) {
            kill(jobs[i].pid, SIGSTOP);
            jobs[i].active = false;
            return;
        }
    }

    printf("Job with ID %d not found\n", id);
}

// Resume a suspended job
void backgroundJob(int id) {
    for (int i = 0; i < numJobs; i++) {
        if (jobs[i].id == id) {
            kill(jobs[i].pid, SIGCONT);
            jobs[i].active = true;
            return;
        }
    }

    printf("Job with ID %d not found\n", id);
}

// Bring a job to the foreground
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

    printf("Job with ID %d not found\n", id);
}

// Initialize the job manager
void initializeJobManager() {
    numJobs = 0;
}
