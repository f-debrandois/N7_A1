with Ada.Strings;               use Ada.Strings;	-- pour Both utilisé par Trim
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Command_Line;          use Ada.Command_Line;
with Ada.Exceptions;            use Ada.Exceptions;	-- pour Exception_Message
with Tab_exceptions;
with Ada.Unchecked_Deallocation;
with Routage;




procedure Routeur_LA is


    -- Instancier le type generique T_Interface par Unbounded_String
    package Routage_String_Integer is
		new Routage (T_Interface => Unbounded_String);
    use Routage_String_Integer;

    -- Definir le type arbre pour le cache
    type T_ABR;
	type T_Noeud is record
        Destination : T_IP;
        Masque : T_IP
        Interf : T_Interface ;
        Sous_Arbre_G : T_ABR;
        Sous_Arbre_D : T_ABR;
    end record;


     -- Convertir une chaine de caractere en une adresse ip de type T_IP
     function To_Ip(adr : in Unbounded_String) return T_IP is
        IP1 : T_IP;
        elem1,elem2,elem3,elem4 : Unbounded_String;
        indice1, indice2, indice3 : Integer;
        UN_OCTET: constant T_IP := 2 ** 8;       -- 256
     begin

     indice1 := index(adr, ".", 1);
     elem1 := Unbounded_Slice(adr, 1, indice1-1);
     indice2 := index(adr, ".",indice1+1);
     elem2 := Unbounded_Slice(adr, indice1+1, indice2-1);
     indice3 := index(adr, ".",indice2+1);
     elem3 := Unbounded_Slice(adr, indice2+1, indice3-1);
     elem4 := Unbounded_Slice(adr, indice3+1, Length(adr));

      IP1 := T_IP'Value(To_String(elem1));
	 IP1 := IP1 * UN_OCTET + T_IP'Value(To_String(elem2));
	 IP1 := IP1 * UN_OCTET + T_IP'Value(To_String(elem3));
     IP1 := IP1 * UN_OCTET + T_IP'Value(To_String(elem4));

       return IP1;
     end To_Ip;



    -- convertir une ip 12345567 en adresse de la forme 147.231.44.2
    function Conversion_String(IP1 : in T_IP) return Unbounded_String is
        adr : Unbounded_String;
        IP2 : T_IP;
        elem1,elem2,elem3,elem4 : Unbounded_String;
        UN_OCTET: constant T_IP := 2 ** 8;       -- 256
    begin
      IP2 := IP1;
      elem1 := To_Unbounded_String ( T_IP(IP2 mod UN_OCTET)'Image);    --Conversion d'un T_Adresse_IP en Integer pour utiliser Put sur Integer
	 Trim(elem1,Both);
      IP2 := IP2 / UN_OCTET;
      elem2 := To_Unbounded_String ( T_IP(IP2 mod UN_OCTET)'Image);
      Trim(elem2,Both);
      IP2 := IP2 / UN_OCTET;
      elem3 := To_Unbounded_String ( T_IP(IP2 mod UN_OCTET)'Image);
      Trim(elem3,Both);
   	 IP2 := IP2 / UN_OCTET;
      elem4 := To_Unbounded_String ( T_IP(IP2 mod UN_OCTET)'Image);
      Trim(elem4,Both);
      adr := elem4 & "." & elem3 & "." & elem2 & "." & elem1;
      return adr;
    end Conversion_String;


    --afficher la destination, le masque, l'interface
    procedure Afficher (dest : in T_IP; masque : in T_IP; interfac : in Unbounded_String )is
    begin
        Put_Line (Conversion_String(dest) & " "& Conversion_String(masque)&" "& interfac);
    end Afficher;


    --Instancier la fonction generique Traiter par Afficher
    procedure AfficherTous is new Routage_String_Integer.Pour_Chaque(Afficher);



    -- Collecter les routes du fichier d'entree des tables dans la liste chainee qu'on considere
    procedure Remplir_Table( Nom_Entree: in Unbounded_String; Tab : in out T_Table) is
     Entree : File_Type;
     indice1,indice2,indice3 : Integer;
     mask, dest, interf : Unbounded_String;
     Ligne : Unbounded_String;
    begin

        Initialiser(Tab);
       begin
        Open (Entree, In_File, To_String (Nom_Entree));

        loop

         Ligne := Get_line (Entree);  -- Lire le reste de la ligne depuis le fichier Entree
         indice1 := index(Ligne, " ",1);
         dest := Unbounded_Slice(Ligne,1, indice1);

         indice2 := index(Ligne, " ",indice1+1);
         mask := Unbounded_Slice(Ligne, indice1+1, indice2);

         indice3 := index(Ligne, " ",indice2+1);
         interf := Unbounded_Slice(Ligne, indice2+1, length(Ligne));

         Enregistrer(Tab, To_Ip(dest), To_Ip(mask), interf);

	   exit when End_Of_File (Entree);
        end loop;

          Close (Entree);

       exception
            when others =>
                Put_Line("fichier introuvable");
       end;
    end Remplir_Table;

    -- Traitement du cache lorsqu'on aura une ippaquet(destination)
    procedure Remplir_Cache (Cache : in out T_Table; Tab : in T_Table; interf : in Unbounded_String; ippaquet : in T_IP)is

        -- retourne le plus long masque de la table
        function Long_Masque (Tab : in T_Table ; ippaquet : in T_IP) return T_IP is
            noeud, cellule : T_Table;
            interf : Unbounded_String;
            max : T_IP;
        begin
            max := 0;
            noeud := Tab;
            while noeud /= Null loop

                if (ippaquet and noeud.all.Masque) = noeud.all.Destination then
                    if noeud.all.Masque > max then
                        max := noeud.all.Masque;
                    end if;
                end if;

                noeud := noeud.all.Suivant;
            end loop;

            return max;

        end Long_Masque;

        masque, dest : T_IP;

    begin
        -- obtenir l'interface de l'ippaquet (parametre donne)
        -- choisir le plus long masque
        -- enregistrer (l'ippaquet and masque) masque_long  interf


        masque := Long_Masque (Tab, ippaquet);
        dest := ippaquet and masque;
        Enregistrer( Cache, dest, masque, interf);

    end Remplir_Cache;



    -- Traitement des lignes du fichier des paquets et recuperation des paquets+interfaces dans fichier resltats
    procedure Traitement( Nom_Paquet : in Unbounded_String; Nom_Sortie : in out Unbounded_String ; Tab : in T_Table ; Cache :in out T_Table) is
     Paquet : File_Type;	-- Le descripteur du ficher des paquets
     ippaquet : T_IP;
     Sortie : File_Type;	-- Le descripteur du ficher de sortie
     inter : Unbounded_String;
     Ligne2 : Unbounded_String;
     Numero_Ligne : Integer;
    begin
       begin
        Open (Paquet, In_File, To_String (Nom_Paquet));
        Create (Sortie, Out_File, To_String (Nom_Sortie));
        loop
            Numero_Ligne := Integer (Line (Paquet));
            Ligne2 := Get_line (Paquet);  -- Lire le reste de la ligne depuis le fichier des paquets

            if  Ligne2 = "table" then
                Put_Line(Ligne2 &"(ligne"& Numero_Ligne'Image & ")");
                AfficherTous(Tab);
                New_Line;
            elsif Ligne2 = "cache" then
              Put_Line(Ligne2 & "(ligne"& Numero_Ligne'Image & ")");
              AfficherTous(Cache);
              New_Line;
            elsif Ligne2 = "stat" then
                    Put_Line(Ligne2 & "(ligne"& Numero_Ligne'Image & ")");
                    Put_Line(" Afficher toutes les routes du cache. ");
                    New_Line;
            elsif Ligne2 = "fin" then
                Put_Line(Ligne2 &"(ligne"& Numero_Ligne'Image & ")");
                New_Line;
                exit;
            else
                    ippaquet := To_Ip(Ligne2);
                  if not Est_Vide (Cache) then
                        inter := L_Interface (Cache, To_Ip(Ligne2));
                  else
                        inter := L_Interface(Tab, To_Ip(Ligne2));
                        Remplir_Cache (Cache, Tab, inter, ippaquet);
                  end if;

                Put (Sortie, Conversion_String(ippaquet) & " " & inter);     --Écrire l'adresse paquet et son interface correspondante sur 2 postions sur le fichier Sortie
               New_Line (Sortie);
            end if;
            exit when End_Of_File (Paquet);
	   end loop;
           Close (Paquet);
           Close (Sortie);

        exception
            when others =>
                Put_Line("fichier introuvable");

        end;

    end Traitement;


    --Declaration des variables // types utilises dans le programme principal Routeur_Simple
    Tab, Cache : T_Table;
    Nom_Entree : Unbounded_String;
    Entree : File_Type;	-- Le descripteur du ficher d'entrée (fichier des tables)
    mask, dest, interf : Unbounded_String;
    Ligne : Unbounded_String;
    Nom_Paquet : Unbounded_String;
    Paquet : File_Type;	-- Le descripteur du ficher des paquets
    Nom_Sortie : Unbounded_String;
    Sortie : File_Type;	-- Le descripteur du ficher de sortie
    inter : Unbounded_String;
    Ligne2 : Unbounded_String;
    i,res : Integer;

begin

    -- traitementligne table.txt
    -- routeur_simple table.txt
    -- routeur_LL -c 15 -t table.txt -p paquets.txt -r resultats.txt


    Nom_Paquet := To_Unbounded_String("paquets.txt");
    Nom_Entree :=To_Unbounded_String("table.txt");
    Nom_Sortie := To_Unbounded_String("resultats.txt");

    begin
        i := 1;
        While i <= Argument_Count loop
            case Argument(i)(2) is
                when 'c' =>
                    res := Integer'Value(Argument(i+1));
                    Put_Line("La taille du cache est " & Argument(i+1));
                    i := i+2;
                when 'P' =>
                    Put_Line("La politique utilisée pour le cache" & Argument(i+1));
                    i := i+2;
                when 's' =>
                    Put_Line("Afficher les statistiques (nombre de défauts de cache, nombre de demandes de route, taux de défaut de cache)");
                    i :=i+1;
                when 'S' =>
                    Put_Line("Ne pas afficher les statistiques.");
                    i :=i+1;
               when  'p' =>
                    Nom_Paquet := To_Unbounded_String(Argument(i+1));
                    i := i+2;
               when 't' =>
                    Nom_Entree := To_Unbounded_String(Argument(i+1));
                     i:=i+2;
               when 'r' =>
                    Nom_Sortie := To_Unbounded_String(Argument(i+1));
                    i:=i+2;

               when others =>
                    Null;
                    Put_Line("la ligne de commande est invalide !");
                    return;
            end case;
        end loop;
    exception
        when others =>
            Put("usage : " & Command_Name & " <fichier>");
            return;
    end;
        Remplir_Table( Nom_Entree, Tab);
        Traitement( Nom_Paquet, Nom_Sortie, Tab, Cache);
        Vider(Tab);
end Routeur_LA;

