-- Définition d'un cache selon politique fifo
with Adresse_IP; use Adresse_IP;
with Cache;     use Cache;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

package Cache_FIFO is

    Capacite : Integer := 10;

    -- Initialiser un cache.
    procedure Initialiser(Cache: out T_Cache; Capacite_Donnee : in Integer) with
            Post => Est_Vide (Cache);

    -- Est-ce que le cache est vide ?
    function Est_Vide (Cache : T_Cache) return Boolean;

    -- Obtenir le nombre d'éléments du cache.
    function Taille (Cache : in T_Cache) return Integer with
            Post => Taille'Result >= 0
            and (Taille'Result = 0) = Est_Vide (Cache);

     -- Vérifier si un élément est dans le cache ou pas.
    function Est_Present(Cache : in T_Cache; IP_Paquet : in T_IP) return Boolean;

    -- Enregistrer une adresse destination associée à un masque dans le cache.
    procedure Enregistrer (Cache : in out T_Cache ; Destination : in T_IP ; Masque : in T_IP; Inter : in Unbounded_String) with
         post=>   Taille (Cache) = Taille (Cache)'Old
            and  Taille (Cache) = Taille (Cache)'Old + 1;

    -- Obtenir l'interface associée à l'adresse IP d'un paquet
    function Trouver_Interface (Cache : in out T_Cache ; IP_Paquet : in T_IP) return Unbounded_String;

    -- Supprimer tous les éléments du cache.
    procedure Vider (Cache : in out T_Cache) with
            Post => Est_Vide (Cache);

    -- Supprimer des éléments du cache selon la politique retenue
    procedure Supprimer_FIFO (Cache : in out T_Cache);

    -- Traiter les éléments du cache
    generic
        with procedure Traiter (Destination : in T_IP; Masque: in T_IP; Inter : in Unbounded_String);
    procedure Pour_Chaque (Cache : in T_Cache);
end Cache_FIFO;
