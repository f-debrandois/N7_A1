with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Vecteurs_Creux;    use Vecteurs_Creux;

-- Exemple d'utilisation des vecteurs creux.
procedure Exemple_Vecteurs_Creux is

	V : T_Vecteur_Creux;
	Epsilon: constant Float := 1.0e-5;
begin
    Put_Line ("Début du scénario");

    Initialiser(V);
    --Detruire(V);
    pragma assert(Est_Nul(V));
    Composante_Recursif(V, 3);
    Composante_Iteratif(V, 3);

	Put_Line ("Fin du scénario");
end Exemple_Vecteurs_Creux;
