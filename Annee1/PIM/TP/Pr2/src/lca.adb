-- with Ada.Text_IO;            use Ada.Text_IO;
with SDA_Exceptions;         use SDA_Exceptions;
with Ada.Unchecked_Deallocation;

package body LCA is

	procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_LCA);


	procedure Initialiser(Sda: out T_LCA) is
	begin
		Sda := null;
	end Initialiser;


	function Est_Vide (Sda : T_LCA) return Boolean is
	begin
		return Sda = null;
	end;


    function Taille (Sda : in T_LCA) return Integer is
    begin
        if Est_Vide(Sda) then
            return 0;
        else
            return 1 + Taille(Sda.all.Suivant);
        end if;
	end Taille;


    procedure Enregistrer (Sda : in out T_LCA ; Cle : in T_Cle ; Donnee : in T_Donnee) is
    begin
        if Est_Vide(Sda) then -- Si la Sda est nulle, on enregistre une nouvelle donnee avec sa cle
            Sda := new T_Cellule'(Cle, Donnee, null);
        elsif Sda.all.Cle = Cle then -- Si la cle est deja presente dans la Sda
            Sda.all.Donnee := Donnee;
        else
            Enregistrer(Sda.all.Suivant, Cle, Donnee);
        end if;
	end Enregistrer;


    function Cle_Presente (Sda : in T_LCA ; Cle : in T_Cle) return Boolean is
    begin
        if Est_Vide(Sda) then -- Si la Sda est nulle, la cle n'est pas presente
            return False;
        elsif Sda.all.Cle = Cle then
            return True;
        else
            return Cle_Presente(Sda.all.Suivant, Cle);
        end if;
	end Cle_Presente;


	function La_Donnee (Sda : in T_LCA ; Cle : in T_Cle) return T_Donnee is
    begin
        if Est_Vide(Sda) then
            raise Cle_Absente_Exception; -- Levée d'exception : cle absente
        elsif Sda.all.Cle = Cle then
            return Sda.all.Donnee;
        else
            return La_Donnee(Sda.all.Suivant, Cle);
        end if;
	end La_Donnee;


    procedure Supprimer (Sda : in out T_LCA ; Cle : in T_Cle) is
        P : T_LCA;
	begin
        if Est_Vide(Sda) then
            raise Cle_Absente_Exception;
        elsif Sda.all.Cle = Cle then
            P := Sda.all.Suivant;
            Free(Sda);
            Sda := P;
        else
            Supprimer(Sda.all.Suivant, Cle);
        end if;
	end Supprimer;


    procedure Vider (Sda : in out T_LCA) is
        P : T_LCA;
    begin
        if Est_Vide(Sda) then
            null;
        else
            P := Sda.all.Suivant;
            Free(Sda);
            Sda := P;
            Vider(Sda);
        end if;
	end Vider;


	procedure Pour_Chaque (Sda : in T_LCA) is
	begin
        if Est_Vide(Sda) then
            null;
        else
            Traiter(Sda.all.Cle, Sda.all.Donnee);
            Pour_Chaque(Sda.all.Suivant);
        end if;
        Exception
            when Cle_Absente_Exception => Pour_Chaque(Sda.all.Suivant);
            when others => Pour_Chaque(Sda.all.Suivant);
	end Pour_Chaque;


end LCA;
