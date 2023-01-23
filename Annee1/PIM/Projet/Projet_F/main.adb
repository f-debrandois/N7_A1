with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;

with Routeur; use Routeur;
with Routeur_Outils; use Routeur_Outils;
with File_IO; use File_IO;
with CLI; use CLI;
with Routeur_Exceptions; use Routeur_Exceptions;

procedure main is
    Tab : T_Table;
    Valeur_Initiale : Valeur_Entree;
begin

    begin
        -- Lecture des arguments de la ligne de commande
        Initialiser(Valeur_Initiale => Valeur_Initiale);

        -- Remplir la table de routage avec le fichier d'entrée
        Remplir_Table(Valeur_Initiale, Tab);

        -- Traiter le fichier paquets
        Traitement_Simple(Valeur_Initiale, Tab);

        -- Vider la table
        Vider(Tab);

    exception
        when Invalid_CLI_Exception => Put_Line("Usage ./routeur_simple [-c <taille>] [-P FIFO|LRO|LFU] [-s] [-S] [-t <fichier>] [-p <fichier>] [-r <fichier]");
        when Invalid_Fichier_Routeur_Exception => Put_Line("Fichier table routeur invalide");
        when Invalid_Fichier_Paquet_Exception => Put_Line("Fichier paquets invalide");
    end;

end main;
