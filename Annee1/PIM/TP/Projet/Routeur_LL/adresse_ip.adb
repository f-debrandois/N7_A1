with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;

package body Adresse_IP is

  -- Conversion d'une chaîne de caractères en adresse IP
  function To_Ip(Addresse_IP_String : in Unbounded_String) return T_IP is
    IP : T_IP;
    ind1, ind2, ind3 : Integer;
    el1, el2, el3, el4 : Unbounded_String;
    octet: constant T_IP := 2 ** 8;       
  begin
    ind1 := index(Addresse_IP_String, ".", 1);
    el1 := Unbounded_Slice(Addresse_IP_String, 1, ind1-1);
    ind2 := index(Addresse_IP_String, ".",ind1+1);
    el2 := Unbounded_Slice(Addresse_IP_String, ind1+1, ind2-1);
    ind3 := index(Addresse_IP_String, ".",ind2+1);
    el3 := Unbounded_Slice(Addresse_IP_String, ind2+1, ind3-1);
    el4 := Unbounded_Slice(Addresse_IP_String, ind3+1, Length(Addresse_IP_String));
    IP := T_IP'Value(To_String(el1));
	  IP := IP * octet + T_IP'Value(To_String(el2));
	  IP := IP * octet + T_IP'Value(To_String(el3));
    IP := IP * octet + T_IP'Value(To_String(el4));
    return IP;
  end To_Ip;

  -- Conversion d'une chaîne de caractères de la forme 147231442 en adresse de la forme 147.231.44.2
  function Conversion_String(IP1 : in T_IP) return Unbounded_String is
      Addresse_IP_String : Unbounded_String;
      IP2 : T_IP;
      el1, el2, el3, el4 : Unbounded_String;
      octet: constant T_IP := 2 ** 8;      
  begin
    IP2 := IP1;
  -- Conversion d'une adresse IP en entier pour utiliser la commande Put 
    el1 := To_Unbounded_String ( T_IP(IP2 mod octet)'Image);   
    Trim(el1,Both); 
    IP2 := IP2 / octet;
    el2 := To_Unbounded_String ( T_IP(IP2 mod octet)'Image);
    Trim(el2,Both);
    IP2 := IP2 / octet;
    el3 := To_Unbounded_String ( T_IP(IP2 mod octet)'Image);
    Trim(el3,Both);
    IP2 := IP2 / octet;
    el4 := To_Unbounded_String ( T_IP(IP2 mod octet)'Image);
    Trim(el4,Both);
    Addresse_IP_String := el4 & "." & el3 & "." & el2 & "." & el1;
    return Addresse_IP_String;
  end Conversion_String;
end Adresse_IP;
