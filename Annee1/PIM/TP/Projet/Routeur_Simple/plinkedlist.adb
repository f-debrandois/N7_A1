with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Unchecked_Deallocation;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

package body PLinkedList is

	procedure Free is
	  new Ada.Unchecked_Deallocation (Object => T_Cell, Name => LinkedList);


	procedure Initialiser(Sda: out LinkedList) is
	begin
		Sda:= null;
	end Initialiser;


	function Est_Vide (Sda : LinkedList) return Boolean is
	begin
		return Sda=null;
	end;


	function Taille (Sda : in LinkedList) return Integer is
		i : Integer;
		pos : LinkedList;
	begin
		pos:=Sda;
		i:=0;
		while pos/=null loop
			i:=i+1;
			pos:=pos.all.next;
		end loop;
		return i;
	end Taille;


	function Suivant(Sda : in LinkedList) return LinkedList is
	begin
		return Sda.all.next;
	end Suivant;


	procedure Enregistrer (Sda : in out LinkedList ; Ip_dest : T_IP; mask :T_IP; sortie : T_Interface) is
	begin
		if Sda=null then
			Sda := new T_Cell'(Ip_dest,mask,sortie,null);
		else
			Enregistrer(Sda.all.next, Ip_dest, mask, sortie);
		end if;
	end Enregistrer;


	procedure Supprimer (Sda : in out LinkedList ; Indice : in Integer) is
		next : LinkedList;
	begin
		if Sda=null or else indice<1 then raise Constraint_Error with "Indice incorrect";
		end if;
		if Indice=1 then
			next := Sda.all.next;
			Free(Sda);
			Sda := next;
		elsif Indice=2 then
			next := Sda.all.next.all.next;
			Free(Sda.all.next);
			Sda.all.next := next;
		else
			Supprimer(Sda.all.next, Indice-1);
		end if;
	end Supprimer;


	procedure Vider (Sda : in out LinkedList) is
		pos,next : LinkedList;
	begin
		next:=null;
		pos:=Sda;
		while (pos/=null) loop
			next:=pos.next;
			Free(pos);
			pos:=next;
		end loop;
		Sda:=null;
	end Vider;


	function Ligne(Sda : in LinkedList; indice : in Integer) return T_Ligne is
		ligne : T_Ligne;
		pos : LinkedList := Sda;
		i : Integer := 1;
	begin
		if Sda=null or else indice<1 then raise Constraint_Error with "Indice incorrect";
		end if;

		while pos/=null and then i<Indice loop
			pos := pos.all.next;
			i:=i+1;
		end loop;

		if pos/=null then
			ligne.dest 		:= pos.all.dest;
			ligne.masque 	:= pos.all.masque;
			ligne.sortie 	:= pos.all.sortie;
			return ligne;
		else raise Constraint_Error with "Indice incorrect";
		end if;
	end Ligne;


	function Ligne(Sda : in LinkedList) return T_Ligne is
		l : T_Ligne;
	begin
		l.dest 		:= Sda.all.dest;
		l.masque 	:= Sda.all.masque;
		l.sortie 	:= Sda.all.sortie;
		return l;
	end Ligne;


	procedure Afficher(Sda : in LinkedList) is
		pos : LinkedList := Sda;
		dest, mask : Unbounded_String;
	begin
		Put_Line("Destination      Masque           Interface");
		while pos/=null loop
			dest := To_Unbounded_String(To_String(pos.all.dest));
			Put(To_String(dest));
			for i in 1..(17-Length(dest)) loop
				Put(' ');
			end loop;
			mask := To_Unbounded_String(To_String(pos.all.masque));
			Put(To_String(mask));
			for i in 1..(17-Length(mask)) loop
				Put(' ');
			end loop;
			Put(To_String(pos.all.sortie));
			New_Line;
			pos := pos.all.next;
		end loop;
	end Afficher;


end PLinkedList;