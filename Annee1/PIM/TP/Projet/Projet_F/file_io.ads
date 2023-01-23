-- Gestion des opérations relatives à la manipulation de fichiers

with Adresse_IP; use Adresse_IP;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Routeur_Outils; use Routeur_Outils;
with Routeur; use Routeur;


package File_IO is

    procedure Remplir_Table(Valeur_Initiale : in Valeur_Entree; Table : in out T_Table);

    procedure Recuperation_Paquet(Valeur_Initiale : in Valeur_Entree ; Paquet : in out T_Paquet);

    procedure Ecriture_Sortie(Valeur_Initiale : in Valeur_Entree; Sortie : in T_Sortie);

end File_IO;
