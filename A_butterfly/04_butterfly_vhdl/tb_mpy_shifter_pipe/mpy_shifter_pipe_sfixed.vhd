--**********************************************************************************
--* Moltiplicatore/shifter di numeri sfixed fractional point
--* Due livelli di pipeline per il moltiplicatore (M_nS=1)
--* Un livello di pipeline per lo shifter (M_nS=0)
--**********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;

entity mpy_shifter_pipe_sfixed is
    generic (N : integer := 24); -- lunghezza numero [bit]
    port (
        CK       : in std_logic;                      -- clock
        M_nS     : in std_logic;                      -- operation mode (1 mpy, 0 shift)
        D1M, D2M : in sfixed(0 downto (-N + 1));      -- ingressi Q1.23
        QM       : out sfixed(0 downto (-2 * N + 2)); -- uscita moltiplicatore Q1.46
        QSH      : out sfixed(1 downto (-N + 1))      -- uscita shifter Q2.23
    );
end entity mpy_shifter_pipe_sfixed;

architecture structure of mpy_shifter_pipe_sfixed is

    -- definizione segnali interni
    signal QM_async  : sfixed(1 downto (-2 * N + 2)); -- moltiplicazione non pipelinata
    signal QM_pipe1  : sfixed(0 downto (-2 * N + 2)); -- moltiplicazione dopo 1 stadio di pipe
    signal QSH_async : sfixed(1 downto (-N + 1));     -- shift non pieplinato

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

    -- process per scegliere tra moltiplicazione e shift in funzione di M_nS
    -- la sensitivity list deve contenere sia il segnale di controllo, sia gli ingressi del blocco!!!
    MPY_SHIFT_PROCESS: process(M_nS, D1M, D2M)
    begin
        if (M_nS = '1') then -- multiply (N.B. Q1.23 * Q1.23 = Q2.46)
            QM_async  <= D1M * D2M;
            QSH_async <= (others => '0');
        else -- shift
            QM_async <= (others => '0');
            QSH_async <= D1M & '0';
        end if;
    end process MPY_SHIFT_PROCESS;

    PIPE_1_MPY : pipe_sfixed -- primo stadio di pipeline mpy
    generic map(M => 0, N => 2*N-1)
    port map(
        ck => CK,
        d  => QM_async(0 downto (-2 * N + 2)),
        q  => QM_pipe1
    );

    PIPE_2_MPY : pipe_sfixed -- secondo stadio di pipeline mpy
    generic map(M => 0, N => 2*N-1)
    port map(
        ck => CK,
        d  => QM_pipe1,
        q  => QM
    );

    PIPE_SHIFT : pipe_sfixed -- stadio di pipeline shift
    generic map(M => 1, N => N+1)
    port map(
        ck => CK,
        d  => QSH_async,
        q  => QSH
    );

end architecture structure;