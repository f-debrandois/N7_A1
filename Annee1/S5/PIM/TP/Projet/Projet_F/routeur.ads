-- Opérations du routeur

with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

with Adresse_IP; use Adresse_IP;
with Routeur_Outils; use Routeur_Outils;

-- Définition d’un routeur consiste à utiliser une structure de données qui conserve toutes les routes.
-- Le principe est de pouvoir retrouver l’interface de sortie à utiliser en fonction de la destination
        --(l’adresse IP contenue dans le paquet à router).

-- la table de routage consiste à stocker toutes les routes sous forme des listes chaînées.


package Routeur is

	-- Initialiser une Table.  La Table est vide.
    procedure Initialiser_Table(Table: in out T_Table);

    procedure Initialiser_Paquet(Paquet: in out T_Paquet);

    -- Enregistrer une adresse destination associée à une masque dans une Table.
    -- Si l'adresse est déjà présente dans la Table, son masque est changé.
    procedure Enregistrer_Table (Table : in out T_Table ; Destination : in T_IP ; Masque :in T_IP ; Interf : in Unbounded_String) with
		Post =>(Find_Interface (Table, Destination) = Interf)   -- interface insérée
				and  Taille (Table) = Taille (Table)'Old
				and  Taille (Table) = Taille (Table)'Old + 1;

    -- Enregistrer une ligne associée au fichier paquet à une liste chainée Paquet
    procedure Enregistrer_Paquet (Paquet : in out T_Paquet ; Ligne : in Unbounded_String);


    -- Traiter la liste Paquet
    procedure Traiter_Paquet (Valeur_Initiale : in Valeur_Entree ; Paquet : in out T_Paquet; Table : in T_Table; Sortie : out T_Sortie);




	-- Obtenir le nombre d'éléments d'une Table.
	function Taille (Table : in T_Table) return Integer;


	-- Obtenir l'interface associée à une adresse ip d'un paquet
	-- Exception : Adresse_Absente_Exception si Destination n'est pas utilisée dans la Tab
    function Find_Interface (Table : in T_Table ; IP_Paquet : in T_IP) return Unbounded_String;

    -- retourne le plus long masque de la table
    function Long_Masque (Table : in T_Table ; IP_Paquet : in T_IP) return T_IP;

	-- Supprimer tous les éléments d'une Tab.
	procedure Vider (Table : in out T_Table);


	-- Appliquer un traitement (Traiter) pour les elements d'une table.
	generic
		with procedure Traiter (Destination : in T_IP; Masque: in T_IP; Interf : in Unbounded_String);
	procedure Pour_Chaque (Table : in T_Table);


end Routeur;
