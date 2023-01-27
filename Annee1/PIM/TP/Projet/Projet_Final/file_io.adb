with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings;               use Ada.Strings;	-- pour Both utilisé par Trim
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Unchecked_Deallocation;

-- Gestion des opérations relatives à la manipulation de fichiers

package body File_IO is

    procedure Free is
	  new Ada.Unchecked_Deallocation (Object => cell, Name => List);


    procedure init(data : out List) is
    begin
        data := null;
    end init;


    -- Convertit un fichier txt en liste chainée ou chaque ligne du fichier est une cellule de la liste
    procedure file_to_data(f_name : in String; data : in out List) is
        f : File_type;
        line : Unbounded_String;
        pos,n : List;
    begin
        Open(f,In_File,f_name);
        
        while not End_Of_File(f) loop
            line := Get_Line(f);
            Trim(line,Both);

            if pos = null then
                data := new cell'(line,null);
                pos := data;
            else
                n := new cell'(line,null);
                pos.all.next := n;
                pos := n;
            end if;
        end loop;

        Close(f);
    end file_to_data;


    -- Opération inverse de file_to_data
    procedure data_to_file(f_name : in String; data : in List) is
        pos : List := data;
        f : File_Type;
    begin
        Create(f, Out_File, f_name);

        while pos/=null loop
            Put_Line(f,pos.all.ligne);
            pos := pos.all.next;
        end loop;

        Close(f);
    end data_to_file;


    -- Crée une nouvelle ligne
    procedure Put(data : in out List; object : in String) is
        pos,n : List := data;
    begin
        while pos/=null loop
            if pos.all.next = null then
                n := new cell'(To_Unbounded_String(object),null);
                pos.all.next := n;
            end if;
            pos := pos.all.next;
        end loop;
    end Put;


    -- Renvoie le string a la ligne i
    function ligne(data : in List; i : in Integer) return String is
        pos : List := data;
        j : Integer := 1;
    begin
        while pos/=null and then j<i loop
            pos := pos.all.next;
            j := j+1;
        end loop;

        if j<i then
            return "";
        else
            return To_String(pos.all.ligne);
        end if;
    end ligne;


    -- Supprime la liste
    procedure delete(data : in out List) is
        pos : List := data;
        s : List;
    begin
        while pos/=null loop
            s := pos.all.next;
            Free(pos);
            pos := s;
        end loop;
    end delete;

end File_IO;
