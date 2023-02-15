with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Routage; use Routage;
with Cache;     use Cache;
with CLI; use CLI;
with Routeur_Outils; use Routeur_Outils;
with File_IO; use File_IO;
with Routeur_Exceptions; use Routeur_Exceptions;

procedure Routeur_LL is
    Tab : T_Table;
    Cache : T_Cache;
    Valeur_Initiale : Valeur_Entree; 
begin
    begin 
        Initialiser(Valeur_Initiale => Valeur_Initiale);
        Initialiser(Tab);
        Remplir_Table(Valeur_Initiale, Tab);
        Initialiser(Cache, Valeur_Initiale.Capacite, Valeur_Initiale.Politique);
        Traitement_LL(Valeur_Initiale, Tab, Cache);
        Vider(Tab);
        Vider(Cache, Valeur_Initiale.Politique);
    exception
        when Invalid_CLI_Exception => Put_Line("Commande CLI invalide");
        when Invalid_Fichier_Routeur_Exception => Put_Line("Fichier table routeur invalide");
        when Invalid_Fichier_Paquet_Exception => Put_Line("Fichier paquets invalide");
    end;
end Routeur_LL;
