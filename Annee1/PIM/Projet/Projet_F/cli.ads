with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Routeur_Outils; use Routeur_Outils;

package CLI is
    procedure Initialiser(Valeur_Initiale : in out Valeur_Entree);

    type Valeur_Entree is record
        Capacite : Integer := 10;
        Politique : T_Politique := FIFO;
        Afficher_Stats_Active : Boolean := True;
        Nom_Entree : Unbounded_String := To_Unbounded_String("table.txt");
        Nom_Paquet : Unbounded_String := To_Unbounded_String("paquets.txt");
        Nom_Sortie : Unbounded_String := To_Unbounded_String("resultats.txt");

        Type_Routeur : T_Routeur := simple;

        Nombre_Defaut_Cache : Integer := 0;
        Nombre_Demande_Route : Integer := 0;
    end record;
end CLI;
