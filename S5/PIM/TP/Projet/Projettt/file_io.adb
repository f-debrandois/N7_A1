with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Command_Line;          use Ada.Command_Line;

with Adresse_IP; use Adresse_IP;
with Routeur; use Routeur;
with Routeur_Outils; use Routeur_Outils;
with Routeur_Exceptions; use Routeur_Exceptions;


package body File_IO is

    -- Initialiser les routes de la table avec le fichier d'entree dans une liste chainee
    procedure Remplir_Table(Valeur_Initiale : Valeur_Entree; Table : in out T_Table) is
        Entree_File : File_Type;
        indice1, indice2, indice3 : Integer;
        mask, dest, interf : Unbounded_String;
        Ligne : Unbounded_String;
    begin
        begin
            Initialiser_Table(Table);
            Open (Entree_File, In_File, To_String (Valeur_Initiale.Nom_Entree));
            loop
                Ligne := Get_line (Entree_File);  -- Lire le reste de la ligne depuis le fichier Entree
                indice1 := index(Ligne, " ",1);
                dest := Unbounded_Slice(Ligne,1, indice1);

                indice2 := index(Ligne, " ",indice1+1);
                mask := Unbounded_Slice(Ligne, indice1+1, indice2);

                indice3 := index(Ligne, " ",indice2+1);
                interf := Unbounded_Slice(Ligne, indice2+1, length(Ligne));

                Enregistrer_Table(Table, To_Ip(dest), To_Ip(mask), interf);
                exit when End_Of_File (Entree_File);
        end loop;
        Close (Entree_File);
        exception
            when others => raise Invalid_Fichier_Routeur_Exception;
        end;
    end Remplir_Table;

    -- Recuperation des lignes du fichier paquet dans une liste chainee
    procedure Recuperation_Paquet(Valeur_Initiale : Valeur_Entree ; Paquet : in out T_Paquet) is
        Paquet_File : File_Type;	-- Le descripteur du ficher de paquets
        Ligne : Unbounded_String;
        Numero_Ligne : Integer;
    begin
        begin
            Open (Paquet_File, In_File, To_String (Valeur_Initiale.Nom_Paquet));
            loop
                Numero_Ligne := Integer (Line (Paquet_File));
                Ligne := Get_line (Paquet_File);  -- Lire le reste de la ligne depuis le fichier des paquets
                
                Enregistrer_Paquet(Paquet, Ligne);
                
                exit when End_Of_File (Paquet_File);
            end loop;
            Close (Paquet_File);
        end;
    end Recuperation_Paquet;
    
    -- Ecriture des interfaces correspondantes dans le fichier de sortie
    procedure Ecriture_Sortie(Valeur_Initiale : in Valeur_Entree; Sortie : in T_Sortie) is
        Sortie_File : File_Type;
        IP_Traite : T_IP;
        Interf : Unbounded_String;
    begin
        begin
            Create (Sortie_File, Out_File, To_String (Valeur_Initiale.Nom_Sortie));
            loop                
                
                Put (Sortie_File, Conversion_String(IP_Traite) & " " & Interf);     --Écrire l'adresse paquet et son interface correspondante sur 2 postions sur le fichier Sortie
                New_Line (Sortie_File);

                exit when True; -- Sortir de la boucle quand la liste chainee Sortie est vide
            end loop;
            Close (Sortie_File);
        exception
            when others => raise Invalid_Fichier_Routeur_Exception;    
        end;   
    end Ecriture_Sortie;
            
end File_IO;
