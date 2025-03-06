with Ada.Unchecked_Deallocation;
with Adresse_IP; use Adresse_IP;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

package body Routage is

	procedure Free is
            new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_Table);

	procedure Initialiser(Tab: out T_Table) is
	begin
        Tab:=Null;
	end Initialiser;

	function Est_Vide (Tab : T_Table) return Boolean is
	begin
       return Tab = Null;
	end Est_Vide;

	function Taille (Tab : in T_Table) return Integer is
	begin
        -- Fonction récursive
        if Tab = Null then
            return 0;
        else
            return 1 + Taille (Tab.all.Suivant);
        end if;
	end Taille;

    procedure Enregistrer (Tab : in out T_Table ; Destination : in T_IP ; Masque : in T_IP; Inter : in Unbounded_String) is
    begin
         if Tab = Null then
            Tab:= new T_Cellule'(Destination, Masque, Inter, Tab);
	    else
	        Enregistrer(Tab.all.Suivant, Destination, Masque, Inter);
	    end if;
	end Enregistrer;

    function Trouver_Interface (Tab : in T_Table ; IP_Paquet : in T_IP) return Unbounded_String is
        Noeud : T_Table;
        Inter : Unbounded_String;
        Max : T_IP;
    begin
        Max:=0;
        Noeud := Tab;
        while Noeud /= Null loop
            if (IP_Paquet and Noeud.all.Masque) = Noeud.all.Destination then
                if Noeud.all.Masque > Max then
                    Max := noeud.all.Masque;
                    Inter := Noeud.all.Inter;
                end if;
            end if;
            Noeud := Noeud.all.Suivant;
        end loop;
        return Inter;
    end Trouver_Interface;

    -- retourne le plus long masque de la table
    function Long_Masque (Tab : in T_Table ; IP_Paquet : in T_IP) return T_IP is
        Noeud : T_Table;
        Max : T_IP;
    begin
        Max := 0;
        Noeud := Tab;
        while Noeud /= Null loop
            if Noeud.all.Masque > Max then
                Max := Noeud.all.Masque;
            end if;
            Noeud := Noeud.all.Suivant;
        end loop;
        return Max;
    end Long_Masque;

	procedure Vider (Tab : in out T_Table) is
	begin
        if Tab /= Null then
		    Vider(Tab.all.Suivant);
            Free(Tab);
        end if;
	end Vider;

    procedure Pour_Chaque (Tab : in T_Table) is
        Noeud: T_Table;
	begin
        Noeud := Tab;
        while Noeud /= Null loop
            begin
                Traiter(Noeud.all.Destination, Noeud.all.Masque, Noeud.all.Inter);
            exception
                when others => null;
            end;
			Noeud := Noeud.all.Suivant;
	   end loop;
    end Pour_Chaque;
end Routage;
