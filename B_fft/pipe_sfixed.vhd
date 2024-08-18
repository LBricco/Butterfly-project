--**********************************************************************************
--* Registro di pipe per numeri signed fixed point
--**********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;

entity pipe_sfixed is
    generic (
        M : integer := 0; -- MSB
        N : integer := 24 -- lunghezza numero [bit]
    );
    port (
        ck : in std_logic;                    -- clock
        d  : in sfixed(M downto (M - N + 1)); -- ingresso
        q  : out sfixed(M downto (M - N + 1)) -- uscita
    );
end entity pipe_sfixed;

architecture structure of pipe_sfixed is

begin
    CK_process : process (ck)
    begin
        if (ck'event and ck = '1') then
            q <= d;
        end if;
    end process CK_process;

end architecture structure;