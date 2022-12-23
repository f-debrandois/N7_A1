with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with SDA_Exceptions; 		use SDA_Exceptions;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with TH;


procedure TH_sujet is

    Capacite : constant Positive := 11;

    function Fonction_de_hachage (Cle : in Unbounded_String) return Natural is
    begin
      return ((Length(Cle) mod Capacite)+1);
    end Fonction_de_hachage;


    package TH_String_Integer is
      new TH (T_Cle => Unbounded_String, T_Donnee => Integer,Capacite =>Capacite,Fonction_de_hachage => Fonction_de_hachage);
    use TH_String_Integer;


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
    c3 : constant  Unbounded_String := To_Unbounded_String ("trois");
    c4 : constant  Unbounded_String := To_Unbounded_String ("quatre");
    c5 : constant  Unbounded_String := To_Unbounded_String ("cinq");
    c99 : constant  Unbounded_String := To_Unbounded_String ("quatre-vingt-dix-neuf");
    c21 : constant  Unbounded_String := To_Unbounded_String ("vingt-et-un");
    T : T_TH;

begin
    Initialiser(T);
    Enregistrer(T, c1, 1);
    Enregistrer(T, c2, 2);
    Enregistrer(T, c3, 3);
    Enregistrer(T, c4, 4);
    Enregistrer(T, c5, 5);
    Enregistrer(T, c99, 99);
    Enregistrer(T, c21, 21);
    Afficher(T);
    Vider(T);
end TH_sujet;
