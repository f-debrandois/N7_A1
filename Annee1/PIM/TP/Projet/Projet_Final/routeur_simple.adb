with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;

with OP_Routeur_Simple; use OP_Routeur_Simple;
with File_IO; use File_IO;
with CLI; use CLI;
with OP_Table; use OP_Table;

procedure Routeur_Simple is
    CONST : constant init_type := init_routeur; -- Lecture des arguments de la ligne de commande
    
    table_liste : List; -- Liste chainee contenant les informations de la table sous forme de string
    paquet_liste : List; -- Liste chainee contenant les informations des paquets sous forme de string
    Sortie : T_Sortie;
    Table : T_Table;
    
begin
    -- Recuperation des données du fichier table dans table_liste
    file_to_data(CONST.Nom_Entree, table_liste);
    
    -- Initialiser la table de routage Table
    Initialiser(Table);
    
    -- Remplir la table de routage avec Table
    make_table(Table, table_liste);

    -- Recuperation des données du fichier paquet dans paquet_liste
    file_to_data(CONST.Nom_Entree, paquet_liste);

    -- Traiter de Paquet
    Traiter_Paquet(Valeur_Initiale, Paquet, Table, Sortie);

    -- Ecriture des interfaces correspondantes dans le fichier de sortie
    Ecriture_Sortie(Valeur_Initiale, Sortie);

    -- Vider la table
    Vider(Table);

exception
    when Invalid_CLI_Exception => Put_Line("Usage ./routeur_simple [-c <taille>] [-P FIFO|LRO|LFU] [-s] [-S] [-t <fichier>] [-p <fichier>] [-r <fichier]");
    when Invalid_Fichier_Routeur_Exception => Put_Line("Fichier table routeur invalide");
    when Invalid_Fichier_Paquet_Exception => Put_Line("Fichier paquets invalide");

end Routeur_Simple;
