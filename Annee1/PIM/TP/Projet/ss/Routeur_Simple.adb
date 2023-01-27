with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Routage; use Routage;
with File_IO; use File_IO;
with Cli; use Cli;
with Routeur_Outils; use Routeur_Outils;
with File_IO; use File_IO;
with Routeur_Exceptions; use Routeur_Exceptions;

procedure Routeur_Simple is
    Tab : T_Table;
    Valeur_Initiale : Valeur_Entree;
begin
    -- traitement ligne table.txt
    -- routeur_simple table.txt
    -- routeur_LL -c 15 -t table.txt -p paquets.txt -r resultats.txt
    begin
        Initialiser(Valeur_Initiale => Valeur_Initiale);
        Remplir_Table(Valeur_Initiale, Tab);
        Traitement_Simple(Valeur_Initiale, Tab);
        Vider(Tab);
    exception
        when Invalid_CLI_Exception => Put_Line("Commande CLI invalide");
        when Invalid_Fichier_Routeur_Exception => Put_Line("Fichier table routeur invalide");
        when Invalid_Fichier_Paquet_Exception => Put_Line("Fichier paquets invalide");
    end;
end Routeur_Simple;

