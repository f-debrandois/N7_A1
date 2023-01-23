with Adresse_IP; use Adresse_IP;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Cache; use Cache;

package Routeur_Outils is
    
    type T_Politique is (FIFO, LRU, LFU);
    
    type T_Cellule;
    type T_Cache is access T_Cellule;
    type T_Cellule is
        record
            Destination : T_IP;
            Masque : T_IP;
            Interf : Unbounded_String;
            Precedent : T_Cache;
            Suivant : T_Cache;
            Utilisation : Integer;
        end record;
    
    type Valeur_Entree is
    record
        Politique : T_Politique := FIFO;
        Nom_Paquet : Unbounded_String := To_Unbounded_String("paquets.txt");
        Nom_Entree : Unbounded_String := To_Unbounded_String("table.txt");
        Nom_Sortie : Unbounded_String := To_Unbounded_String("resultats.txt");
        Capacite : Integer := 10;
        Afficher_Stats_Active : Boolean := True;
        Nombre_Defaut_Cache : Integer := 0;
        Nombre_Demande_Route : Integer := 0;
    end record;
end Routeur_Outils;
