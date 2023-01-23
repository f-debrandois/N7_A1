with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings;               use Ada.Strings;	-- pour Both utilisé par Trim
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Command_Line;          use Ada.Command_Line;

with IP; use IP;
with PLinkedList;


procedure Routeur_simple is

    -- Instanciation Package Linked List
    package package_LA is
        new PLinkedList(T_IP, Unbounded_String);
    use package_LA;

    procedure Afficher_table is
        new Afficher(IP.To_String,Ada.Strings.Unbounded.To_String);


    -- Fonction d'affichage d'erreur
    function Usage return String is
    begin
        return "Usage ./routeur_simple [-c <taille>] [-P FIFO|LRO|LFU] [-s] [-S] [-t <fichier>] [-p <fichier>] [-r <fichier]";
    end Usage;

    -- Politique du Cache
    -- Inutile sur routeur simple
    type Politique is (FIFO,LRU,LFU);

    -- Type qui sauvegarde l'ensemble des constantes
    type init_type is record
        taille_cache : Integer := 10;
        politique_routeur : Politique := FIFO;
        stat_mode : Boolean := True;
        tf : Unbounded_String := To_Unbounded_String("table.txt");
        pf : Unbounded_String := To_Unbounded_String("paquets.txt");
        rf : Unbounded_String := To_Unbounded_String("resultats.txt");
    end record;


    -- Lecture des arguments de la ligne de commande
    function init_routeur return init_type is
        i : Integer := 1;
        retour : init_type;
        Usage_Error : exception;
    begin

        while i <= Argument_Count loop

            if Argument(i)(1)='-' then
                if i+1>Argument_Count then raise Usage_Error with Usage;
                end if;

                case Argument(i)(2) is
                    when 'c' => retour.taille_cache := Integer'Value(Argument(i+1));        i := i+2;
                    when 'P' => retour.politique_routeur := Politique'Value(Argument(i+1)); i := i+2;
                    when 's' => retour.stat_mode := True;                                   i := i+1;
                    when 'S' => retour.stat_mode := False;                                  i := i+1;
                    when 't' => retour.tf := To_Unbounded_String(Argument(i+1));            i := i+2;
                    when 'p' => retour.pf := To_Unbounded_String(Argument(i+1));            i := i+2;
                    when 'r' => retour.rf := To_Unbounded_String(Argument(i+1));            i := i+2;
                    when others => raise Usage_Error with Usage;
                end case;
            else raise Usage_Error with Usage;
            end if;
        end loop;
        
        return retour;
    exception
        -- Cas taille cache n'est pas un entier
        when Constraint_Error => raise Usage_Error with Usage;
    end init_routeur;


    -- Déclaration des constantes
    init : constant init_type := init_routeur;

    TAILLE_CACHE : constant Integer := init.taille_cache;

    politique_routeur : constant Politique := init.politique_routeur;

    STAT_MODE : constant Boolean := init.stat_mode;

    TABLE_FILE_NAME : constant String := To_String(init.tf);

    PAQUETS_FILE_NAME : constant String := To_String(init.pf);

    RES_FILE_NAME : constant String := To_String(init.rf);

    -- Procédure d'affichage des constantes pour debug
    procedure infos_constantes is
    begin
        Put_Line("******** Infos Constantes ********");
        Put_Line("Taille Cache      = " & Integer'Image(TAILLE_CACHE));
        Put_Line("politique_routeur = " & Politique'Image(politique_routeur));
        Put_Line("STAT_MODE         = " & Boolean'Image(STAT_MODE));
        Put_Line("TABLE_FILE_NAME   = " & TABLE_FILE_NAME);
        Put_Line("PAQUETS_FILE_NAME = " & PAQUETS_FILE_NAME);
        Put_Line("RES_FILE_NAME     = " & RES_FILE_NAME);
    end infos_constantes;

    -- Fonction qui renvoie l'interface correspondante à l'ip entrée
    -- Renvoie "null" sinon
    function find_Interface(table : in LinkedList ; ip_paq: IP.T_IP) return Unbounded_String is
        max, res: Integer;
        lign : T_Ligne;
        cell : LinkedList := table;
        interface_retour : Unbounded_String;
    begin
        interface_retour := To_Unbounded_String("null");
        max := -1;
        while not Est_Vide(cell) loop
            lign := Ligne(cell);
            res := compare(ip_paq,lign.dest,lign.masque);
            if res>max then
                interface_retour := lign.sortie;
                max := res;
            end if;
            cell := Suivant(cell);
        end loop;
        return interface_retour;
    end find_Interface;


    -- Génère la table via le fichier correspondant
    procedure make_table(table : out LinkedList; f_table : in out File_Type) is

        -- Supprimme les espaces répétés
        procedure delete_useless_spaces(t : in out Unbounded_String) is
            i: Integer := 1;
            last : Character := '0';
        begin
            while i <= Length(t) loop
                if Element(t,i)=' ' and then last=' ' then
                    Delete(t,i,i);
                else
                    last := Element(t,i);
                    i:=i+1;
                end if;
            end loop;
        end delete_useless_spaces;

        line, ip_dest, mask, interfac : Unbounded_String;
        start, i , j: Integer;
    begin
        while not End_Of_File(f_table) loop
            start := 1;
            i := 1;
            j := 1;
            line := Get_Line(f_table);
            Trim(line,Both);
            delete_useless_spaces(line);
            while i<=Length(line) loop
                if Element(line,i)=' ' then
                    case j is
                        when 1 => ip_dest := Unbounded_Slice(line,start,i-1); start := i+1; j:=2;
                        when 2 => mask := Unbounded_Slice(line,start,i-1); start := i+1;
                        when others => null;
                    end case;
                end if;
                i:=i+1;
            end loop;
            interfac := Unbounded_Slice(line,start,i-1);
            Enregistrer(table,To_IP(To_String(ip_dest)),To_IP(To_String(mask)),interfac);
        end loop;
    end make_table;


    table : LinkedList;

    line_s : Unbounded_String;

    num_line : Integer;

    f_in,f_out,f_table : File_Type;

    fin : Boolean := False;

    -- Fonction qui renvoie si un charactère est un chiffre
    function is_Number(c : in Character) return Boolean is
    begin
        return c>='0' and then c<='9';
    end is_Number;
   
    
-- Initialisation des routes du routeur avec le fichier de configuration
begin
    Initialiser(table);

    infos_constantes;
    New_Line;

    -- Ouvre le fichier de configuration (table.txt)
    Open(f_table, In_File, "table.txt");

    -- Initialise la table de routage sous forme d’une liste chaînée
    make_table(table,f_table);
    
    -- Ferme le fichier de configuration
    Close(f_table);
    
    -- Ouvre les fichier d’entrée et de sortie
    Create(f_out, Out_File, "sortie.txt");
    Open(f_in, In_File, "paquets.txt");

    begin
        loop
            -- Lecture de la ligne du fichier d’entrée
            num_line := Integer (Line (f_in));
            line_s := Get_Line (f_in);
            Trim (line_s, Both);
            
            
            --Interprétation de la ligne du fichier d’entrée
            
            -- Pour savoir si la ligne est une ip ou une commande, on regarde le premier charactère
            -- Sachant que les eventuels espaces en début de ligne sont supprimés par la commande Trim
            if is_Number(Element(line_s,1)) then
                
                --Ecrire l’adresse IP traitée suivie de l’interface associé dans le fichier résultat
                Put(f_out,line_s & "  ");
                Put(f_out,find_Interface(table,To_IP(To_String(line_s))));
                New_Line(f_out);

            else
                -- Exécuter la commande
                if line_s = "table" then
                    Put_Line("table (ligne" & Integer'Image(num_line) & ')');
                    Afficher_table(table);
                    New_Line;
                elsif line_s = "cache" then
                    Put_Line("table (ligne" & Integer'Image(num_line) & ')');
                    Put_Line("AFFICHAGE CACHE");
                    New_Line;
                elsif line_s = "stat" then
                    Put_Line("table (ligne" & Integer'Image(num_line) & ')');
                    Put_Line("AFFICHAGE STAT");
                    New_Line;
                elsif line_s = "fin" then
                    Put_Line("fin (ligne" & Integer'Image(num_line) & ')');
                    New_Line;
                    fin := True;
                end if;
            
            end if;
            exit when End_Of_File (f_in) or else fin;
        end loop;
    exception
        when End_Error =>
            Put ("Blancs en surplus à la fin du fichier.");
            null;
    end;

    -- Fermer les fichier d’entrée et de sortie
    Close(f_out);
    Close(f_in);
   
    Vider(table);

end Routeur_simple;
