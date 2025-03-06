package IP is

    type T_IP is private;

    -- Initialise une adresse ip grace a un string sous la forme d'une adresse IP
    procedure Attribuer(ip : in out T_IP; val : in String := "0.0.0.0");

    -- Retourne une adresse ip sous le type T_IP grace a un string sous la forme d'une adresse IP
    function To_IP(val : in String := "0.0.0.0") return T_IP;

    -- Renvoie la forme String d'une adresse IP Avec les valeurs décimales entre chaque point (Ex : "145.56.5.54")
    function To_String(ip : in T_IP) return String;

    -- Renvoie la forme String d'une adresse IP Avec les valeurs binaires entre chaque point (Ex : "0000 0000.1100 1010.1111 1101.0000 0000")
    function To_Binary_String(ip : in T_IP) return String;

    -- Renvoie la longueur d'un masque
    function mask_length(mask : in T_IP) return Integer;

    -- Compare une adress IP avec une adresse de destination et son masque
    -- Renvoie -1 si ne correspond pas, mask_length(ip_mask) sinon
    function compare(ip_paq : in T_IP; ip_adr : in T_IP; ip_mask : in T_IP) return Integer;

    --procedure Decaler_Gauche(ip : in out T_IP; decalage : in Integer);

    --procedure Decaler_Droite(ip : in out T_IP; decalage : in Integer);

    -- Fonctions de comparaisons ...

private

    type T_IP is mod 2 ** 32;

    UN_OCTET: constant T_IP := 2 ** 8;

end IP;