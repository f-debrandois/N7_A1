with Ada.Unchecked_Deallocation;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

with Adresse_IP; use Adresse_IP;
with Routeur_Outils; use Routeur_Outils;
with Routeur_simple; use Routeur_simple;
with Routeur_LL; use Routeur_LL;
with Routeur_LA; use Routeur_LA;


package body Routeur is

	procedure Free is
      new Ada.Unchecked_Deallocation (Object => T_Cell_Table, Name => T_Table);


    procedure Initialiser_Table(Table: in out T_Table) is
    begin
        Table:=null;
	end Initialiser_Table;


    procedure Initialiser_Paquet(Paquet: in out T_Paquet) is
    begin
        Paquet:=Null;
	end Initialiser_Paquet;


    procedure Enregistrer_Table (Table : in out T_Table ; Destination : in T_IP ; Masque :in T_IP ; Interf : in Unbounded_String) is
    begin
        if Table = null then
            Table:= new T_Cell_Table'(Destination, Masque, Interf, Table);
	    else
	        Enregistrer_Table(Table.all.Suivant, Destination, Masque, Interf);
	    end if;
    end Enregistrer_Table;


    -- Enregistrer une ligne associée au fichier paquet à une liste chainée Paquet
    procedure Enregistrer_Paquet (Paquet : in out T_Paquet ; Ligne : in Unbounded_String) is
        dest : T_IP;
    begin
        if Paquet = Null then
            case Ligne is

                when "table" | "cache" | "stat"  | "fin" =>
                    Paquet:= new T_Cell_Paquet'(True, Ligne, null, Paquet);

                when others =>
                    dest := To_Ip(Ligne);
                    Paquet:= new T_Cell_Paquet'(False, null, Ligne, Paquet);

            end case;
	    else
	        Enregistrer_Paquet(Paquet.all.Suivant,  Ligne);
        end if;
    end Enregistrer_Paquet;





    procedure Traiter_Paquet (Valeur_Initiale : in Valeur_Entree ; Paquet : in out T_Paquet; Table : in T_Table; Sortie : out T_Sortie) is
    begin
        case Valeur_Initiale.Type_Routeur is

            when  Simple =>
                Traitement_simple(Valeur_Initiale, Paquet,Table, Sortie);

            when LL =>
                Traitement_LL(Valeur_Initiale, Paquet,Table, Sortie);

            when LA =>
                Traitement_LA(Valeur_Initiale, Paquet,Table, Sortie);

            when others =>
                null;
        end case;
    end Traiter_Paquet;




	function Taille (Table : in T_Table) return Integer is
	begin
        -- Fonction récursive
        if Table = Null then
            return 0;
        else
            return 1 + Taille (Table.all.Suivant);
        end if;
	end Taille;


    function Find_Interface (Table : in T_Table ; IP_Paquet : in T_IP) return Unbounded_String is
        Noeud : T_Table;
        Interf : Unbounded_String;
        Max : T_IP;
    begin
        Max:=0;
        Noeud := Table;
        while Noeud /= Null loop
            if (IP_Paquet and Noeud.all.Masque) = Noeud.all.Destination then
                if Noeud.all.Masque > Max then
                    Max := noeud.all.Masque;
                    Interf := Noeud.all.Interf;
                end if;
            end if;
            Noeud := Noeud.all.Suivant;
        end loop;
        return Interf;
    end Find_Interface;

    -- retourne le plus long masque de la table
    function Long_Masque (Table : in T_Table ; IP_Paquet : in T_IP) return T_IP is
        Noeud : T_Table;
        Max : T_IP;
    begin
        Max := 0;
        Noeud := Table;
        while Noeud /= Null loop
            if Noeud.all.Masque > Max then
                Max := Noeud.all.Masque;
            end if;
            Noeud := Noeud.all.Suivant;
        end loop;
        return Max;
    end Long_Masque;

	procedure Vider (Table : in out T_Table) is
	begin
        if Table /= Null then
		    Vider(Table.all.Suivant);
            Free(Table);
        end if;
	end Vider;

    procedure Pour_Chaque (Table : in T_Table) is
        Noeud: T_Table;
	begin
        Noeud := Table;
        while Noeud /= Null loop
            begin
                Traiter(Noeud.all.Destination, Noeud.all.Masque, Noeud.all.Interf);
            exception
                when others => null;
            end;
			Noeud := Noeud.all.Suivant;
	   end loop;
    end Pour_Chaque;
end Routeur;
