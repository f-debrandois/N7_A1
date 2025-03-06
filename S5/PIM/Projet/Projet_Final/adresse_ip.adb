with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

-- Operations sur les adresses IP

package body Adresse_IP is  

    procedure Attribuer(ip : in out T_IP; val : in String := "0.0.0.0") is
        c : Integer := 1;
        old : Integer;
        ip_o : T_IP := 0;
    begin

        for i in 1..4 loop
            old := c;
            while c<=val'Length and then val(c) /= '.' loop
                c := c+1;
            end loop;
 
            if Integer'Value(val(old..c-1))<0 or else Integer'Value(val(old..c-1)) > 255 then 
                raise Constraint_Error with "Byte value error while building ip adress";
            end if;

            ip_o := ip_o + T_IP'Mod(Integer'Value(val(old..c-1)));

            if i /= 4 then 
                ip_o := ip_o*UN_OCTET;
            end if;

            c := c+1;
        end loop;

        ip := ip_o;
    end Attribuer;


    function To_IP(val : in String := "0.0.0.0") return T_IP is
        c : Integer := 1;
        old : Integer;
        ip_o : T_IP := 0;
    begin
        for i in 1..4 loop
            old := c;
            while c<=val'Length and then val(c) /= '.' loop
                c := c+1;
            end loop;
 
            if Integer'Value(val(old..c-1))<0 or else Integer'Value(val(old..c-1)) > 255 then raise Constraint_Error with "Byte value error while building ip adress";
            end if;
            ip_o := ip_o + T_IP'Mod(Integer'Value(val(old..c-1)));

            if i /= 4 then 
                ip_o := ip_o*UN_OCTET;
            end if;

            c := c+1;
        end loop;

       return ip_o;
    end To_IP;


    function To_String(ip : in T_IP) return String is
        out_s,res : Unbounded_String;
        x : T_IP := ip;
    begin
        out_s := To_Unbounded_String("");
        for i in 1..4 loop

            res := To_Unbounded_String(T_IP'Image(x mod UN_OCTET));
            if i/=1 then
                out_s := Unbounded_Slice(res,2,length(res)) & '.' & out_s;
            else 
                out_s := Unbounded_Slice(res,2,length(res));
            end if;

            x := x/UN_OCTET;

        end loop;
        return To_String(out_s);
    end To_String;


    function To_Binary_String(ip : in T_IP) return String is
        out_s : Unbounded_String;
        x : T_IP := ip;
    begin
        out_s := To_Unbounded_String("");
        for i in 0..31 loop

            if i/=0 and then i mod 8 = 0 then
                out_s := '.' & out_s;
            end if;

            if x mod 2 = 0 then
                out_s := '0' & out_s;
            else
                out_s := '1' & out_s;
            end if;

            x := x/2;

        end loop;

        return To_String(out_s);
        
    end To_Binary_String;


    function mask_length(mask : in T_IP) return Integer is
        l : Integer := 31;
        s : T_IP := 2;
    begin
        if mask=0 then
            return 0;
        end if;
        s := s ** l;
        while mask>s loop
            l := l-1;
            s := s + 2 ** l;
        end loop;
        return 31-l+1;
    end mask_length;


    function compare(ip_paq : in T_IP; ip_adr : in T_IP; ip_mask : in T_IP) return Integer is
    begin
        if (ip_paq and ip_mask) = ip_adr then
            return mask_length(ip_mask);
        end if;
        return -1;
    end compare;

end Adresse_IP;
