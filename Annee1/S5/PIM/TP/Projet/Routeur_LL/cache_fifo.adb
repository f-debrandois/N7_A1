with Ada.Unchecked_Deallocation;
with Adresse_IP; use Adresse_IP;
with Cache;     use Cache;


package body Cache_FIFO is
    
    procedure Free is
            new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_Cache);

    procedure Initialiser(Cache: out T_Cache; Capacite_Donnee : in Integer) is
    begin
        Cache := Null;
        Capacite := Capacite_Donnee;
    end Initialiser;

    function Est_Vide (Cache : T_Cache) return Boolean is
    begin
        return Cache = Null;
    end Est_Vide;

    function Taille (Cache : in T_Cache) return Integer is
    begin
        if Cache = Null then
            return 0;
        else
            return 1 + Taille (Cache.all.Suivant);
        end if;
    end Taille;

    function Est_Present(Cache : in T_Cache; IP_Paquet : in T_IP) return Boolean is
    begin
        if Est_Vide(Cache) then
            return false;
        elsif (IP_Paquet and Cache.all.Masque) = Cache.all.Destination then
            return true;
        else
            return Est_Present(Cache.all.Suivant, IP_Paquet);
        end if;
    end Est_Present;

    procedure Enregistrer (Cache : in out T_Cache ; Destination : in T_IP ; Masque : in T_IP; Inter : in Unbounded_String) is
    begin
        if Capacite > Taille(Cache) then
            if Cache = Null then
                Cache:= new T_Cellule'(Destination, Masque, Inter, Null, Cache, 0);
            else
                Enregistrer(Cache.all.Suivant, Destination, Masque, Inter);
            end if;
        else
            Supprimer_FIFO(Cache);
            Enregistrer(Cache.all.Suivant, Destination, Masque, Inter);
        end if;
    end Enregistrer;

    function Trouver_Interface (Cache : in out T_Cache ; IP_Paquet : in T_IP) return Unbounded_String is
        Curseur : T_Cache;
        Inter : Unbounded_String;
        Max : T_IP := 0;
    begin
        Curseur := Cache;
        while Curseur /= Null loop
            if (IP_Paquet and Curseur.all.Masque) = Curseur.all.Destination then
                if Curseur.all.Masque > Max then
                    Max := Curseur.all.Masque;
                    Inter := Curseur.all.Inter;
                end if;
            end if;
            Curseur := Curseur.all.Suivant;
        end loop;
        return Inter;
    end Trouver_Interface;

    procedure Vider (Cache : in out T_Cache) is
    begin
        if Cache /= Null then
            Vider(Cache.all.Suivant);
            Free(Cache);
        end if;
    end Vider;

    procedure Supprimer_FIFO (Cache : in out T_Cache) is
        Curseur : T_Cache;
    begin
        Curseur := Cache;
        if Cache /= Null then
            Cache := Cache.all.Suivant;
            Free(Curseur);
        end if;
    end Supprimer_FIFO;

    procedure Pour_Chaque (Cache : in T_Cache) is
        Curseur : T_Cache;
    begin
        Curseur := Cache;
        while Curseur /= Null loop
            begin
                Traiter(Curseur.all.Destination, Curseur.all.Masque, Curseur.all.Inter);
            exception
                when others => null;
            end;
            Curseur := Curseur.all.Suivant;
        end loop;
    end Pour_Chaque;
end Cache_FIFO;
