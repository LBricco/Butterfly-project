library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_fft is
end tb_fft;

architecture behavioral of tb_fft is

    -- definizione segnali interni
    signal clock                : std_logic            := '0';
    signal reset                : std_logic            := '0';
    signal start                : std_logic            := '0';
    signal done                 : std_logic            := '0';
    signal Xr_in_0, Xi_in_0     : sfixed(0 downto -23) := (others => '0');
    signal Xr_in_1, Xi_in_1     : sfixed(0 downto -23) := (others => '0');
    signal Xr_in_2, Xi_in_2     : sfixed(0 downto -23) := (others => '0');
    signal Xr_in_3, Xi_in_3     : sfixed(0 downto -23) := (others => '0');
    signal Xr_in_4, Xi_in_4     : sfixed(0 downto -23) := (others => '0');
    signal Xr_in_5, Xi_in_5     : sfixed(0 downto -23) := (others => '0');
    signal Xr_in_6, Xi_in_6     : sfixed(0 downto -23) := (others => '0');
    signal Xr_in_7, Xi_in_7     : sfixed(0 downto -23) := (others => '0');
    signal Xr_in_8, Xi_in_8     : sfixed(0 downto -23) := (others => '0');
    signal Xr_in_9, Xi_in_9     : sfixed(0 downto -23) := (others => '0');
    signal Xr_in_10, Xi_in_10   : sfixed(0 downto -23) := (others => '0');
    signal Xr_in_11, Xi_in_11   : sfixed(0 downto -23) := (others => '0');
    signal Xr_in_12, Xi_in_12   : sfixed(0 downto -23) := (others => '0');
    signal Xr_in_13, Xi_in_13   : sfixed(0 downto -23) := (others => '0');
    signal Xr_in_14, Xi_in_14   : sfixed(0 downto -23) := (others => '0');
    signal Xr_in_15, Xi_in_15   : sfixed(0 downto -23) := (others => '0');
    signal Yr_out_0, Yi_out_0   : sfixed(0 downto -23);
    signal Yr_out_1, Yi_out_1   : sfixed(0 downto -23);
    signal Yr_out_2, Yi_out_2   : sfixed(0 downto -23);
    signal Yr_out_3, Yi_out_3   : sfixed(0 downto -23);
    signal Yr_out_4, Yi_out_4   : sfixed(0 downto -23);
    signal Yr_out_5, Yi_out_5   : sfixed(0 downto -23);
    signal Yr_out_6, Yi_out_6   : sfixed(0 downto -23);
    signal Yr_out_7, Yi_out_7   : sfixed(0 downto -23);
    signal Yr_out_8, Yi_out_8   : sfixed(0 downto -23);
    signal Yr_out_9, Yi_out_9   : sfixed(0 downto -23);
    signal Yr_out_10, Yi_out_10 : sfixed(0 downto -23);
    signal Yr_out_11, Yi_out_11 : sfixed(0 downto -23);
    signal Yr_out_12, Yi_out_12 : sfixed(0 downto -23);
    signal Yr_out_13, Yi_out_13 : sfixed(0 downto -23);
    signal Yr_out_14, Yi_out_14 : sfixed(0 downto -23);
    signal Yr_out_15, Yi_out_15 : sfixed(0 downto -23);

    -- definizione file di I/O
    file file_INPUT  : text;

    -- dichiarazione UUT
    component FFT_16 is
        port (
            CK    : in std_logic;
            RST   : in std_logic;
            START : in std_logic;
            DONE  : out std_logic;
            --* porte di ingresso ******************************************************
            Xr_0, Xi_0   : in sfixed(0 downto -23); -- X_0
            Xr_1, Xi_1   : in sfixed(0 downto -23); -- X_1
            Xr_2, Xi_2   : in sfixed(0 downto -23); -- X_2
            Xr_3, Xi_3   : in sfixed(0 downto -23); -- X_3
            Xr_4, Xi_4   : in sfixed(0 downto -23); -- X_4
            Xr_5, Xi_5   : in sfixed(0 downto -23); -- X_5
            Xr_6, Xi_6   : in sfixed(0 downto -23); -- X_6
            Xr_7, Xi_7   : in sfixed(0 downto -23); -- X_7
            Xr_8, Xi_8   : in sfixed(0 downto -23); -- X_8
            Xr_9, Xi_9   : in sfixed(0 downto -23); -- X_9
            Xr_10, Xi_10 : in sfixed(0 downto -23); -- X_10
            Xr_11, Xi_11 : in sfixed(0 downto -23); -- X_11
            Xr_12, Xi_12 : in sfixed(0 downto -23); -- X_12
            Xr_13, Xi_13 : in sfixed(0 downto -23); -- X_13
            Xr_14, Xi_14 : in sfixed(0 downto -23); -- X_14
            Xr_15, Xi_15 : in sfixed(0 downto -23); -- X_15
            --* porte di uscita ********************************************************
            Yr_0, Yi_0   : out sfixed(0 downto -23); -- Y_0
            Yr_1, Yi_1   : out sfixed(0 downto -23); -- Y_1
            Yr_2, Yi_2   : out sfixed(0 downto -23); -- Y_2
            Yr_3, Yi_3   : out sfixed(0 downto -23); -- Y_3
            Yr_4, Yi_4   : out sfixed(0 downto -23); -- Y_4
            Yr_5, Yi_5   : out sfixed(0 downto -23); -- Y_5
            Yr_6, Yi_6   : out sfixed(0 downto -23); -- Y_6
            Yr_7, Yi_7   : out sfixed(0 downto -23); -- Y_7
            Yr_8, Yi_8   : out sfixed(0 downto -23); -- Y_8
            Yr_9, Yi_9   : out sfixed(0 downto -23); -- Y_9
            Yr_10, Yi_10 : out sfixed(0 downto -23); -- Y_10
            Yr_11, Yi_11 : out sfixed(0 downto -23); -- Y_11
            Yr_12, Yi_12 : out sfixed(0 downto -23); -- Y_12
            Yr_13, Yi_13 : out sfixed(0 downto -23); -- Y_13
            Yr_14, Yi_14 : out sfixed(0 downto -23); -- Y_14
            Yr_15, Yi_15 : out sfixed(0 downto -23)  -- Y_15
        );
    end component;

begin

    -- istanza UUT
    FFT_calculator : FFT_16
    port map(
        CK    => clock,
        RST   => reset,
        START => start,
        DONE  => done,
        Xr_0 => Xr_in_0, Xi_0 => Xi_in_0,
        Xr_1 => Xr_in_1, Xi_1 => Xi_in_1,
        Xr_2 => Xr_in_2, Xi_2 => Xi_in_2,
        Xr_3 => Xr_in_3, Xi_3 => Xi_in_3,
        Xr_4 => Xr_in_4, Xi_4 => Xi_in_4,
        Xr_5 => Xr_in_5, Xi_5 => Xi_in_5,
        Xr_6 => Xr_in_6, Xi_6 => Xi_in_6,
        Xr_7 => Xr_in_7, Xi_7 => Xi_in_7,
        Xr_8 => Xr_in_8, Xi_8 => Xi_in_8,
        Xr_9 => Xr_in_9, Xi_9 => Xi_in_9,
        Xr_10 => Xr_in_10, Xi_10 => Xi_in_10,
        Xr_11 => Xr_in_11, Xi_11 => Xi_in_11,
        Xr_12 => Xr_in_12, Xi_12 => Xi_in_12,
        Xr_13 => Xr_in_13, Xi_13 => Xi_in_13,
        Xr_14 => Xr_in_14, Xi_14 => Xi_in_14,
        Xr_15 => Xr_in_15, Xi_15 => Xi_in_15,
        Yr_0 => Yr_out_0, Yi_0 => Yi_out_0,
        Yr_1 => Yr_out_1, Yi_1 => Yi_out_1,
        Yr_2 => Yr_out_2, Yi_2 => Yi_out_2,
        Yr_3 => Yr_out_3, Yi_3 => Yi_out_3,
        Yr_4 => Yr_out_4, Yi_4 => Yi_out_4,
        Yr_5 => Yr_out_5, Yi_5 => Yi_out_5,
        Yr_6 => Yr_out_6, Yi_6 => Yi_out_6,
        Yr_7 => Yr_out_7, Yi_7 => Yi_out_7,
        Yr_8 => Yr_out_8, Yi_8 => Yi_out_8,
        Yr_9 => Yr_out_9, Yi_9 => Yi_out_9,
        Yr_10 => Yr_out_10, Yi_10 => Yi_out_10,
        Yr_11 => Yr_out_11, Yi_11 => Yi_out_11,
        Yr_12 => Yr_out_12, Yi_12 => Yi_out_12,
        Yr_13 => Yr_out_13, Yi_13 => Yi_out_13,
        Yr_14 => Yr_out_14, Yi_14 => Yi_out_14,
        Yr_15 => Yr_out_15, Yi_15 => Yi_out_15
    );

    -- process per la generazione del clock
    clk_process : process
    begin
        wait for 50 ns;
        clock <= not clock;
    end process clk_process;

    -- process per lettura da file e calcoli
    calc_process : process

        variable v_ILINE : line;      -- riga file input
        variable v_OLINE : line;      -- riga file output
        variable v_SPACE : character; -- carattere spazio

        variable v_Xr_in_0, v_Xi_in_0   : sfixed(0 downto -23);
        variable v_Xr_in_1, v_Xi_in_1   : sfixed(0 downto -23);
        variable v_Xr_in_2, v_Xi_in_2   : sfixed(0 downto -23);
        variable v_Xr_in_3, v_Xi_in_3   : sfixed(0 downto -23);
        variable v_Xr_in_4, v_Xi_in_4   : sfixed(0 downto -23);
        variable v_Xr_in_5, v_Xi_in_5   : sfixed(0 downto -23);
        variable v_Xr_in_6, v_Xi_in_6   : sfixed(0 downto -23);
        variable v_Xr_in_7, v_Xi_in_7   : sfixed(0 downto -23);
        variable v_Xr_in_8, v_Xi_in_8   : sfixed(0 downto -23);
        variable v_Xr_in_9, v_Xi_in_9   : sfixed(0 downto -23);
        variable v_Xr_in_10, v_Xi_in_10 : sfixed(0 downto -23);
        variable v_Xr_in_11, v_Xi_in_11 : sfixed(0 downto -23);
        variable v_Xr_in_12, v_Xi_in_12 : sfixed(0 downto -23);
        variable v_Xr_in_13, v_Xi_in_13 : sfixed(0 downto -23);
        variable v_Xr_in_14, v_Xi_in_14 : sfixed(0 downto -23);
        variable v_Xr_in_15, v_Xi_in_15 : sfixed(0 downto -23);

    begin
        -- Apro file di I/O
        file_open(file_INPUT, "input_data_fft.txt", read_mode);

        -- Reset macchina
        reset <= '1';
        wait for 2 ns;
        reset <= '0';

        while not endfile(file_INPUT) loop

            -- Leggo da file di input
            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_Xr_in_0); -- get first input
            read(v_ILINE, v_SPACE);   -- read in the space character
            read(v_ILINE, v_Xi_in_0); -- get second input

            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_Xr_in_1); -- get first input
            read(v_ILINE, v_SPACE);   -- read in the space character
            read(v_ILINE, v_Xi_in_1); -- get second input

            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_Xr_in_2); -- get first input
            read(v_ILINE, v_SPACE);   -- read in the space character
            read(v_ILINE, v_Xi_in_2); -- get second input

            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_Xr_in_3); -- get first input
            read(v_ILINE, v_SPACE);   -- read in the space character
            read(v_ILINE, v_Xi_in_3); -- get second input

            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_Xr_in_4); -- get first input
            read(v_ILINE, v_SPACE);   -- read in the space character
            read(v_ILINE, v_Xi_in_4); -- get second input

            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_Xr_in_5); -- get first input
            read(v_ILINE, v_SPACE);   -- read in the space character
            read(v_ILINE, v_Xi_in_5); -- get second input

            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_Xr_in_6); -- get first input
            read(v_ILINE, v_SPACE);   -- read in the space character
            read(v_ILINE, v_Xi_in_6); -- get second input

            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_Xr_in_7); -- get first input
            read(v_ILINE, v_SPACE);   -- read in the space character
            read(v_ILINE, v_Xi_in_7); -- get second input

            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_Xr_in_8); -- get first input
            read(v_ILINE, v_SPACE);   -- read in the space character
            read(v_ILINE, v_Xi_in_8); -- get second input

            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_Xr_in_9); -- get first input
            read(v_ILINE, v_SPACE);   -- read in the space character
            read(v_ILINE, v_Xi_in_9); -- get second input

            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_Xr_in_10); -- get first input
            read(v_ILINE, v_SPACE);    -- read in the space character
            read(v_ILINE, v_Xi_in_10); -- get second input

            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_Xr_in_11); -- get first input
            read(v_ILINE, v_SPACE);    -- read in the space character
            read(v_ILINE, v_Xi_in_11); -- get second input

            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_Xr_in_12); -- get first input
            read(v_ILINE, v_SPACE);    -- read in the space character
            read(v_ILINE, v_Xi_in_12); -- get second input

            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_Xr_in_13); -- get first input
            read(v_ILINE, v_SPACE);    -- read in the space character
            read(v_ILINE, v_Xi_in_13); -- get second input

            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_Xr_in_14); -- get first input
            read(v_ILINE, v_SPACE);    -- read in the space character
            read(v_ILINE, v_Xi_in_14); -- get second input

            readline(file_INPUT, v_ILINE);
            read(v_ILINE, v_Xr_in_15); -- get first input
            read(v_ILINE, v_SPACE);    -- read in the space character
            read(v_ILINE, v_Xi_in_15); -- get second input

            -- Passo le variabili ai corrispondenti segnali per poterle usare nei calcoli
            Xr_in_0  <= v_Xr_in_0;
            Xi_in_0  <= v_Xi_in_0;
            Xr_in_1  <= v_Xr_in_1;
            Xi_in_1  <= v_Xi_in_1;
            Xr_in_2  <= v_Xr_in_2;
            Xi_in_2  <= v_Xi_in_2;
            Xr_in_3  <= v_Xr_in_3;
            Xi_in_3  <= v_Xi_in_3;
            Xr_in_4  <= v_Xr_in_4;
            Xi_in_4  <= v_Xi_in_4;
            Xr_in_5  <= v_Xr_in_5;
            Xi_in_5  <= v_Xi_in_5;
            Xr_in_6  <= v_Xr_in_6;
            Xi_in_6  <= v_Xi_in_6;
            Xr_in_7  <= v_Xr_in_7;
            Xi_in_7  <= v_Xi_in_7;
            Xr_in_8  <= v_Xr_in_8;
            Xi_in_8  <= v_Xi_in_8;
            Xr_in_9  <= v_Xr_in_9;
            Xi_in_9  <= v_Xi_in_9;
            Xr_in_10 <= v_Xr_in_10;
            Xi_in_10 <= v_Xi_in_10;
            Xr_in_11 <= v_Xr_in_11;
            Xi_in_11 <= v_Xi_in_11;
            Xr_in_12 <= v_Xr_in_12;
            Xi_in_12 <= v_Xi_in_12;
            Xr_in_13 <= v_Xr_in_13;
            Xi_in_13 <= v_Xi_in_13;
            Xr_in_14 <= v_Xr_in_14;
            Xi_in_14 <= v_Xi_in_14;
            Xr_in_15 <= v_Xr_in_15;
            Xi_in_15 <= v_Xi_in_15;

            -- Faccio partire il processore
            wait for 100 ns;
            start <= '1';
            wait for 100 ns;
            start <= '0';
            wait for 7000 ns;

        end loop;

        -- Closing In/Out files
        file_close(file_INPUT);

    end process;

end behavioral;