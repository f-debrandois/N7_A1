with Adresse_IP; use Adresse_IP;
with Cache_FIFO;
with Cache_LFU;
with Cache_LRU;
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Command_Line;          use Ada.Command_Line;
with Routeur_Outils; use Routeur_Outils;
with Cache; use Cache;
with Routeur_exceptions; use Routeur_exceptions;

package body CLI is

    procedure Initialiser(Valeur_Initiale : in out Valeur_Entree) is
        i : Integer := 1;
    begin
    while i <= Argument_Count loop
        case Argument(i)(2) is
            when 'c' =>
                Valeur_Initiale.Capacite := Integer'Value(Argument(i+1));
                Put_Line("La taille du cache est " & Argument(i+1));
                i := i+2;
            when 'P' =>
                Put_Line("La politique utilisée pour le cache est : " & Argument(i+1));
                Valeur_Initiale.Politique := T_Politique'Value(Argument(i+1));
                i := i+2;
            when 's' =>
                Put_Line("Afficher les statistiques (nombre de défauts de cache, nombre de demandes de route, taux de défaut de cache)");
                Valeur_Initiale.Afficher_Stats_Active := true;
                i :=i+1;
            when 'S' =>
                Put_Line("Ne pas afficher les statistiques.");
                Valeur_Initiale.Afficher_Stats_Active := false;
                i :=i+1;
            when  'p' =>
                Valeur_Initiale.Nom_Paquet := To_Unbounded_String(Argument(i+1));
                i := i+2;
            when 't' =>
                Valeur_Initiale.Nom_Entree := To_Unbounded_String(Argument(i+1));
                    i:=i+2;
            when 'r' =>
                Valeur_Initiale.Nom_Sortie := To_Unbounded_String(Argument(i+1));
                i:=i+2;
            when others => 
                raise Invalid_CLI_Exception;
        end case;
    end loop;
    end Initialiser;
end CLI;
