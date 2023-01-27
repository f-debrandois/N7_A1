with Adresse_IP; use Adresse_IP;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

package Routage is

    type T_Table is limited private;

	-- Initialiser une Table.
	procedure Initialiser(Tab: out T_Table) with
		Post => Est_Vide (Tab);

	-- Est-ce qu'une Tab est vide ?
	function Est_Vide (Tab : T_Table) return Boolean;

	-- Obtenir le nombre d'éléments d'une table.
	function Taille (Tab : in T_Table) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (Tab);

	-- Enregistrer une adresse destination associée à un masque dans une table.
	procedure Enregistrer (Tab : in out T_Table ; Destination : in T_IP ; Masque :in T_IP ; Inter : in Unbounded_String) with
		Post =>(Trouver_Interface (Tab, Destination) = Inter)
				and  Taille (Tab) = Taille (Tab)'Old
				and  Taille (Tab) = Taille (Tab)'Old + 1;

	-- Obtenir l'interface associée à l'adresse ip d'un paquet
    function Trouver_Interface (Tab : in T_Table ; IP_Paquet : in T_IP) return Unbounded_String;

    -- Retourne le plus long masque de la table
    function Long_Masque (Tab : in T_Table ; IP_Paquet : in T_IP) return T_IP;

	-- Supprimer tous les éléments d'une table.
	procedure Vider (Tab : in out T_Table) with
		Post => Est_Vide (Tab);

	-- Traite les éléments d'une table
	generic
		with procedure Traiter (Destination : in T_IP; Masque: in T_IP; Inter : in Unbounded_String);
	procedure Pour_Chaque (Tab : in T_Table);

private
    type T_Cellule;

	type T_Table is access T_Cellule;

	type T_Cellule is
		record
			Destination : T_IP;
            Masque : T_IP;
            Inter : Unbounded_String;
			Suivant : T_Table;
		end record;
end Routage;
