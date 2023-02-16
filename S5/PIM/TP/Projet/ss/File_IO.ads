with Adresse_IP; use Adresse_IP;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Routeur_Outils; use Routeur_Outils;
with Routage; use Routage;
with Cache; use Cache;

package File_IO is

    procedure Remplir_Table(Valeur_Initiale : Valeur_Entree; Tab : in out T_Table);

    procedure Traitement_Simple(Valeur_Initiale : Valeur_Entree ; Tab : in T_Table);

    procedure Traitement_LL(Valeur_Initiale : in out Valeur_Entree; Tab : in T_Table ; Cache : in out T_Cache);

end File_IO;