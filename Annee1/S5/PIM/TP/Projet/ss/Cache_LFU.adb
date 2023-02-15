with Ada.Unchecked_Deallocation;
with Adresse_IP; use Adresse_IP;
with Cache;     use Cache;

package body Cache_LFU is

    procedure Free is
            new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_Cache);

    procedure Initialiser(Cache: out T_Cache; Capacite_Entree : in Integer) is
    begin
        Cache := Null;
        Capacite := Capacite_Entree;
    end Initialiser;

    function Est_Vide (Cache : T_Cache) return Boolean is
    begin
        return Cache = Null;
    end Est_Vide;

    function Taille (Cache : in T_Cache) return Integer is
    begin
        -- Fonction récursive
        if Cache = Null then
            return 0;
        else
            return 1 + Taille(Cache.all.Suivant);
        end if;
    end Taille;

    function Est_Present(Cache : in T_Cache; IP_Paquet : in T_IP) return Boolean is
    begin
        -- 127.0.O.O 255.0.0.0
        -- (1) -> (2) -> (3)
        --       Cache
        if Est_Vide(Cache) then
            return false;
        elsif (IP_Paquet and Cache.all.Masque) = Cache.all.Destination then
            return true;
        else
            return Est_Present(Cache.all.Suivant, IP_Paquet);
        end if;
    end Est_Present;


    procedure Enregistrer(Cache : in out T_Cache ; Destination : in T_IP ; Masque : in T_IP; Interf : in Unbounded_String) is
        Cellule : T_Cache;
    begin
        -- (1) -> (2) -> (3)
        -- (1) -> (2) -> null
        -- file : file_g file_d
        -- (2) -> (1) -> null
        --        Tab
        -- (1) -> null
        -- (2) -> (1) -> null
        --        Tab
        -- (1).sui= null
        --(1)
        -- cellule
        -- (1) <- (2) -> (3)
        --         Tab
        --         curseur

        -- (2) -> (3)
        -- Tab
        -- cursuer           cellule (1

        --(1) -> (2) -> (3)
        -- Tab
        -- cellule -> (1) -> (2) -> null
        --            Tab
        -- Tab
        -- inserer (3)
        -- eliminer le moins utilise
        if Capacite > Taille(Cache) then
            Cellule := new T_Cellule'(Destination, Masque, Interf, Null, Cache, 0);
            if Cache /= null then
                Cache.all.Precedent := Cellule;
            end if;
            Cache := Cellule;
        else
            Supprimer_LFU(Cache);
            Cellule := new T_Cellule'(Destination, Masque, Interf, Null, Cache, 0);
            Cache.all.Precedent := Cellule;
            Cache := Cellule;
        end if;
    end Enregistrer;


   --  (0) -> (1) -> (3) -> (5)
    --        Tab                      curesuer => (0) -> (5)
    -- l_interface (0)
    -- (0) -> (1) -> (5)
    -- (0) -> (1)
    -- (3) -> (0)
    function L_Interface (Cache : in out T_Cache ; IP_Paquet : in T_IP) return Unbounded_String is
        Noeud, Curseur : T_Cache;
        Interf : Unbounded_String;
        Max : T_IP := 0;
    begin
        Curseur := Cache;
        while Curseur /= Null loop
            if (IP_Paquet and Curseur.all.Masque) = Curseur.all.Destination then
                if Curseur.all.Masque > Max then
                    Max := Curseur.all.Masque;
                    Interf := Curseur.all.interf;
                    Noeud := Curseur;
                end if;
            end if;
            Curseur := Curseur.all.Suivant;
        end loop;

        if Noeud /= Null then
            Noeud.all.Utilisation := Noeud.all.Utilisation + 1;
        end if;
        return interf;
    end L_Interface;


    procedure Vider (Cache : in out T_Cache) is
    begin
        if Cache /= Null then
            Vider(Cache.all.Suivant);
            Free(Cache);
        end if;
    end Vider;

    -- (1,0) -> (0,0) -> (5,0)
    -- l_interface (0)
    -- (1,1) -> (0,0) -> (5,1)
    -- (0) -> (1) -> (5)
    -- (0) -> (1)
    -- (3) -> (0)

    procedure Supprimer_LFU (Cache : in out T_Cache) is
        Curseur, Precedent, Suivant, Noeud : T_Cache;
        Min : Integer := Integer'Last;
    begin
        --   (1) ->  null
        --          curseur
        --   Tab = null;
        -- min = 0
        -- (1,1) -> (0,2) -> (3,2)
        -- curseur

        -- enumeration commande (table, cache, stat, route(ip))
        -- creer une liste chainee (a partir du fichier )
        -- interface utilisateur et manipulation de fichier (lecture ecriture)
        --

        -- comment calculer les stats ?
        --
        -- (1,1) -> (3,0)-> null
        -- Tab
        -- curseur
        -- elt
        --          curseur
        --            elt
        -- (1,1) -> null

        if not Est_Vide(Cache) then
            Curseur := Cache;
            Noeud := Cache;
            while Curseur /= Null loop
                if Curseur.all.Utilisation <= Min then
                    Min := Curseur.all.Utilisation;
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
                Traiter(Noeud.all.Destination, Noeud.all.Masque, Noeud.all.Interf);
            exception
                when others => null;
            end;
            Noeud := Noeud.all.Suivant;
        end loop;
    end Pour_Chaque;
end Cache_LFU;
