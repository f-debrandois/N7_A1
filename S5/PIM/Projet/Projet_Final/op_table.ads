with IP;        use IP;
with PLinkedList;
with Ada.Strings.Unbounded;         use Ada.Strings.Unbounded;

-- Opérations liées à la table

package OP_Table is

    type table_type is private;

    -- type renvoyé lors des fonctions "Ligne"
	type ligne_type is
	   record
		   dest : T_IP;
		   masque : T_IP;
		   sortie : Unbounded_String;
	   end record;

    -- Initialiser une table.  La table est vide.
	procedure Initialiser(table: out table_type) with
		Post => Est_Vide (table);


	-- Est-ce qu'une table est vide ?
	function Est_Vide (table : in table_type) return Boolean;


	-- Obtenir le nombre d'éléments d'une table.
	function Taille (table : in table_type) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (table);


	-- Obtenir l'élement suivant de la table 
	function Suivant(table : in table_type) return table_type;


	-- Enregistrer une règle.
	procedure Enregistrer (table : in out table_type ; Ip_dest : T_IP; mask :T_IP; sortie : Unbounded_String);


	-- Supprimer la règle de l'indice i.
	procedure Supprimer (table : in out table_type ; Indice : in Integer) with
		Post =>  Taille (table) = Taille (table)'Old - 1; -- un élément de moins
	

	-- Supprimer tous les éléments d'une table.
	procedure Vider (table : in out table_type) with
		Post => Est_Vide (table);


	-- Obtenir la ligne i de la talbe
	function Ligne(table : in table_type; indice : in Integer) return ligne_type with
		Pre => indice>=1 and not Est_Vide(table) and indice<=Taille(table);


	-- Obtenir la premiere ligne de la table
	function Ligne(table : in table_type) return ligne_type; 


	-- Affiche toutes les lignes de la liste
	procedure Afficher(table : in table_type);


     -- Génère la table via le fichier correspondant
    procedure make_table(table : in out table_type; table_liste : in List);


private
    package p is new PLinkedList(T_IP,Unbounded_String);
    use p;

    type table_type is new p.LinkedList;

end OP_Table;
