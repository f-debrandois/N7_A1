with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;

package body Adresse_IP is

  -- Convertir une chaine de caractere en une adresse ip de type T_IP
  function To_Ip(Addresse_IP_String : in Unbounded_String) return T_IP is
    IP : T_IP;
    elem1, elem2, elem3, elem4 : Unbounded_String;
    indice1, indice2, indice3 : Integer;
    UN_OCTET: constant T_IP := 2 ** 8;       -- 256
  begin
    indice1 := index(Addresse_IP_String, ".", 1);
    elem1 := Unbounded_Slice(Addresse_IP_String, 1, indice1-1);
    indice2 := index(Addresse_IP_String, ".",indice1+1);
    elem2 := Unbounded_Slice(Addresse_IP_String, indice1+1, indice2-1);
    indice3 := index(Addresse_IP_String, ".",indice2+1);
    elem3 := Unbounded_Slice(Addresse_IP_String, indice2+1, indice3-1);
    elem4 := Unbounded_Slice(Addresse_IP_String, indice3+1, Length(Addresse_IP_String));

    IP := T_IP'Value(To_String(elem1));
	  IP := IP * UN_OCTET + T_IP'Value(To_String(elem2));
	  IP := IP * UN_OCTET + T_IP'Value(To_String(elem3));
    IP := IP * UN_OCTET + T_IP'Value(To_String(elem4));
    return IP;
  end To_Ip;



  -- convertir une ip 12345567 en adresse de la forme 147.231.44.2
  function Conversion_String(IP1 : in T_IP) return Unbounded_String is
      Addresse_IP_String : Unbounded_String;
      IP2 : T_IP;
      elem1, elem2, elem3, elem4 : Unbounded_String;
      UN_OCTET: constant T_IP := 2 ** 8;       -- 256
  begin
    IP2 := IP1;
    elem1 := To_Unbounded_String ( T_IP(IP2 mod UN_OCTET)'Image);    --Conversion d'un T_Adresse_IP en Integer pour utiliser Put sur Integer
    Trim(elem1,Both);
    
    IP2 := IP2 / UN_OCTET;
    elem2 := To_Unbounded_String ( T_IP(IP2 mod UN_OCTET)'Image);
    Trim(elem2,Both);
    
    IP2 := IP2 / UN_OCTET;
    elem3 := To_Unbounded_String ( T_IP(IP2 mod UN_OCTET)'Image);
    Trim(elem3,Both);
    
    IP2 := IP2 / UN_OCTET;
    elem4 := To_Unbounded_String ( T_IP(IP2 mod UN_OCTET)'Image);
    Trim(elem4,Both);
    
    Addresse_IP_String := elem4 & "." & elem3 & "." & elem2 & "." & elem1;
    return Addresse_IP_String;
  end Conversion_String;
end Adresse_IP;
