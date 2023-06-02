#ifndef JOB_MANAGER_H
#define JOB_MANAGER_H

// Fonction pour ajouter un job
void addJob(pid_t pid, char* cmdline);

// Fonction pour retirer un job
void removeJob(int id);

// Fonction qui liste les jobs
void listJobs();

// Fonction permettant d'arrêter/suspendre un job
void stopJob(int id);

// Fonction pour reprendre un job suspendu en arrière-plan
void backgroundJob(int id);

// Fonction pour reprendre un job suspendu au premier plan
void foregroundJob(int id);

// Fonction pour initialiser le job manager
void initializeJobManager();

#endif
