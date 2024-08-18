library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_adder_pipe is
end tb_adder_pipe;

architecture behavioral of tb_adder_pipe is

    -- definizione segnali interni
    signal clock      : std_logic := '0';     -- segnale di clock
    signal a, b       : real      := 0.0;     -- addendi in decimale
    signal in_1, in_2 : sfixed(2 downto -46); -- addendi in binario
    signal somma      : sfixed(2 downto -46); -- risultato

    -- definizione file di I/O
    file file_INPUT : text;

    -- dichiarazione UUT
    component adder_pipe_sfixed is
        generic (
            M : integer := 0; -- MSB
            N : integer := 49 -- lunghezza numero [bit]
        );
        port (
            CK       : in std_logic;                    -- clock
            D1A, D2A : in sfixed(M downto (M - N + 1)); -- ingressi
            QA       : out sfixed(M downto (M - N + 1)) -- uscita
        );
    end component;

begin

    in_1 <= to_sfixed(a, 2, -46); -- conversione in Q3.46
    in_2 <= to_sfixed(b, 2, -46); -- conversione in Q3.46

    -- istanza UUT
    adder_pipe : adder_pipe_sfixed
    generic map(M => 2, N => 49)
    port map(
        CK  => clock,
        D1A => in_1,
        D2A => in_2,
        QA  => somma
    );

    -- clock
    clk_process : process
    begin
        wait for 50 ns;
        clock <= not clock;
    end process clk_process;

    -- process per lettura da file e calcoli
    calc_process : process
        variable v_ILINE : line;
        variable v_TERM1 : real;
        variable v_TERM2 : real;
        variable v_SPACE : character;
    begin
        -- Apro file di input in modalità di lettura
        file_open(file_INPUT, "input_data.txt", read_mode);

        while not endfile(file_INPUT) loop
            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_TERM1); -- get first input
            read(v_ILINE, v_SPACE); -- read in the space character
            read(v_ILINE, v_TERM2); -- get second input

            -- Passo le variabili ai corrispondenti segnali per poterle usare nei calcoli
            a <= v_TERM1;
            b <= v_TERM2;

            wait for 100 ns;
        end loop;

        -- Closing In/Out files
        file_close(file_input);

    end process;

end behavioral;