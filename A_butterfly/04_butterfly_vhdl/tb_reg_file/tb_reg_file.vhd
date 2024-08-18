library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_reg_file is
end tb_reg_file;

architecture behavioral of tb_reg_file is

    -- definizione segnali interni
    signal clock    : std_logic := '0'; -- segnale di clock
    signal in_24    : sfixed(0 downto -23);
    signal in_50    : sfixed(3 downto -46);
    signal a, b     : real                         := 0.0;
    signal W_1      : std_logic                    := '0';
    signal W_2      : std_logic                    := '0';
    signal W_3      : std_logic                    := '0';
    signal W_4      : std_logic                    := '0';
    signal W_5      : std_logic                    := '0';
    signal W_6      : std_logic                    := '0';
    signal s_3      : std_logic                    := '0';
    signal s_5      : std_logic_vector(1 downto 0) := "00";
    signal s_6      : std_logic                    := '0';
    signal s_D1M    : std_logic_vector(1 downto 0) := "00";
    signal s_D2M    : std_logic                    := '0';
    signal s_D1AS   : std_logic                    := '0';
    signal Wr       : sfixed(0 downto -23)         := (others => '0');
    signal Wi       : sfixed(0 downto -23)         := (others => '0');
    signal Ar       : sfixed(0 downto -23)         := (others => '0');
    signal Ai       : sfixed(0 downto -23)         := (others => '0');
    signal Br       : sfixed(0 downto -23)         := (others => '0');
    signal Bi       : sfixed(0 downto -23)         := (others => '0');
    signal QAS      : sfixed(3 downto -46)         := (others => '0');
    signal QR       : sfixed(0 downto -23)         := (others => '0');
    signal Br_primo : sfixed(0 downto -23);
    signal Bi_primo : sfixed(0 downto -23);
    signal D1M      : sfixed(0 downto -23);
    signal D2M      : sfixed(0 downto -23);
    signal D1AS     : sfixed(3 downto -46);
    signal DR       : sfixed(3 downto -46);

    -- dichiarazione UUT
    component register_file is
        port (
            CK : in std_logic;
            --* segnali di controllo ***************************************************
            WR_R1 : in std_logic;
            WR_R2 : in std_logic;
            WR_R3 : in std_logic;
            WR_R4 : in std_logic;
            WR_R5 : in std_logic;
            WR_R6 : in std_logic;
            ----------------------------------------------------------------------------
            s_R3 : in std_logic;
            s_R5 : in std_logic_vector(1 downto 0);
            s_R6 : in std_logic;
            ----------------------------------------------------------------------------
            s_1M  : in std_logic_vector(1 downto 0);
            s_2M  : in std_logic;
            s_1AS : in std_logic;
            --* porte di ingresso ******************************************************
            D_Wr : in sfixed(0 downto -23);
            D_Wi : in sfixed(0 downto -23);
            ----------------------------------------------------------------------------
            D_Ar : in sfixed(0 downto -23);
            D_Ai : in sfixed(0 downto -23);
            D_Br : in sfixed(0 downto -23);
            D_Bi : in sfixed(0 downto -23);
            ----------------------------------------------------------------------------
            IN_AS : in sfixed(3 downto -46);
            IN_R  : in sfixed(0 downto -23);
            --* porte di uscita ********************************************************
            Q_Br : out sfixed(0 downto -23);
            Q_Bi : out sfixed(0 downto -23);
            ----------------------------------------------------------------------------
            OUT_1M  : out sfixed(0 downto -23);
            OUT_2M  : out sfixed(0 downto -23);
            OUT_1AS : out sfixed(3 downto -46);
            OUT_R   : out sfixed(3 downto -46)
        );
    end component;

begin

    -- istanza UUT
    reg_file : register_file
    port map(
        CK => clock,
        --* segnali di controllo ***************************************************
        WR_R1 => W_1,
        WR_R2 => W_2,
        WR_R3 => W_3,
        WR_R4 => W_4,
        WR_R5 => W_5,
        WR_R6 => W_6,
        ----------------------------------------------------------------------------
        s_R3 => s_3,
        s_R5 => s_5,
        s_R6 => s_6,
        ----------------------------------------------------------------------------
        s_1M  => s_D1M,
        s_2M  => s_D2M,
        s_1AS => s_D1AS,
        --* porte di ingresso ******************************************************
        D_Wr => Wr,
        D_Wi => Wi,
        ----------------------------------------------------------------------------
        D_Ar => Ar,
        D_Ai => Ai,
        D_Br => Br,
        D_Bi => Bi,
        ----------------------------------------------------------------------------
        IN_AS => QAS,
        IN_R  => QR,
        --* porte di uscita ********************************************************
        Q_Br => Br_primo,
        Q_Bi => Bi_primo,
        ----------------------------------------------------------------------------
        OUT_1M  => D1M,
        OUT_2M  => D2M,
        OUT_1AS => D1AS,
        OUT_R   => DR
    );

    in_24 <= to_sfixed(a, 0, -23);
    in_50 <= to_sfixed(b, 3, -46);

    Wr  <= in_24;
    Wi  <= in_24;
    Ar  <= in_24;
    Ai  <= in_24;
    Br  <= in_24;
    Bi  <= in_24;
    QAS <= in_50;
    QR  <= in_24;

    -- clock
    clk_process : process
    begin
        wait for 50 ns;
        clock <= not clock;
    end process clk_process;

    -- process per test blocchetto
    reg_test_process : process
    begin
        a   <= 0.1;
        b   <= 0.2;
        W_1 <= '1';
        wait for 100 ns;
        W_1 <= '0';

        a   <= 0.2;
        b   <= 0.4;
        W_2 <= '1';
        wait for 100 ns;
        W_2 <= '0';

        a   <= 0.3;
        b   <= 0.6;
        W_3 <= '1';
        s_3 <= '0';
        wait for 100 ns;
        ----------------
        a   <= 0.4;
        b   <= 0.8;
        s_3 <= '1';
        wait for 100 ns;
        W_3 <= '0';

        a   <= 0.5;
        b   <= 1.0;
        W_4 <= '1';
        wait for 100 ns;
        W_4 <= '0';

        a   <= 0.6;
        b   <= 1.2;
        W_5 <= '1';
        s_5 <= "00";
        wait for 100 ns;
        ----------------
        a   <= 0.7;
        b   <= 1.4;
        s_5 <= "01";
        wait for 100 ns;
        ----------------
        a   <= 0.8;
        b   <= 1.6;
        s_5 <= "10";
        wait for 100 ns;
        ----------------
        W_5 <= '0';

        a   <= 0.8;
        b   <= 1.6;
        W_6 <= '1';
        s_6 <= '0';
        wait for 100 ns;
        ----------------
        a   <= 0.9;
        b   <= 1.8;
        s_6 <= '1';
        wait for 100 ns;
        ----------------
        W_6 <= '0';

    end process reg_test_process;

end behavioral;