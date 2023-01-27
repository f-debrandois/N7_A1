with Ada.Unchecked_Deallocation;
with Adresse_IP; use Adresse_IP;
with Cache;     use Cache;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Text_IO;               use Ada.Text_IO;


package body Cache_LRU is

    procedure Free is
            new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_Cache);

    procedure Initialiser(Cache: out T_Cache; Capacite_Entree : in Integer) is
    begin
        Cache:= Null;
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
            return 1 + Taille (Cache.all.Suivant);
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

    procedure Enregistrer (Cache : in out T_Cache ; Destination : in T_IP ; Masque : in T_IP; Interf : in Unbounded_String) is
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
        -- cursuer           cellule (1)

        if Capacite > Taille(Cache) then
            Cellule := new T_Cellule'(Destination, Masque, Interf, Null, Cache, 0);
            if Cache /= Null then
                Cache.all.Precedent := Cellule;
                Cache := Cellule;
            end if;
            Cache := Cellule;
        else
            Supprimer_LRU(Cache);
            Cellule := new T_Cellule'(Destination, Masque, Interf, Null, Cache, 0);
            
            if Cache /= Null then
                Cache.all.Precedent := Cellule;
            end if;
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
        Noeud, Curseur, Precedent, Suivant : T_Cache;
        Interf : Unbounded_String;
        Max  : T_IP := 0;
    begin
        Curseur := Cache;
        while Curseur /= Null loop
            if (IP_Paquet and Curseur.all.Masque) = Curseur.all.Destination then
                if Curseur.all.Masque > Max then
                    Max := Curseur.all.Masque;
                    Interf := Curseur.all.Interf;
                    Noeud := Curseur;
                end if;
            end if;
            Curseur := Curseur.all.Suivant;
        end loop;

        -- Si l'élément est déja au début ou on a pas trouvé l'élement on retourne
        if Curseur = Cache or Curseur = Null then
            return Interf;
        end if;


        Precedent := Noeud.all.Precedent;
        Suivant := Noeud.all.Suivant;
        if Precedent /= Null then
            Precedent.all.Suivant := Suivant;
        end if;
        if Suivant /= Null then
            Suivant.all.Precedent := Precedent;
        end if;

        Cache.all.Precedent := Noeud;
        Noeud.all.Suivant := Cache;
        Noeud.all.Precedent := Null;
        Cache := Curseur;
        return Interf;
    end L_Interface;


    procedure Vider (Cache : in out T_Cache) is
    begin
        if Cache /= Null then
            Vider(Cache.all.Suivant);
            Free(Cache);
        end if;
    end Vider;

    -- (1) -> (0) -> (5)
    -- l_interface (0)
    -- (0) -> (1) -> (5)
    -- (0) -> (1)
    -- (3) -> (0)

    procedure Supprimer_LRU (Cache : in out T_Cache) is
        Curseur : T_Cache;
        Noeud_Precedent : T_Cache;
    begin
        --   (1) ->  null
        --          curseur
        --   Tab = null;
        if not Est_Vide(Cache) then
            Curseur := Cache;
            
            -- Si l'element a supprimer est la tete de la liste
            while Curseur.all.Suivant /= Null  loop
                Curseur := Curseur.all.Suivant;
            end loop;
            --loop
            --    curseur := curseur.all.Suivant;
            --    exit when curseur.all.Suivant = null;
            --end loop;

            Noeud_Precedent := Curseur.all.Precedent;
            if Noeud_Precedent /= Null then
                Noeud_Precedent.all.Suivant := Null;
            end if;
            Free(Curseur);
        end if;
    end Supprimer_LRU;

    procedure Pour_Chaque (Cache : in T_Cache) is
        Curseur : T_Cache;
    begin
        Curseur := Cache;
        while Curseur /= Null loop
            begin
                Traiter(Curseur.all.Destination, Curseur.all.Masque, Curseur.all.Interf);
            exception
                when others => null;
            end;
            Curseur := Curseur.all.Suivant;
        end loop;
    end Pour_Chaque;
end Cache_LRU;
