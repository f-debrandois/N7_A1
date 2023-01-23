with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;    use Ada.Float_Text_IO;

-- Afficher le tarif d'une place
-- 
-- Le tarif normal de la place est de 12,60 â¬. Les enfants (moins de 14 ans)
-- paient 7 â¬. Les sÃ©niors (65 ans et plus) paient 10,30 â¬.
--
-- Exemples :
--
--   age  ->  tarif
--   -----------------
--   25   ->  12.60
--    8   ->  7.0
--   75   ->  10.30
--   14   ->  12.60
--
procedure Tarif_Place is

	Age: Integer;  -- l'Ã¢ge de la personne
	Tarif: Float;  -- le tarif Ã  appliquer
begin
	-- Demander l'age
	Put ("Ãge : ");
	Get (Age);

	-- DÃ©terminer le tarif de la place
	if Age >= 65 then
	    Tarif := 10.30;
	elsif Age < 14 then
	    Tarif := 7.0;
	else
	    Tarif := 12.60;
	end if;

	-- Afficher le tarif
	Put ("Le tarif pour ");
	Put (Age, 1);
	Put (" ans est ");
	Put (Tarif, Exp => 0, Aft => 2, Fore => 1);
	Put (" euros.");
	New_Line;

end Tarif_Place;
