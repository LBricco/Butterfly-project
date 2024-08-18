--**********************************************************************************
--* Sommatore di numeri signed fixed point con un livello di pipeline
--**********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;

entity adder_pipe_sfixed is
    generic (
        M : integer := 2; -- MSB
        N : integer := 49 -- lunghezza numero [bit]
    );
    port (
        CK       : in std_logic;                    -- clock
        D1A, D2A : in sfixed(M downto (M - N + 1)); -- ingressi (default Q3.46)
        QA       : out sfixed(M downto (M - N + 1)) -- uscita (default Q3.46)
    );
end entity adder_pipe_sfixed;

architecture structure of adder_pipe_sfixed is

    -- somma non pipelinata
    signal QA_async : sfixed(M downto (M - N + 1));

    -- registro di pipe
    component pipe_sfixed is
        generic (
            M : integer := 0;
            N : integer := 24
        );
        port (
            ck : in std_logic;
            d  : in sfixed(M downto (M - N + 1));
            q  : out sfixed(M downto (M - N + 1))
        );
    end component;

begin

    -- N.B. Q2.46 + Q2.46 = Q3.46
    QA_async <= D1A((M - 1) downto (M - N + 1)) + D2A((M - 1) downto (M - N + 1));

    PIPE : pipe_sfixed
    generic map(M => M, N => N)
    port map(
        ck => CK,
        d  => QA_async, -- default Q3.46
        q  => QA        -- default Q3.46
    );

end architecture structure;