with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Adresse_IP; use Adresse_IP;

-- Opérations du routeur simple

package OP_Routeur_Simple is
begin
    type T_Sortie is private;
    
    private
    
    type cell;
    type List is access cell;
    type cell is
        record
            ligne : Unbounded_String;
            next : List;
        end record;
    
    type T_Cell_Sortie;
    type T_Sortie is access T_Cell_Sortie;
    type T_Cell_Sortie is record
        Destination : T_IP;
        Interf : Unbounded_String;
        Suivant : T_Sortie;
    end record;


end OP_Routeur_Simple;
