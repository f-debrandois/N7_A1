with Adresse_IP; use Adresse_IP;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

package Cache is

    type T_Politique is (FIFO, LRU, LFU);

    type T_Cellule;

    type T_Cache is access T_Cellule;

    type T_Cellule is
        record
            Destination : T_IP;
            Masque : T_IP;
            Interf : Unbounded_String;
            Precedent : T_Cache;
            Suivant : T_Cache;
            Utilisation : Integer;
        end record;

    -- Initialiser le cache selon la politique consideree
    procedure Initialiser( Cache : out T_Cache; CapaciteEntree : in Integer; politique : in T_Politique);

    -- Les affichages du cache selon la politique consideree
    procedure AfficherCache(Cache : in T_Cache; politique : in T_Politique);

     -- Verifier si un element est dans le cache ou pas
    function Est_Present(Cache : in T_Cache; ippaquet : in T_IP; politique : T_Politique) return Boolean ;

    -- retourne l'interface selon la politique du cache
    function L_Interface (Cache : in out T_Cache ; ippaquet : in T_IP; politique : in T_Politique) return Unbounded_String;

    -- Vider le cache selon la politique consideree
    procedure Vider (Cache : in out T_Cache; politique : in T_Politique);

    -- Ajouter un élément au cache selon la politique consideree
    procedure Enregistrer(Cache: in out T_Cache;  dest: T_IP; masque: T_IP; interf: Unbounded_String; Politique: T_Politique);
end Cache;
