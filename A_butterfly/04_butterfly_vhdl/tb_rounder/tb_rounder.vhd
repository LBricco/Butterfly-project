library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_rounder is
end tb_rounder;

architecture behavioral of tb_rounder is

    -- definizione segnali interni
    signal clock  : std_logic := '0';     -- segnale di clock
    signal input  : sfixed(3 downto -46); -- ingresso
    signal output : sfixed(0 downto -23); -- risultato

    -- definizione file di I/O
    file file_INPUT : text;
    file file_OUTPUT : text;

    -- dichiarazione UUT
    component rounder_sfixed is
        generic (
            M : integer := 3; -- MSB
            N : integer := 50 -- lunghezza numero [bit]
        );
        port (
            DR : in sfixed(M downto (M - N + 1)); -- ingresso (default Q4.46)
            QR : out sfixed(0 downto -23)         -- uscita Q1.23
        );
    end component;
begin

    -- istanza UUT
    round_block : rounder_sfixed
    generic map(M => 3, N => 50)
    port map(
        DR => input,
        QR => output
    );

    -- clock
    clk_process : process
    begin
        wait for 50 ns;
        clock <= not clock;
    end process clk_process;

    -- process per lettura da file e calcoli
    calc_process : process
        variable v_ILINE : line; -- riga file di input
        variable v_OLINE : line; -- riga file di output
        variable v_DIN   : sfixed(3 downto -46);

    begin
        -- Apro file di input in modalità di lettura
        file_open(file_INPUT, "input_data.txt", read_mode);
        file_open(file_OUTPUT, "output_results.txt", write_mode);

        while not endfile(file_INPUT) loop
            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_DIN); -- get data in

            -- Passo le variabili ai corrispondenti segnali per poterle usare nei calcoli
            input <= v_DIN;
            wait for 100 ns;

            -- Scrivo in output_results.txt
            write(v_OLINE, output, right, 24);
            writeline(file_OUTPUT, v_OLINE);
        end loop;

        -- Closing In/Out files
        file_close(file_input);

    end process;

end behavioral;