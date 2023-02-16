-- Définition d'une adresse IP
with Ada.Strings;               use Ada.Strings;
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Command_Line;          use Ada.Command_Line;
with Ada.Exceptions; use Ada.Exceptions;

package Adresse_IP is
    type T_IP is mod 2 ** 32;

	-- Conversion d'une chaîne de caractères en adresse IP
    function To_Ip(Addresse_IP_String : in Unbounded_String) return T_IP;

     -- Conversion d'une chaîne de caractères de la forme 147231442 en adresse de la forme 147.231.44.2
    function Conversion_String(IP1 : in T_IP) return Unbounded_String;
end Adresse_IP;
