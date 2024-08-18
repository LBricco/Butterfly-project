--**********************************************************************************
--* Multiplexer a due vie con ingressi e uscita su N bit signed fixed point
--* s=0: out_mux = IN_0
--* s=1: out_mux = IN_1
--**********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;

entity mux2to1_sfixed is
    generic (
        M : integer; -- MSB
        N : integer  -- lunghezza numero [bit]
    );
    port (
        s          : in std_logic;                    -- selettore a 1 bit
        IN_0, IN_1 : in sfixed(M downto (M - N + 1)); -- input a N bit Q(M+1).(N-M-1)
        uscita     : out sfixed(M downto (M - N + 1)) -- output a N bit Q(M+1).(N-M-1)
    );
end entity mux2to1_sfixed;

architecture structure of mux2to1_sfixed is
begin
    uscita <= IN_0 when s = '0' else
        IN_1;
end structure;