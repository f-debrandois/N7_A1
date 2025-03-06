with Adresse_IP; use Adresse_IP;
with Cache_FIFO;
with Cache_LFU;
with Cache_LRU;
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;


package body Cache is

    -- Afficher la destination, le masque, l'interface
    procedure Afficher (dest : in T_IP; masque : in T_IP; interfac : in Unbounded_String )is
    begin
        Put_Line (Conversion_String(dest) & " "& Conversion_String(masque) & " " & interfac);
    end Afficher;

    -- Afficher les tables du Cache FIFO
    procedure AfficherCacheFIFO is new Cache_FIFO.Pour_Chaque(Afficher);

    -- Afficher les tables du Cache LRU
    procedure AfficherCacheLRU is new Cache_LRU.Pour_Chaque(Afficher);

    -- Afficher les tables du Cache LFU
    procedure AfficherCacheLFU is new Cache_LFU.Pour_Chaque(Afficher);

    procedure AfficherCache(Cache : in T_Cache; politique : in T_Politique) is
    begin
        case politique is
            when FIFO =>
                AfficherCacheFIFO(Cache);
            when LRU =>
                AfficherCacheLRU(Cache);
            when LFU =>
                AfficherCacheLFU(Cache);
            when others => null;
        end case;
    end AfficherCache;


    -- Verifier si un element est dans le cache ou pas
    function Est_Present(Cache : in T_Cache; ippaquet : in T_IP; politique : T_Politique) return Boolean is
    begin
        case politique is
            when FIFO => return Cache_FIFO.Est_Present(Cache, ippaquet);
            when LRU => return Cache_LRU.Est_Present(Cache, ippaquet);
            when LFU => return Cache_LFU.Est_Present(Cache, ippaquet);
            when others => return false;
        end case;
    end Est_Present;

    function Trouver_Interface (Cache : in out T_Cache ; ippaquet : in T_IP; politique : in T_Politique) return Unbounded_String is
    begin
        case politique is
            when FIFO => return Cache_FIFO.Trouver_Interface(Cache, ippaquet);
            when LRU => return Cache_LRU.Trouver_Interface(Cache, ippaquet);
            when LFU => return Cache_LFU.Trouver_Interface(Cache, ippaquet);
            when others => return To_Unbounded_String("");
        end case;
    end Trouver_Interface;

    procedure Vider (Cache : in out T_Cache; politique : in T_Politique) is
    begin
         case politique is
            when FIFO => Cache_FIFO.Vider(Cache);
            when LRU => Cache_LRU.Vider(Cache);
            when LFU => Cache_LFU.Vider(Cache);
            when others => null;
        end case;
    end Vider;

    procedure Initialiser( Cache : out T_Cache; CapaciteEntree : in Integer; politique : in T_Politique) is
    begin
        case politique is
            when FIFO => Cache_FIFO.Initialiser(Cache, CapaciteEntree);
            when LRU => Cache_LRU.Initialiser(Cache, CapaciteEntree);
            when LFU => Cache_LFU.Initialiser(Cache, CapaciteEntree);
            when others => null;
        end case;

    end Initialiser;

    procedure Enregistrer(Cache: in out T_Cache;  dest: T_IP; masque: T_IP; Inter: Unbounded_String; Politique: T_Politique) is
    begin
        case politique is
            when FIFO => Cache_FIFO.Enregistrer(Cache, dest, masque, Inter);
            when LRU => Cache_LRU.Enregistrer(Cache, dest, masque, Inter);
            when LFU => Cache_LFU.Enregistrer(Cache, dest, masque, Inter);
            when others => null;
        end case;
    end Enregistrer;
end Cache;
