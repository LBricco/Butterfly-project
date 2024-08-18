library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_mpy_shifter_pipe is
end tb_mpy_shifter_pipe;

architecture behavioral of tb_mpy_shifter_pipe is

    -- definizione segnali interni
    signal clock      : std_logic := '0';     -- segnale di clock
    signal mode       : std_logic := '1';     -- multiply/shift
    signal a, b       : real;                 -- ingressi in decimale
    signal in_1, in_2 : sfixed(0 downto -23); -- ingressi in binario
    signal mpy        : sfixed(0 downto -46); -- risultato moltiplicazione
    signal shift      : sfixed(1 downto -23); -- risultato shift

    -- definizione file di I/O
    file file_INPUT : text;

    -- dichiarazione UUT
    component mpy_shifter_pipe_sfixed is
        generic (N : integer := 24); -- lunghezza numero [bit]
        port (
            CK       : in std_logic;                      -- clock
            M_nS     : in std_logic;                      -- operation mode (1 mpy, 0 shift)
            D1M, D2M : in sfixed(0 downto (-N + 1));      -- ingressi Q1.23
            QM       : out sfixed(0 downto (-2 * N + 2)); -- uscita moltiplicatore Q1.46
            QSH      : out sfixed(1 downto (-N + 1))      -- uscita shifter Q2.23
        );
    end component;

begin

    in_1 <= to_sfixed(a, 0, -23); -- conversione in Q1.23
    in_2 <= to_sfixed(b, 0, -23); -- conversione in Q1.23

    -- istanza UUT
    mpy_shifter_pipe : mpy_shifter_pipe_sfixed
    generic map(N => 24)
    port map(
        CK   => clock,
        M_nS => mode,
        D1M  => in_1,
        D2M  => in_2,
        QM   => mpy,
        QSH  => shift
    );

    -- clock
    clk_process : process
    begin
        wait for 50 ns;
        clock <= not clock;
    end process clk_process;

    -- process per test blocchetto
    mpy_shift_process : process
        variable v_ILINE : line;
        variable v_TERM1 : real;
        variable v_TERM2 : real;
        variable v_SPACE : character;
    begin
        -- Apro file di input per test modalità "moltiplicatore"
        file_open(file_INPUT, "input_data.txt", read_mode);

        while not endfile(file_INPUT) loop
            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_TERM1); -- get first input
            read(v_ILINE, v_SPACE); -- read in the space character
            read(v_ILINE, v_TERM2); -- get second input

            -- Passo le variabili ai corrispondenti segnali per poterle usare nei calcoli
            a <= v_TERM1;
            b <= v_TERM2;

            mode <= '1';
            wait for 100 ns;

        end loop;

        -- Chiudo file di input
        file_close(file_INPUT);

        -- Apro file di input per test modalità "shifter"
        file_open(file_INPUT, "input_data.txt", read_mode);

        while not endfile(file_INPUT) loop
            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_TERM1); -- get first input
            read(v_ILINE, v_SPACE); -- read in the space character
            read(v_ILINE, v_TERM2); -- get second input

            -- Passo le variabili ai corrispondenti segnali per poterle usare nei calcoli
            a <= v_TERM1;
            b <= v_TERM2;

            mode <= '0';
            wait for 100 ns;

        end loop;

        -- Chiudo file di input
        file_close(file_INPUT);

    end process mpy_shift_process;

end behavioral;