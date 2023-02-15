with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Command_Line;          use Ada.Command_Line;

-- Gestion des arguments de la ligne de commande

package body CLI is


    -- Fonction d'affichage d'erreur
    function Usage return String is
    begin
        return "Usage ./routeur_simple [-c <taille>] [-P FIFO|LRO|LFU] [-s] [-S] [-t <fichier>] [-p <fichier>] [-r <fichier]";
    end Usage;


    -- Lecture des arguments de la ligne de commande
    function init_routeur return init_type is
        i : Integer := 1;
        Valeur_args : init_type;
        Usage_Error : exception;
    begin

        while i <= Argument_Count loop

            if Argument(i)(1)='-' then

                case Argument(i)(2) is
                    when 'c' =>
                        if i+1>Argument_Count then raise Usage_Error with Usage;
                        end if;
                        Valeur_args.Capacite := Integer'Value(Argument(i+1));      
                        i := i+2;
                    when 'P' => 
                        if i+1>Argument_Count then raise Usage_Error with Usage;
                        end if;
                        Valeur_args.Politique := T_Politique'Value(Argument(i+1)); 
                        i := i+2;
                    when 's' => 
                        Valeur_args.Stat_Mode := True;              
                        i := i+1;
                    when 'S' => 
                        Valeur_args.Stat_Mode := False;     
                        i := i+1;
                    when 't' => 
                        if i+1>Argument_Count then raise Usage_Error with Usage;
                        end if;
                        Valeur_args.Nom_Entree := To_Unbounded_String(Argument(i+1));         
                        i := i+2;
                    when 'p' => 
                        if i+1>Argument_Count then raise Usage_Error with Usage;
                        end if;
                        Valeur_args.Nom_Paquet := To_Unbounded_String(Argument(i+1));        
                        i := i+2;
                    when 'r' =>
                        if i+1>Argument_Count then raise Usage_Error with Usage;
                        end if;
                        Valeur_args.Nom_Sortie := To_Unbounded_String(Argument(i+1));    
                        i := i+2;
                    when others => 
                        raise Usage_Error with Usage;
                end case;
            else raise Usage_Error with Usage;
            end if;
        end loop;
        
        return Valeur_args;
    exception
        -- Cas taille cache n'est pas un entier
        when Constraint_Error => raise Usage_Error with Usage;
    end init_routeur;




    -- Procédure d'affichage des constantes pour debug
    procedure infos_constantes(list_constantes : in init_type) is
       
    begin
        Put_Line("******** Infos Constantes ********");
        Put_Line("Taille Cache      = " & Integer'Image(list_constantes.Capacite));
        Put_Line("politique_routeur = " & T_Politique'Image(list_constantes.Politique));
        Put_Line("STAT_MODE         = " & Boolean'Image(list_constantes.Stat_Mode));
        Put_Line("TABLE_FILE_NAME   = " & list_constantes.Nom_Entree);
        Put_Line("PAQUETS_FILE_NAME = " & list_constantes.Nom_Paquet);
        Put_Line("RES_FILE_NAME     = " & list_constantes.Nom_Sortie);
    end infos_constantes;


end CLI;
