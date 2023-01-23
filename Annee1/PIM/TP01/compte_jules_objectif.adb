with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;

-- ÃnoncÃ© :
--
-- Ã la naissance de Jules, ses parents lui ont ouvert un compte sur lequel ils
-- ont versÃ© 100 euros. Ensuite, Ã  chaque anniversaire de Jules, ils ont versÃ©
-- 100 euros et le double de son Ã¢ge en euros sur ce compte.
-- 
-- Par exemple, lorsque Jules a eu 2 ans, ses parents ont versÃ© 104 euros sur
-- son compte (100 euros + 2 * 2 euros).
-- 
-- Quel Ã¢ge devra atteindre Jules avant de disposer d'une certaine somme sur
-- son compte ?
-- 
-- On considÃ¨re que le compte n'est pas rÃ©munÃ©rÃ© et qu'aucun retrait n'est fait
-- sur ce compte.
--
-- Exemples
--
-- objectif ->  versements
-- -----------------
-- 202      ->  1
-- 400      ->  3
--

procedure Compte_Jules is

	Objectif: Integer;	-- Somme souhaitÃ©e sur le compte de Jules
	Age: Integer;		-- Age de Jules
	Solde: Integer;		-- Solde du compte de Jules

begin
	-- Demander la somme souhaitÃ©e
	Put ("Somme attendue : ");
	Get (Objectif);
	Solde := 100;
	Age := 0;
	while Solde < Objectif loop
	    Age := Age+1;
	    Solde := Solde + 100 + 2*Age;
	end loop;

	-- DÃ©terminer l'Ã¢ge de Jules pour avoir au moins somme sur son compte

	-- Afficher l'Ã¢ge que doit avoir Jule
	Put ("Age : ");
	Put (Age, 1);
	New_Line;

end Compte_Jules;
