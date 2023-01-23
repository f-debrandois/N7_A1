with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings;               use Ada.Strings;	-- pour Both utilisé par Trim
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;

-- Opérations liées à la table

package body OP_Table is

    procedure Afficher_table is
        new p.Afficher(IP.To_String,Ada.Strings.Unbounded.To_String);

    -- Initialiser une table.  La table est vide.
	procedure Initialiser(table: out table_type) is
    begin
        Initialiser(LinkedList(table));
    end Initialiser;


	-- Est-ce qu'une table est vide ?
	function Est_Vide (table : in table_type) return Boolean is
    begin
        return Est_Vide(LinkedList(table));
    end Est_Vide;


	-- Obtenir le nombre d'éléments d'une table.
	function Taille (table : in table_type) return Integer is
    begin
        return Taille(LinkedList(table));
    end Taille;


	-- Obtenir l'élement suivant de la table 
	function Suivant(table : in table_type) return table_type is
    begin
        return table_type(Suivant(LinkedList(table)));
    end Suivant;


	-- Enregistrer une règle.
	procedure Enregistrer (table : in out table_type ; Ip_dest : T_IP; mask :T_IP; sortie : Unbounded_String) is
    begin
        Enregistrer(LinkedList(table),Ip_dest,mask,sortie);
    end Enregistrer;


	-- Supprimer la règle de l'indice i.
	procedure Supprimer (table : in out table_type ; Indice : in Integer) is
    begin
        Supprimer(LinkedList(table), Indice);
    end Supprimer;
	

	-- Supprimer tous les éléments d'une table.
	procedure Vider (table : in out table_type) is
    begin
        Vider(LinkedList(table));
    end Vider;

	-- Obtenir la ligne i de la talbe
	function Ligne(table : in table_type; indice : in Integer) return ligne_type is
        o : ligne_type;
        s : T_Ligne;
    begin
        s := Ligne(LinkedList(table),indice);
        o.dest := s.dest;
        o.masque := s.masque;
        o.sortie := s.sortie;
        return o;
    end Ligne;

	-- Obtenir la premiere ligne de la table
	function Ligne(table : in table_type) return ligne_type is
        o : ligne_type;
        s : T_Ligne;
    begin
        s := Ligne(LinkedList(table));
        o.dest := s.dest;
        o.masque := s.masque;
        o.sortie := s.sortie;
        return o;
    end Ligne;

	-- Affiche toutes les lignes de la liste
	procedure Afficher(table : in table_type) is
    begin
        Afficher_table(LinkedList(table));
    end Afficher;

    -- Génère la table via le fichier correspondant
    procedure make_table(table : in out table_type; table_liste : in List) is

        -- Supprimme les espaces répétés
        procedure delete_useless_spaces(t : in out Unbounded_String) is
            i: Integer := 1;
            last : Character := '0';
        begin
            while i <= Length(t) loop
                if Element(t,i)=' ' and then last=' ' then
                    Delete(t,i,i);
                else
                    last := Element(t,i);
                    i:=i+1;
                end if;
            end loop;
        end delete_useless_spaces;


        line, ip_dest, mask, interfac : Unbounded_String;
        start, i , j: Integer;
        P : File := table_liste;
    begin

        while P.all.next /= null loop
            line := P.all.ligne;
            P := P.all.next;
            start := 1;
            i := 1;
            j := 1;
            delete_useless_spaces(line);
            while i<=Length(line) loop
                if Element(line,i)=' ' then
                    case j is
                        when 1 => ip_dest := Unbounded_Slice(line,start,i-1); start := i+1; j:=2;
                        when 2 => mask := Unbounded_Slice(line,start,i-1); start := i+1;
                        when others => null;
                    end case;
                end if;
                i:=i+1;
            end loop;
            interfac := Unbounded_Slice(line,start,i-1);
            Enregistrer(table,To_IP(To_String(ip_dest)),To_IP(To_String(mask)),interfac);
        end loop;

    end make_table;

end OP_Table;
