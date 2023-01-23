with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Command_Line;          use Ada.Command_Line;



package body CLI is
    
    -- Fonction d'affichage d'erreur dans la ligne de commande
    function Usage return String is
    begin
        return "Usage ./routeur_simple [-c <taille>] [-P FIFO|LRO|LFU] [-s] [-S] [-t <fichier>] [-p <fichier>] [-r <fichier]";
    end Usage;


    -- Lecture des arguments de la ligne de commande
    procedure Initialiser(Valeur_Initiale : in out Valeur_Entree) is
        i : Integer := 1;
        Usage_Error : exception;
       
    begin
        
        while i <= Argument_Count loop
            
            if Argument(i)(1)='-' then
                if i+1>Argument_Count then 
                    raise Usage_Error with Usage;
                end if;
                
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

                    -- Changer le type de routeur en fonction de la commande d'entrée
                    
                when others => 
                    raise Usage_Error with Usage;
                end case;
            end if;
        end loop;
    end Initialiser;
end CLI;
