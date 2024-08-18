library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_butterfly_debug is
end tb_butterfly_debug;

architecture behavioral of tb_butterfly_debug is

    -- definizione segnali interni
    signal clock  : std_logic            := '0';
    signal reset  : std_logic            := '0';
    signal start  : std_logic            := '0';
    signal done   : std_logic            := '0';
    signal Ar_in  : sfixed(0 downto -23) := (others => '0');
    signal Ai_in  : sfixed(0 downto -23) := (others => '0');
    signal Br_in  : sfixed(0 downto -23) := (others => '0');
    signal Bi_in  : sfixed(0 downto -23) := (others => '0');
    signal Wr_in  : sfixed(0 downto -23) := (others => '0');
    signal Wi_in  : sfixed(0 downto -23) := (others => '0');
    signal Ar_out : sfixed(0 downto -23);
    signal Ai_out : sfixed(0 downto -23);
    signal Br_out : sfixed(0 downto -23);
    signal Bi_out : sfixed(0 downto -23);

    -- dichiarazione UUT
    component butterfly is
        port (
            CK    : in std_logic;
            RST   : in std_logic;
            START : in std_logic;
            DONE  : out std_logic;
            --* porte di ingresso ******************************************************
            Ar : in sfixed(0 downto -23);
            Ai : in sfixed(0 downto -23);
            Br : in sfixed(0 downto -23);
            Bi : in sfixed(0 downto -23);
            Wr : in sfixed(0 downto -23);
            Wi : in sfixed(0 downto -23);
            --* porte di uscita ********************************************************
            Ar_primo : out sfixed(0 downto -23);
            Ai_primo : out sfixed(0 downto -23);
            Br_primo : out sfixed(0 downto -23);
            Bi_primo : out sfixed(0 downto -23)
        );
    end component;

begin

    -- istanza UUT
    uP_BUTTERFLY : butterfly
    port map(
        CK       => clock,
        RST      => reset,
        START    => start,
        DONE     => done,
        Ar       => Ar_in,
        Ai       => Ai_in,
        Br       => Br_in,
        Bi       => Bi_in,
        Wr       => Wr_in,
        Wi       => Wi_in,
        Ar_primo => Ar_out,
        Ai_primo => Ai_out,
        Br_primo => Br_out,
        Bi_primo => Bi_out
    );

    -- process per la generazione del clock
    clk_process : process
    begin
        wait for 50 ns;
        clock <= not clock;
    end process clk_process;

    trial : process
    begin

        reset <= '1';
        wait for 2 ns;
        reset <= '0';

        -- Faccio partire il processore

        -- single
        wait for 100 ns;
        start <= '1';
        Wr_in <= "011111111111111111111111";
        Wi_in <= "000000000000000000000000";
        Ar_in <= to_sfixed(0.5, 0, -23);
        Ai_in <= to_sfixed(0.5, 0, -23);
        Br_in <= to_sfixed(0.5, 0, -23);
        Bi_in <= to_sfixed(0.5, 0, -23);
        wait for 100 ns;
        start <= '0';
        wait for 1500 ns;
        
        -- single
        start <= '1';
        Wr_in <= "011111111111111111111111";
        Wi_in <= "000000000000000000000000";
        Ar_in <= to_sfixed(0.1, 0, -23);
        Ai_in <= to_sfixed(0.1, 0, -23);
        Br_in <= to_sfixed(0.2, 0, -23);
        Bi_in <= to_sfixed(0.2, 0, -23);
        wait for 100 ns;
        start <= '0';
        wait for 1500 ns;

        -- continuous
        start <= '1';
        Wr_in <= "011111111111111111111111";
        Wi_in <= "001111111111111111111111";
        Ar_in <= to_sfixed(0.1, 0, -23);
        Ai_in <= to_sfixed(0.2, 0, -23);
        Br_in <= to_sfixed(0.3, 0, -23);
        Bi_in <= to_sfixed(0.4, 0, -23);
        wait for 100 ns;
        start <= '0';
        wait for 400 ns;
        start <= '1';
        Wr_in <= "011111111111111111111111";
        Wi_in <= "001111111111111111111111";
        Ar_in <= to_sfixed(0.1, 0, -23);
        Ai_in <= to_sfixed(0.1, 0, -23);
        Br_in <= to_sfixed(0.2, 0, -23);
        Bi_in <= to_sfixed(0.2, 0, -23);
        wait for 100 ns;
        start <= '0';
        wait for 1500 ns;
    end process trial;

end behavioral;