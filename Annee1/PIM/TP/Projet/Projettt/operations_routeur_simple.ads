-- Gère les opéérations du routeur Simple

with Routeur_Outils; use Routeur_Outils;
with Routeur; use Routeur;

package Routeur_simple is
    
    procedure Traitement_simple (Valeur_Initiale : in Valeur_Entree ; Paquet : in out T_Paquet; Table : in T_Table; Sortie : out T_Sortie);
   

end Routeur_simple;
