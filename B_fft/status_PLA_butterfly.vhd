--**********************************************************************************
--* Status PLA processore Butterfly
--**********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity status_PLA_butterfly is
    port (
        START : in std_logic;
        CC1   : in std_logic_vector(1 downto 0); -- condition code 1
        CC2   : in std_logic_vector(1 downto 0); -- condition code 2
        s     : out std_logic_vector(1 downto 0) -- selettore mux
    );
end entity status_PLA_butterfly;

architecture structure of status_PLA_butterfly is

    signal x1, x2, x3, x4, x5 : std_logic;
    signal s0, s1, s2         : std_logic;

begin

    x1 <= CC1(1);
    x2 <= CC1(0);
    x3 <= CC2(1);
    x4 <= CC2(0);
    x5 <= START;

    s0 <= (not x2) and (not x3) and (not x4) and ((not x1) or (x1 and x5));
    s1 <= ((not x3) and (not x4) and (((not x1) and x2) or (x1 and (not x2) and (not x5)))) or (x1 and x2 and x3 and (not x4) and x5);
    s2 <= x1 and x2 and x3 and (not x4) and (not x5);

    ADD_PROCESS : process (s0, s1, s2)
    begin
        if (s0 = '1') then
            s <= "00";
        elsif (s1 = '1') then
            s <= "01";
        elsif (s2 = '1') then
            s <= "10";
        end if;
    end process ADD_PROCESS;

end architecture structure;