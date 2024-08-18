library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_butterfly is
end tb_butterfly;

architecture behavioral of tb_butterfly is

    -- definizione segnali interni
    signal clock       : std_logic            := '0';
    signal reset       : std_logic            := '0';
    signal start       : std_logic            := '0';
    signal done        : std_logic            := '0';
    signal Ar_in       : sfixed(0 downto -23) := (others => '0');
    signal Ai_in       : sfixed(0 downto -23) := (others => '0');
    signal Br_in       : sfixed(0 downto -23) := (others => '0');
    signal Bi_in       : sfixed(0 downto -23) := (others => '0');
    signal Wr_in       : sfixed(0 downto -23) := (others => '0');
    signal Wi_in       : sfixed(0 downto -23) := (others => '0');
    signal Ar_out      : sfixed(0 downto -23);
    signal Ai_out      : sfixed(0 downto -23);
    signal Br_out      : sfixed(0 downto -23);
    signal Bi_out      : sfixed(0 downto -23);
    signal Ar_out_real : real;
    signal Ai_out_real : real;
    signal Br_out_real : real;
    signal Bi_out_real : real;

    -- definizione file di I/O
    file file_INPUT_W  : text;
    file file_INPUT_AB : text;
    file file_OUTPUT   : text;

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

    -- conversione dei risultati in numeri reali
    Ar_out_real <= to_real(Ar_out);
    Ai_out_real <= to_real(Ai_out);
    Br_out_real <= to_real(Br_out);
    Bi_out_real <= to_real(Bi_out);

    -- process per la generazione del clock
    clk_process : process
    begin
        wait for 50 ns;
        clock <= not clock;
    end process clk_process;

    -- process per lettura da file e calcoli
    calc_process : process

        variable v_ILINE_W  : line;      -- riga file input W
        variable v_ILINE_Ar : line;
        variable v_ILINE_Ai : line;
        variable v_ILINE_Br : line;
        variable v_ILINE_Bi : line;      
        variable v_OLINE    : line;      -- riga file output
        variable v_SPACE    : character; -- carattere spazio

        variable v_Ar : sfixed(0 downto -23);
        variable v_Ai : sfixed(0 downto -23);
        variable v_Br : sfixed(0 downto -23);
        variable v_Bi : sfixed(0 downto -23);
        variable v_Wr : sfixed(0 downto -23);
        variable v_Wi : sfixed(0 downto -23);

    begin
        -- Apro file di input in modalità di lettura
        file_open(file_INPUT_W, "twiddle_W0.txt", read_mode);
        file_open(file_INPUT_AB, "ingressi_L1_W0.txt", read_mode);
        file_open(file_OUTPUT, "risultati_L1_W0_tb.txt", write_mode);

        -- Reset macchina
        reset <= '1';
        wait for 2 ns;
        reset <= '0';

        -- Leggo la coppia di twiddle factor da usare per la simulazione
        readline(file_INPUT_W, v_ILINE_W);
        read(v_ILINE_W, v_Wr);    -- Wr
        read(v_ILINE_W, v_SPACE); -- spazio
        read(v_ILINE_W, v_Wi);    -- Wi

        while not endfile(file_INPUT_AB) loop
            -- Ar --
            readline(file_INPUT_AB, v_ILINE_Ar);
            read(v_ILINE_Ar, v_Ar);
            -- Ai --
            readline(file_INPUT_AB, v_ILINE_Ai);
            read(v_ILINE_Ai, v_Ai);
            -- Br --
            readline(file_INPUT_AB, v_ILINE_Br);
            read(v_ILINE_Br, v_Br);
            -- Bi --
            readline(file_INPUT_AB, v_ILINE_Bi);
            read(v_ILINE_Bi, v_Bi);

            -- Passo le variabili ai corrispondenti segnali per poterle usare nei calcoli
            Wr_in <= v_Wr;
            Wi_in <= v_Wi;
            Ar_in <= v_Ar;
            Ai_in <= v_Ai;
            Br_in <= v_Br;
            Bi_in <= v_Bi;

            -- Faccio partire il processore
            wait for 100 ns;
            start <= '1';
            wait for 100 ns;
            start <= '0';
            wait for 1150 ns;

            -- Scrivo in output_results.txt
            write(v_OLINE, Ar_out_real);
            write(v_OLINE, v_SPACE);
            write(v_OLINE, Ai_out_real);
            write(v_OLINE, v_SPACE);
            write(v_OLINE, Br_out_real);
            write(v_OLINE, v_SPACE);
            write(v_OLINE, Bi_out_real);
            writeline(file_OUTPUT, v_OLINE);

            wait for 350 ns;

        end loop;

        -- Closing In/Out files
        file_close(file_input_W);
        file_close(file_input_AB);
        file_close(file_OUTPUT);

    end process;

end behavioral;