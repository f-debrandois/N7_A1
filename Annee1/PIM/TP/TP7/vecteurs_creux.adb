with Ada.Text_IO;                 use Ada.Text_IO;
with Ada.Integer_Text_IO;         use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;           use Ada.Float_Text_IO;
with Ada.Unchecked_Deallocation;

package body Vecteurs_Creux is


	procedure Free is
		new Ada.Unchecked_Deallocation (T_Cellule, T_Vecteur_Creux);


	procedure Initialiser (V : out T_Vecteur_Creux) is
	begin
        V := null;
	end Initialiser;


	procedure Detruire (V: in out T_Vecteur_Creux) is
	begin
		free(V);
	end Detruire;


	function Est_Nul (V : in T_Vecteur_Creux) return Boolean is
	begin
        return V = null;
	end Est_Nul;


    function Composante_Recursif (V : in T_Vecteur_Creux ; Indice : in Integer) return Float is
    begin
        if V = null then
            return 0.0;
        elsif V.all.Indice = Indice then
            return V.all.Valeur;
        elsif V.all.Indice > Indice then
            return 0.0;
        else
            return Composante_Recursif(V.all.Suivant, Indice);
        end if;
	end Composante_Recursif;


	function Composante_Iteratif (V : in T_Vecteur_Creux ; Indice : in Integer) return Float is
        Vp : T_Vecteur_Creux := V;
	begin
        while (Vp /= null and then Vp.all.Indice < Indice ) loop
            Vp := Vp.all.Suivant;
        end loop;

        if Vp = null then
            return 0.0;
        elsif Vp.all.Indice > Indice then
            return 0.0;
        else
            return Vp.all.Valeur;
        end if
	end Composante_Iteratif;


	procedure Modifier (V : in out T_Vecteur_Creux ;
				       Indice : in Integer ;
                     Valeur : in Float ) is
    begin
        if V = null or else V.all.Indice > Indice then
            if Valeur /= 0.0 then
                -- Création d'une cellule
                V.all.suivant = new T_Cellule;
            else
                null;
            end if;

        elsif V /= null and then V.all.Indice = Indice then



        if V = null then
            if Valeur /= 0.0 then
            V.all.Indice = Indice;
            V.all.Valeur = Valeur;
        else
            if Valeur /= 0.0 then
                while (Vp /= null and then Vp.all.Indice < Indice ) loop
                    Vp := Vp.all.Suivant;
                end loop;
                if Vp = null then
                    Vp.all.Indice = Indice;
                elsif Vp.all.Indice = Indice then
                    Vp.all.Valeur = Valeur;
                elsif Vp.all.Indice > Indice;


	end Modifier;


	function Sont_Egaux_Recursif (V1, V2 : in T_Vecteur_Creux) return Boolean is
	begin
		return False;	-- TODO : à changer
	end Sont_Egaux_Recursif;


	function Sont_Egaux_Iteratif (V1, V2 : in T_Vecteur_Creux) return Boolean is
	begin
		return False;	-- TODO : à changer
	end Sont_Egaux_Iteratif;


	procedure Additionner (V1 : in out T_Vecteur_Creux; V2 : in T_Vecteur_Creux) is
	begin
		Null;	-- TODO : à changer
	end Additionner;


	function Norme2 (V : in T_Vecteur_Creux) return Float is
	begin
		return 0.0;	-- TODO : à changer
	end Norme2;


	Function Produit_Scalaire (V1, V2: in T_Vecteur_Creux) return Float is
	begin
		return 0.0;	-- TODO : à changer
	end Produit_Scalaire;


	procedure Afficher (V : T_Vecteur_Creux) is
	begin
		if V = Null then
			Put ("--E");
		else
			-- Afficher la composante V.all
			Put ("-->[ ");
			Put (V.all.Indice, 0);
			Put (" | ");
			Put (V.all.Valeur, Fore => 0, Aft => 1, Exp => 0);
			Put (" ]");

			-- Afficher les autres composantes
			Afficher (V.all.Suivant);
		end if;
	end Afficher;


	function Nombre_Composantes_Non_Nulles (V: in T_Vecteur_Creux) return Integer is
	begin
		if V = Null then
			return 0;
		else
			return 1 + Nombre_Composantes_Non_Nulles (V.all.Suivant);
		end if;
	end Nombre_Composantes_Non_Nulles;


end Vecteurs_Creux;
