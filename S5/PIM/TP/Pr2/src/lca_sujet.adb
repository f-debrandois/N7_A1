with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with SDA_Exceptions; 		use SDA_Exceptions;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with LCA;


procedure LCA_sujet is

    package LCA_String_Integer is
      new LCA (T_Cle => Unbounded_String, T_Donnee => Integer);
    use LCA_String_Integer;


	-- Retourner une chaîne avec des guillemets autour de S
	function Avec_Guillemets (S: Unbounded_String) return String is
	begin
		return '"' & To_String (S) & '"';
	end;


	-- Afficher une Unbounded_String et un entier.
	procedure Afficher (S : in Unbounded_String; N: in Integer) is
	begin
		Put (Avec_Guillemets (S));
		Put (" : ");
		Put (N, 1);
		New_Line;
	end Afficher;

	-- Afficher la Sda.
	procedure Afficher is
            new Pour_Chaque (Afficher);


    c1 : constant  Unbounded_String := To_Unbounded_String ("un");
    c2 : constant  Unbounded_String := To_Unbounded_String ("deux");
    L : T_LCA;


begin
    Initialiser(L);
    Enregistrer(L, c1, 1);
    Enregistrer(L, c2, 2);
    Afficher(L);
    Vider(L);
end LCA_sujet;
