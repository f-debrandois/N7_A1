-- Types récurrents parmi les modules

with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

with Adresse_IP; use Adresse_IP;


package Routeur_Outils is
    
    type T_Politique is (FIFO, LRU, LFU);
    
    type T_Routeur is (Simple, LL, LA);
    
    type Valeur_Entree is record
        Type_Routeur : T_Routeur := Simple;
        Capacite : Integer := 10;
        Politique : T_Politique := FIFO;
        Afficher_Stats_Active : Boolean := True;
        Nom_Entree : Unbounded_String := To_Unbounded_String("table.txt");
        Nom_Paquet : Unbounded_String := To_Unbounded_String("paquets.txt");
        Nom_Sortie : Unbounded_String := To_Unbounded_String("resultats.txt");
 
        Nombre_Defaut_Cache : Integer := 0;
        Nombre_Demande_Route : Integer := 0;
    end record;
    
    type T_Cell_Table;
	type T_Table is access T_Cell_Table;
    type T_Cell_Table is record
        Destination : T_IP;
        Masque : T_IP;
        Interf : Unbounded_String;
        Suivant : T_Table;
    end record;

    type T_Cell_Paquet;
	type T_Paquet is access T_Cell_Paquet;
	type T_Cell_Paquet is record
        Est_Commande : Boolean;
        Commande : Unbounded_String;
        Destination : T_IP;
        Suivant : T_Paquet;
    end record;

    type T_Cell_Sortie;
	type T_Sortie is access T_Cell_Sortie;
	type T_Cell_Sortie is record
        Destination : T_IP;
        Interf : Unbounded_String;
        Suivant : T_Sortie;
    end record;

    
end Routeur_Outils;
