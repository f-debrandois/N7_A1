with Adresse_IP; use Adresse_IP;
with Cache_FIFO;
with Cache_LFU;
with Cache_LRU;
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Command_Line;          use Ada.Command_Line;
with Routeur_Outils; use Routeur_Outils;
with Cache; use Cache;
with Routage; use Routage;
with Routeur_Exceptions; use Routeur_Exceptions;

package body File_IO is

    -- Afficher la destination, le masque, l'interface
    procedure Afficher (Destination : in T_IP; Masque : in T_IP; Inter : in Unbounded_String )is
    begin
        Put_Line (Conversion_String(Destination) & " " & Conversion_String(Masque) & " " & Inter);
    end Afficher;

    -- Instancier la fonction generique Traiter par Afficher
    procedure AfficherRouteur is new Routage.Pour_Chaque(Afficher);

    -- Traitement du cache lorsqu'on aura une ippaquet(destination)
    procedure Remplir_Cache (Cache : in out T_Cache; Tab : in T_Table; Inter : in Unbounded_String; IP_Paquet : in T_IP; Valeur_Initiale : in Valeur_Entree)is
        Masque, Destination : T_IP;
    begin
        -- obtenir l'interface de l'ippaquet (parametre donne)
        -- choisir le plus long masque
        -- enregistrer (l'ippaquet and masque) masque_long  Interface

        Masque := Long_Masque (Tab, IP_Paquet);
        Destination := IP_Paquet and Masque;
        Enregistrer(Cache, Destination, Masque, Inter, Valeur_Initiale.Politique);
    end Remplir_Cache;

    -- Afficher les statistiques du routeur et cache
    procedure AfficherStats(Valeur_Initiale : in Valeur_Entree) is
        Taux_Defaut : Float;
    begin
        if Valeur_Initiale.Afficher_Stats_Active then
            Put_Line("Le nombre de demandes de route est: " & Valeur_Initiale.Nombre_Demande_Route'Image);
            Put_Line("Le nombre de défauts du Cache est: " & Valeur_Initiale.Nombre_Defaut_Cache'Image);
            if Valeur_Initiale.Nombre_Demande_Route > 0 then
                Taux_Defaut := (Float(Valeur_Initiale.Nombre_Defaut_Cache) / Float(Valeur_Initiale.Nombre_Demande_Route)) * 100.0;
                Put("Le taux de défaut du Cache est: ");
                Put(Item => Taux_Defaut, Aft => 2, Exp => 0);
                Put(" %");
            end if;
        end if;
    end AfficherStats;

    -- Collecter les routes du fichier d'entree des tables dans la liste chainee qu'on considere
    procedure Remplir_Table(Valeur_Initiale : Valeur_Entree; Tab : in out T_Table) is
        Entree : File_Type;
        indice1, indice2, indice3 : Integer;
        mask, dest, Inter : Unbounded_String;
        Ligne : Unbounded_String;
    begin
        begin
            Open (Entree, In_File, To_String (Valeur_Initiale.Nom_Entree));
            loop
                Ligne := Get_line (Entree);  -- Lire le reste de la ligne depuis le fichier Entree
                indice1 := index(Ligne, " ",1);
                dest := Unbounded_Slice(Ligne,1, indice1);

                indice2 := index(Ligne, " ",indice1+1);
                mask := Unbounded_Slice(Ligne, indice1+1, indice2);

                indice3 := index(Ligne, " ",indice2+1);
                Inter := Unbounded_Slice(Ligne, indice2+1, length(Ligne));

                Enregistrer(Tab, To_Ip(dest), To_Ip(mask), Inter);
                exit when End_Of_File (Entree);
        end loop;
        Close (Entree);
        exception
            when others => raise Invalid_Fichier_Routeur_Exception;
        end;
    end Remplir_Table;

    -- Traitement des lignes du fichier des paquets et recuperation des paquets+interfaces dans fichier resltats
    procedure Traitement_Simple(Valeur_Initiale : Valeur_Entree ; Tab : in T_Table) is
        Paquet_File : File_Type;	-- Le descripteur du ficher des paquets
        IP_Paquet : T_IP;
        Sortie_File : File_Type;	-- Le descripteur du ficher de sortie
        Inter : Unbounded_String;
        Ligne : Unbounded_String;
        Numero_Ligne : Integer;
    begin
        begin
            Open (Paquet_File, In_File, To_String (Valeur_Initiale.Nom_Paquet));
            Create (Sortie_File, Out_File, To_String (Valeur_Initiale.Nom_Sortie));
            loop
                Numero_Ligne := Integer (Line (Paquet_File));
                Ligne := Get_line (Paquet_File);  -- Lire le reste de la ligne depuis le fichier des paquets

                if Ligne = "table" then
                    Put_Line(Ligne &"(ligne"& Numero_Ligne'Image & ")");
                    AfficherRouteur(Tab);
                    New_Line;
                elsif Ligne = "cache" then
                    Put_Line(Ligne & "(ligne"& Numero_Ligne'Image & ")");
                    Put_Line("La taille du cache est 0. Il s'agit d'un routeur simple!");
                    New_Line;
                elsif Ligne = "stat" then
                    Put_Line(Ligne & "(ligne"& Numero_Ligne'Image & ")");
                    Put_Line("La taille du cache est 0. Il s'agit d'un routeur simple!");
                    New_Line;
                elsif Ligne = "fin" then
                    Put_Line(Ligne &"(ligne"& Numero_Ligne'Image & ")");
                    New_Line;
                    exit;
                else
                    IP_Paquet := To_Ip(Ligne);
                    Inter := Trouver_Interface(Tab, To_Ip(Ligne));
                    Put (Sortie_File, Conversion_String(IP_Paquet) & " " & Inter);     --Écrire l'adresse paquet et son interface correspondante sur 2 postions sur le fichier Sortie
                    New_Line (Sortie_File);
                end if;
                exit when End_Of_File (Paquet_File);
            end loop;
            Close (Paquet_File);
            Close (Sortie_File);
        exception
            when others => raise Invalid_Fichier_Paquet_Exception;
        end;
    end Traitement_Simple;

    -- Traitement des lignes du fichier des paquets et recuperation des paquets+interfaces dans fichier resltats
    procedure Traitement_LL(Valeur_Initiale : in out Valeur_Entree; Tab : in T_Table ; Cache : in out T_Cache) is
        Paquet_File : File_Type;	-- Le descripteur du fichier des paquets
        IP_Paquet : T_IP;
        Sortie_File : File_Type;	-- Le descripteur du fichier de sortie
        Inter : Unbounded_String;
        Ligne : Unbounded_String;
        Numero_Ligne : Integer;
    begin
    begin
        Open (Paquet_File, In_File, To_String (Valeur_Initiale.Nom_Paquet));
        Create (Sortie_File, Out_File, To_String (Valeur_Initiale.Nom_Sortie));
        loop
            Numero_Ligne := Integer (Line (Paquet_File));
            Ligne := Get_line (Paquet_File);  -- Lire le reste de la ligne depuis le fichier des paquets

            if Ligne = "table" then
                Put_Line(Ligne & "(ligne" & Numero_Ligne'Image & ")");
                AfficherRouteur(Tab);
                New_Line;
            elsif Ligne = "cache" then
                Put_Line(Ligne & "(ligne" & Numero_Ligne'Image & ")");
                AfficherCache(Cache, Valeur_Initiale.Politique);
                New_Line;
            elsif Ligne = "stat" then
                Put_Line(Ligne & "(ligne" & Numero_Ligne'Image & ")");
                AfficherStats(Valeur_Initiale);
                New_Line;
            elsif Ligne = "fin" then
                Put_Line(Ligne & "(ligne" & Numero_Ligne'Image & ")");
                New_Line;
                exit;
            else
                IP_Paquet := To_Ip(Ligne);
                Valeur_Initiale.Nombre_Demande_Route := Valeur_Initiale.Nombre_Demande_Route + 1;
                if Est_Present(Cache, IP_Paquet, Valeur_Initiale.Politique) then
                    Inter := Trouver_Interface (Cache, To_Ip(Ligne), Valeur_Initiale.Politique);
                else
                    Valeur_Initiale.Nombre_Defaut_Cache := Valeur_Initiale.Nombre_Defaut_Cache + 1;
                    Inter := Trouver_Interface(Tab, To_Ip(Ligne));
                    Remplir_Cache (Cache, Tab, Inter, IP_Paquet, Valeur_Initiale);
                end if;
                Put (Sortie_File, Conversion_String(IP_Paquet) & " " & Inter);     --Écrire l'adresse paquet et son interface correspondante sur 2 postions sur le fichier Sortie
            end if;            
            exit when End_Of_File (Paquet_File);
	    end loop;
        Close (Paquet_File);
        Close (Sortie_File);
    exception
        when others => raise Invalid_Fichier_Paquet_Exception;  
    end;
    end Traitement_LL;
end File_IO;
