-- Définition d'une adresse ip et ses operations associees.
with Ada.Strings;               use Ada.Strings;	-- pour Both utilisé par Trim
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Command_Line;          use Ada.Command_Line;
with Ada.Exceptions; use Ada.Exceptions;

package Adresse_IP is
    type T_IP is mod 2 ** 32;

	-- Convertir une chaine de caractere en une adresse ip de type T_IP
    function To_Ip(Addresse_IP_String : in Unbounded_String) return T_IP;

     -- convertir une ip 12345567 en adresse de la forme 147.231.44.2
    function Conversion_String(IP1 : in T_IP) return Unbounded_String;
end Adresse_IP;
