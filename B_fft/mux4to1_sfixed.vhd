--**********************************************************************************
--* Multiplexer a quattro vie con ingressi e uscita a N bit signed fixed point
--* s=00: out_mux = IN_0 (0)
--* s=01: out_mux = IN_1 (1)
--* s=10: out_mux = IN_2 (2)
--* s=11: out_mux = IN_3 (3)
--**********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;

entity mux4to1_sfixed is
    generic (
        M : integer; -- MSB
        N : integer  -- lunghezza numero [bit]
    );
    port (
        s                      : in std_logic_vector(1 downto 0); -- selettore a 2 bit
        IN_0, IN_1, IN_2, IN_3 : in sfixed(M downto (M - N + 1)); -- input a N bit Q(M+1).(N-M-1)
        uscita                 : out sfixed(M downto (M - N + 1)) -- output a N bit Q(M+1).(N-M-1)
    );
end entity mux4to1_sfixed;

architecture structure of mux4to1_sfixed is
begin
    uscita <=
        IN_0 when s = "00" else --0
        IN_1 when s = "01" else --1
        IN_2 when s = "10" else --2
        IN_3;                   --3
end structure;