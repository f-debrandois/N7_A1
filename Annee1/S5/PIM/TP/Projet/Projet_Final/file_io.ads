with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;


-- Gestion des opérations relatives à la manipulation de fichiers

package File_IO is

    -- Structure de donnée pour fichier paquet et resultat
    type List is private;


    -- Initialise une liste
    procedure init(data : out List);


    -- Convertit un fichier txt en liste chainée ou chaque ligne du fichier est une cellule de la liste
    procedure file_to_data(f_name : in String; data : in out List);


    -- Opération inverse de file_to_data
    procedure data_to_file(f_name : in String; data : in List);


    -- Crée une nouvelle ligne
    procedure Put(data : in out List; object : in String);


    -- Renvoie le string a la ligne i
    function ligne(data : in List; i : in Integer) return String;


    -- Supprime la liste
    procedure delete(data : in out List);


private
    type cell;
    type List is access cell;
    type cell is
    record
        ligne : Unbounded_String;
        next : List;
    end record;

end File_IO;
