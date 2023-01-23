-- with Ada.Text_IO;            use Ada.Text_IO;
with SDA_Exceptions;         use SDA_Exceptions;
--with Ada.Unchecked_Deallocation;


package body TH is

	--procedure Free is
		--new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => LCA_TH);


	procedure Initialiser(Sda: out T_TH) is
    begin
        for i in 1..Capacite loop
            Initialiser(Sda(i));
        end loop;
	end Initialiser;


    function Est_Vide (Sda : T_TH) return Boolean is
    v : Boolean;
    begin
        v := True;
        for i in 1..Capacite loop
            if Est_Vide(Sda(i)) = False then
                v := False;
            end if;
        end loop;
        return v;
	end;


    function Taille (Sda : in T_TH) return Integer is
        T : Integer;
    begin
        T := 0;
        for i in 1..Capacite loop
            T := T + Taille(Sda(i));
        end loop;
    return T;
	end Taille;


    procedure Enregistrer (Sda : in out T_TH ; Cle : in T_Cle ; Donnee : in T_Donnee) is
    begin
        Enregistrer(Sda(Fonction_de_hachage(Cle)), Cle, Donnee);
	end Enregistrer;


    function Cle_Presente (Sda : in T_TH ; Cle : in T_Cle) return Boolean is
    begin
        return Cle_Presente(Sda(Fonction_de_hachage(Cle)), Cle);
	end Cle_Presente;


	function La_Donnee (Sda : in T_TH ; Cle : in T_Cle) return T_Donnee is
    begin
        return La_Donnee(Sda(Fonction_de_hachage(Cle)), Cle);
	end La_Donnee;


    procedure Supprimer (Sda : in out T_TH ; Cle : in T_Cle) is
	begin
        Supprimer(Sda(Fonction_de_hachage(Cle)), Cle);
	end Supprimer;


    procedure Vider (Sda : in out T_TH) is
    begin
        for i in 1..Capacite loop
          Vider(Sda(i));
        end loop;
	end Vider;


	procedure Pour_Chaque (Sda : in T_TH) is
        procedure TH_Pour_chaque is new LCA_TH.Pour_Chaque(Traiter);
    begin
        for i in 1..Capacite loop
            TH_Pour_chaque(Sda(i));
        end loop;
	end Pour_Chaque;


end TH;
