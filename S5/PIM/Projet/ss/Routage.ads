-- Définition d’un routeur consiste à utiliser une structure de données qui conserve toutes les routes.
-- Le principe est de pouvoir retrouver l’interface de sortie à utiliser en fonction de la destination
        --(l’adresse IP contenue dans le paquet à router).

-- la table de routage consiste à stocker toutes les routes sous forme des listes chaînées.
with Adresse_IP; use Adresse_IP;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

package Routage is

    type T_Table is limited private;

	-- Initialiser une Table.  La Table est vide.
	procedure Initialiser(Tab: out T_Table) with
		Post => Est_Vide (Tab);

	-- Est-ce qu'une Tab est vide ?
	function Est_Vide (Tab : T_Table) return Boolean;

	-- Obtenir le nombre d'éléments d'une Tab.
	function Taille (Tab : in T_Table) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (Tab);

	-- Enregistrer une adresse destination associée à une masque dans une Tab.
	-- Si l'adresse est déjà présente dans la Tab, son masque est changé.
	procedure Enregistrer (Tab : in out T_Table ; Destination : in T_IP ; Masque :in T_IP ; Interf : in Unbounded_String) with
		Post =>(L_Interface (Tab, Destination) = Interf)   -- interface insérée
				and  Taille (Tab) = Taille (Tab)'Old
				and  Taille (Tab) = Taille (Tab)'Old + 1;

	-- Obtenir l'interface associée à une adresse ip d'un paquet
	-- Exception : Adresse_Absente_Exception si Destination n'est pas utilisée dans la Tab
    function L_Interface (Tab : in T_Table ; IP_Paquet : in T_IP) return Unbounded_String;

    -- retourne le plus long masque de la table
    function Long_Masque (Tab : in T_Table ; IP_Paquet : in T_IP) return T_IP;

	-- Supprimer tous les éléments d'une Tab.
	procedure Vider (Tab : in out T_Table) with
		Post => Est_Vide (Tab);

	-- Appliquer un traitement (Traiter) pour les elements d'une table.
	generic
		with procedure Traiter (Destination : in T_IP; Masque: in T_IP; Interf : in Unbounded_String);
	procedure Pour_Chaque (Tab : in T_Table);

private
    type T_Cellule;

	type T_Table is access T_Cellule;

	type T_Cellule is
		record
			Destination : T_IP;
            Masque : T_IP;
            Interf : Unbounded_String;
			Suivant : T_Table;
		end record;
end Routage;
