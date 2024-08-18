--**********************************************************************************
--* Sottrazione di numeri signed fixed point con un livello di pipeline
--**********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;

entity subtractor_pipe_sfixed is
    generic (
        M : integer := 3; -- MSB
        N : integer := 50 -- lunghezza numero [bit]
    );
    port (
        CK       : in std_logic;                    -- clock
        D1S, D2S : in sfixed(M downto (M - N + 1)); -- ingressi Q4.46
        QSB      : out sfixed(M downto (M - N + 1)) -- uscita Q4.46
    );
end entity subtractor_pipe_sfixed;

architecture structure of subtractor_pipe_sfixed is

    -- differenza non pipelinata
    signal QSB_async : sfixed(M downto (M - N + 1));

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

    -- N.B. Q3.46 - Q3.46 = Q4.46
    QSB_async <= D1S((M - 1) downto (M - N + 1)) - D2S((M - 1) downto (M - N + 1));

    PIPE : pipe_sfixed
    generic map(M => M, N => N)
    port map(
        ck => CK,
        d  => QSB_async, -- Q4.46
        q  => QSB        -- Q4.46
    );

end architecture structure;