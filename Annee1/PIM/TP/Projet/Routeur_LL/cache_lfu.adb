with Ada.Unchecked_Deallocation;
with Adresse_IP; use Adresse_IP;
with Cache;     use Cache;

package body Cache_LFU is

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
            return 1 + Taille(Cache.all.Suivant);
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

    procedure Enregistrer(Cache : in out T_Cache ; Destination : in T_IP ; Masque : in T_IP; Inter : in Unbounded_String) is
        Cellule : T_Cache;
    begin
        if Capacite > Taille(Cache) then
            Cellule := new T_Cellule'(Destination, Masque, Inter, Null, Cache, 0);
            if Cache /= null then
                Cache.all.Precedent := Cellule;
            end if;
            Cache := Cellule;
        else
            Supprimer_LFU(Cache);
            Cellule := new T_Cellule'(Destination, Masque, Inter, Null, Cache, 0);
            Cache.all.Precedent := Cellule;
            Cache := Cellule;
        end if;
    end Enregistrer;

    function Trouver_Interface (Cache : in out T_Cache ; IP_Paquet : in T_IP) return Unbounded_String is
        Noeud, Curseur : T_Cache;
        Inter : Unbounded_String;
        Max : T_IP := 0;
    begin
        Curseur := Cache;
        while Curseur /= Null loop
            if (IP_Paquet and Curseur.all.Masque) = Curseur.all.Destination then
                if Curseur.all.Masque > Max then
                    Max := Curseur.all.Masque;
                    Inter := Curseur.all.Inter;
                    Noeud := Curseur;
                end if;
            end if;
            Curseur := Curseur.all.Suivant;
        end loop;

        if Noeud /= Null then
            Noeud.all.Nb_Utilisation := Noeud.all.Nb_Utilisation + 1;
        end if;
        return Inter;
    end Trouver_Interface;

    procedure Vider (Cache : in out T_Cache) is
    begin
        if Cache /= Null then
            Vider(Cache.all.Suivant);
            Free(Cache);
        end if;
    end Vider;

    procedure Supprimer_LFU (Cache : in out T_Cache) is
        Curseur, Precedent, Suivant, Noeud : T_Cache;
        Min : Integer := Integer'Last;
    begin

        if not Est_Vide(Cache) then
            Curseur := Cache;
            Noeud := Cache;
            while Curseur /= Null loop
                if Curseur.all.Nb_Utilisation <= Min then
                    Min := Curseur.all.Nb_Utilisation;
                    Noeud := Curseur;
                end if;
                Curseur := Curseur.all.Suivant;
            end loop;

            if Noeud = Cache then
                Cache := Cache.all.Suivant;
                Cache.all.Precedent := Null;
                Free(Noeud);
            else 
                Precedent := Noeud.all.Precedent;
                Suivant := Noeud.all.Suivant;
                if Precedent /= null then
                    Precedent.all.Suivant := Suivant;
                end if;
                if Suivant /= null then
                    Suivant.all.Precedent := Precedent;
                end if;
                Free (Noeud);
            end if;
        end if;
    end Supprimer_LFU;

    procedure Pour_Chaque (Cache : in T_Cache) is
        Noeud: T_Cache;
    begin
        Noeud := Cache;
        while Noeud /= Null loop
            begin
                Traiter(Noeud.all.Destination, Noeud.all.Masque, Noeud.all.Inter);
            exception
                when others => null;
            end;
            Noeud := Noeud.all.Suivant;
        end loop;
    end Pour_Chaque;
end Cache_LFU;
