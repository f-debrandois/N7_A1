with Ada.Strings.Unbounded;         use Ada.Strings.Unbounded;

-- Gestion des arguments de la ligne de commande

package CLI is

    -- Politique du Cache
    type T_Politique is (FIFO,LRU,LFU);


    -- Type qui sauvegarde l'ensemble des constantes
    type init_type is record
        Capacite : Integer := 10;
        Politique : T_Politique := FIFO;
        Stat_Mode : Boolean := True;
        Nom_Entree : Unbounded_String := To_Unbounded_String("table.txt");
        Nom_Paquet : Unbounded_String := To_Unbounded_String("paquets.txt");
        Nom_Sortie : Unbounded_String := To_Unbounded_String("resultats.txt");
    end record;


    -- Lecture des arguments de la ligne de commande
    function init_routeur return init_type;


    -- Procédure d'affichage des constantes pour debug
    procedure infos_constantes(list_constantes : in init_type);

end CLI;
