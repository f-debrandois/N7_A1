--------------------------------------------------------------------------------
--  Auteur   : Félix Foucher de Brandois
--  Objectif : Réviser les tables de multiplications
--------------------------------------------------------------------------------

with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Calendar;          use Ada.Calendar;
with Ada.Numerics.Discrete_Random;



procedure Multiplications is
    
    table : Integer;     -- Table choisie
    nb_alea : Integer;   -- Nombre aléatoire
    resultat : Integer;  -- Résultat de la multiplication
    erreur : Integer;    -- Nombre d'erreurs commises
    
    suite : Integer;     -- Pour s'assurer qu'il n'y ait pas deux fois de suite la même multiplication
    
    continuer : Character; -- Pour savoir si l'utilisateur veut continuer
    
    Debut: Time;         -- Heure de début de l'opération
    Fin: Time;           -- Heure de fin de l'opération
    Duree : Duration;        -- Durée de l'opération
    
    temps_total : Duration; -- Durée totale des réponses
    temps_moyen : Duration; -- Temps moyen des réponses
    temps_max : Duration; --Temps maximal des réponses
    table_temps : Integer; --Table avec le temps le plus long
    

	generic
		Lower_Bound, Upper_Bound : Integer;	-- bounds in which random numbers are generated
		-- { Lower_Bound <= Upper_Bound }
	
	package Alea is
	
		-- Compute a random number in the range Lower_Bound..Upper_Bound.
		--
		-- Notice that Ada advocates the definition of a range type in such a case
		-- to ensure that the type reflects the real possible values.
		procedure Get_Random_Number (Resultat : out Integer);
	
	end Alea;

	
	package body Alea is
	
		subtype Intervalle is Integer range Lower_Bound..Upper_Bound;
	
		package  Generateur_P is
			new Ada.Numerics.Discrete_Random (Intervalle);
		use Generateur_P;
	
		Generateur : Generateur_P.Generator;
	
		procedure Get_Random_Number (Resultat : out Integer) is
		begin
			Resultat := Random (Generateur);
		end Get_Random_Number;
	
	begin
		Reset(Generateur);
	end Alea;

    package Mon_Alea is 
            new Alea (0, 10); -- Les nombres aléatoires seront dans [0..10]
    use Mon_Alea; -- on peut alors utiliser Get_Random_Number

begin
    loop 
        
        --Demander un nombre entre 0 et 10
        loop 
            Put("Table à réviser :");
            Get(table);
            New_Line;
            if 0 > table or 10 < table then
                Put_Line ("Impossible. La table doit être entre 0 et 10");
            else
                null;
            end if;
        exit when 0 <= table and 10 >= table;
        end loop;
        
        -- Afficher 10 multiplications
        erreur := 0;
        suite := -1;
        temps_total := Duration(0);
        temps_max := Duration(0);
        for i in 1..10 loop 
            loop
                Get_Random_Number (nb_alea);
                exit when nb_alea /= suite;
            end loop;
            suite := nb_alea;
            Put("(M");
            Put(i,0);
            Put(") ");
            Put(table,0);
            Put(" x ");
            Put(nb_alea,0);
            Put(" ? ");
            Debut := Clock;
            Get(resultat);
            Fin := Clock;
            Duree := Fin - Debut;
            temps_total := temps_total + Duree;
            if Duree > temps_max then
                temps_max := Duree;
                table_temps := nb_alea;
            end if;
             
            -- Dire si la réponse est la bonne
            if table * nb_alea = resultat then
                Put_Line("Bravo !");
                New_Line;
            else
                Put_Line("Mauvaise réponse.");
                erreur := erreur + 1;
                New_Line;
            end if;
        end loop;
        temps_moyen := temps_total/10;
        
        --Afficher un commentaire sur la série
        case erreur is 
            when 0 => Put_Line("Aucune erreur. Excellent !");
            when 1 => Put_Line("Une seule erreur. Très bien.");
            when 2..5 => Put(erreur,0); Put(" erreurs. Il faut encore travailler la table de "); Put(table,0); Put(".");
            when 6..8 => Put("Seulement "); Put(erreur,0); Put(" bonnes réponses. Il faut apprendre la table de "); Put(table,0); Put(" ! ");
            when 9 => Put("Seulement 1 bonne réponse. Il faut apprendre la table de "); Put(table,0); Put(".");
            when others => Put("Tout est faux ! Volontaire ?");
        end case;
        New_Line;
        
        -- Si l'utilisateur a des difficultés sur une table
        if temps_max > temps_moyen + Duration(1) then
            Put("Des hésitations sur la table de ");
            Put(table_temps,0);
            Put(" : ");
            Put(Duration'Image(temps_max));
            Put(" secondes contre ");
            Put(Duration'Image(temps_moyen));
            Put(" en moyenne. Il faut certainement la réviser.");
            New_Line;
        else
            null;
        end if;    
        
        -- Demander à l'utilisateur si il veut continuer à s'entrainer
        Put("On continue (o/n) ? ..");
        Get(continuer);
        New_Line;
        
        
    exit when continuer /= 'o' and continuer /= 'O';
    end loop;
end Multiplications;
