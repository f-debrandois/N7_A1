-- Gestion des arguments de la ligne de commande

with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

with Routeur_Outils; use Routeur_Outils;
with Routeur_exceptions; use Routeur_exceptions;


package CLI is
    procedure Initialiser(Valeur_Initiale : in out Valeur_Entree);
end CLI;
