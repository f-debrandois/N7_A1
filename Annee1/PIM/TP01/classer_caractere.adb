with Ada.Text_IO;          use Ada.Text_IO;

-- afficher la classe Ã  laquelle appartient un caractÃ¨re lu au clavier
--
-- La classe d'un caractÃ¨re peut-Ãªtre 'C' pour Chiffre, 'L' pour Lettre, 'P'
-- pour Ponctuation ou 'A' pour Autre.
--
--  Exemples :
--
--  c    ->  classe
-- -------------------
-- '4'   ->  'C'
-- 'A'   ->  'L'
-- 'd'   ->  'L'
-- '!'   ->  'P'
-- '<'   ->  'A'
-- '='   ->  'A'
-- ','   ->  'P'
-- ';'   ->  'P'
-- '.'   ->  'P'
-- '?'   ->  'P'
-- 'z'   ->  'L'
-- 'Z'   ->  'L'
-- 'a'   ->  'L'
-- '0'   ->  'C'
-- '9'   ->  'C'
-- 'Ã '   ->  'A'
-- 'Ã'   ->  'A'
--
procedure Classer_Caractere is

	-- Constantes pour dÃ©finir la classe des caractÃ¨res
	--   Remarque : Dans la suite du cours nous verrons une meilleure
	--   faÃ§on de faire que de dÃ©finir ces constantes.  Laquelle ?
	Chiffre     : constant Character := 'C';
	Lettre      : constant Character := 'L';
	Ponctuation : constant Character := 'P';
	Autre       : constant Character := 'A';

	C : Character;		-- le caractÃ¨re Ã  classer
	Classe: Character;	-- la classe du caractÃ¨re C
begin
	-- Demander le caractÃ¨re
	Put ("CaractÃ¨re : ");
	Get (C);

	-- DÃ©terminer la classe du caractÃ¨re c
	if C = '1' or C = '2' or C = '3' or C = '4' or C = '5' or C = '6' or C = '7' or C = '8' or C = '9' or C = '0' then
	    Classe := Chiffre;
	elsif C = 'a' or C = 'b' or C = 'c' or C = 'd' or C = 'e' or C = 'f' or C = 'g' or C = 'h' or C = 'i' or C = 'j' or C = 'k' or C = 'l' or C = 'm' or C = 'n' or C = 'o' or C = 'p' or C = 'q' or C = 'r' or C = 's' or C = 't' or C = 'u' or C = 'v' or C = 'w' or C = 'x' or C = 'y' or C = 'z' or C = 'A' or C = 'B' or C = 'C' or C = 'D' or C = 'E' or C = 'F' or C = 'G' or C = 'H' or C = 'I' or C = 'J' or C = 'K' or C = 'L' or C = 'M' or C = 'N' or C = 'O' or C = 'P' or C = 'Q' or C = 'R' or C = 'S' or C = 'T' or C = 'U' or C = 'V' or C = 'W' or C = 'X' or C = 'Y' or C = 'Z' then
	Classe := Lettre;
	elsif C = ',' or C = '?' or C = ';' or C = '.' or C = ':' or C = '!' then
	    Classe := Ponctuation;
	else
	    Classe := Autre;
	end if;
	

	-- Afficher la classe du caractÃ¨re
	Put_Line ("Classe : " & Classe);

end Classer_Caractere;
