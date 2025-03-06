-- Gère les opéérations du routeur LL

with Routeur_Outils; use Routeur_Outils;
with Cache_LL; use Cache_LL;

package Routeur_LL is

   procedure Traitement_LL (Valeur_Initiale : in Valeur_Entree ; Paquet : in out T_Paquet; Table : in T_Table; Sortie : out T_Sortie);

end Routeur_LL;
