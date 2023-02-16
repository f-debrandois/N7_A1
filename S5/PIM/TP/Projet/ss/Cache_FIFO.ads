-- Définition d'un cache selon politique fifo
with Adresse_IP; use Adresse_IP;
with Cache;     use Cache;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

package Cache_FIFO is

    Capacite : Integer := 10;

    -- Initialiser un cache.  Le cahce est vide.
    procedure Initialiser(Cache: out T_Cache; Capacite_Entree : in Integer) with
            Post => Est_Vide (Cache);

    -- Est-ce qu'un Cache est vide ?
    function Est_Vide (Cache : T_Cache) return Boolean;

    -- Obtenir le nombre d'éléments d'une Cache.
    function Taille (Cache : in T_Cache) return Integer with
            Post => Taille'Result >= 0
            and (Taille'Result = 0) = Est_Vide (Cache);

     -- Verifier si un element est dans le cache ou pas
    function Est_Present(Cache : in T_Cache; IP_Paquet : in T_IP) return Boolean;

    -- Enregistrer une adresse destination associée à une masque dans une Cache.
    -- Si l'adresse est déjà présente dans la Cache, son masque est changé.
    procedure Enregistrer (Cache : in out T_Cache ; Destination : in T_IP ; Masque : in T_IP; Interf : in Unbounded_String) with
         post=>   Taille (Cache) = Taille (Cache)'Old
            and  Taille (Cache) = Taille (Cache)'Old + 1;

    -- Obtenir l'interface associée à une adresse ip d'un paquet
    function L_Interface (Cache : in out T_Cache ; IP_Paquet : in T_IP) return Unbounded_String;

    -- Supprimer tous les éléments d'une Cache.
    procedure Vider (Cache : in out T_Cache) with
            Post => Est_Vide (Cache);

    -- Supprimer du cache selon la politique de gestion de la commande
    procedure Supprimer_FIFO (Cache : in out T_Cache);

    -- Appliquer un traitement (Traiter) pour les elements du cache.
    generic
        with procedure Traiter (Destination : in T_IP; Masque: in T_IP; Interf : in Unbounded_String);
    procedure Pour_Chaque (Cache : in T_Cache);
end Cache_FIFO;
