-- Définition de structures de données associatives sous forme d'une liste
-- chaînée associative (LCA).
generic
	type T_IP is private;
	type T_Interface is private;

package PLinkedList is

	type LinkedList is private;

	-- type renvoyé lors des fonctions "Ligne"
	type T_Ligne is
	   record
		   dest : T_IP;
		   masque : T_IP;
		   sortie : T_Interface;
	   end record;

	-- Initialiser une LinkedList.  La LinkedList est vide.
	procedure Initialiser(Sda: out LinkedList) with
		Post => Est_Vide (Sda);


	-- Est-ce qu'une LinkedList est vide ?
	function Est_Vide (Sda : in LinkedList) return Boolean;


	-- Obtenir le nombre d'éléments d'une LinkedList.
	function Taille (Sda : in LinkedList) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (Sda);


	-- Obtenir l'élement suivant de la liste 
	function Suivant(Sda : in LinkedList) return LinkedList;


	-- Enregistrer une règle.
	procedure Enregistrer (Sda : in out LinkedList ; Ip_dest : T_IP; mask :T_IP; sortie : T_Interface);


	-- Supprimer la règle de l'indice i.
	procedure Supprimer (Sda : in out LinkedList ; Indice : in Integer) with
		Post =>  Taille (Sda) = Taille (Sda)'Old - 1; -- un élément de moins
	

	-- Supprimer tous les éléments d'une Sda.
	procedure Vider (Sda : in out LinkedList) with
		Post => Est_Vide (Sda);

	-- Obtenir la cellule i de la liste
	-- Utilisée pour obtenir la ligne i de la table ou du cache
	function Ligne(Sda : in LinkedList; indice : in Integer) return T_Ligne with
		Pre => indice>=1 and not Est_Vide(Sda) and indice<=Taille(Sda);

	-- Obtenir la premiere cellule de la liste
	-- Utilisée pour obtenir la premiere ligne de la table ou du cache
	function Ligne(Sda : in LinkedList) return T_Ligne; 
	--with
		-- Pre => indice>=1 and not Est_Vide(Sda) and i<=Taille(Sda);

	-- Affiche toutes les lignes de la liste
	generic
		with function To_String(ip : T_IP) return String;
		with function To_String(s : T_Interface) return String;
	procedure Afficher(Sda : in LinkedList);


private

	type T_Cell;

	type LinkedList is access T_Cell;

	type T_Cell is
	   record
		   dest : T_IP;
		   masque : T_IP;
		   sortie : T_Interface;
		   next : LinkedList;
	   end record;


end PLinkedList;
