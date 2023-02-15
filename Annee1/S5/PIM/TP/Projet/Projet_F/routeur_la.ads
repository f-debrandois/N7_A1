-- Gère les opéérations du routeur LA

with Routeur_Outils; use Routeur_Outils;
with Cache_LA; use Cache_LA;

package Routeur_LA is

   procedure Traitement_LA (Valeur_Initiale : in Valeur_Entree ; Paquet : in out T_Paquet; Table : in T_Table; Sortie : out T_Sortie);

end Routeur_LA;
