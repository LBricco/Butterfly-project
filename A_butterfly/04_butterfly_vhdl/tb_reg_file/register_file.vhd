--**********************************************************************************
--* Register file per memorizzazione di ingressi e risultati parziali
--**********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;

entity register_file is
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
        D_Wr : in sfixed(0 downto -23); -- Q1.23
        D_Wi : in sfixed(0 downto -23); -- Q1.23
        ----------------------------------------------------------------------------
        D_Ar : in sfixed(0 downto -23); -- Q1.23
        D_Ai : in sfixed(0 downto -23); -- Q1.23
        D_Br : in sfixed(0 downto -23); -- Q1.23
        D_Bi : in sfixed(0 downto -23); -- Q1.23
        ----------------------------------------------------------------------------
        IN_AS : in sfixed(3 downto -46); -- Q4.46
        IN_R  : in sfixed(0 downto -23); -- Q1.23
        --* porte di uscita ********************************************************
        Q_Br : out sfixed(0 downto -23); -- Q1.23
        Q_Bi : out sfixed(0 downto -23); -- Q1.23
        ----------------------------------------------------------------------------
        OUT_1M  : out sfixed(0 downto -23); -- Q1.23
        OUT_2M  : out sfixed(0 downto -23); -- Q1.23
        OUT_1AS : out sfixed(3 downto -46); -- Q4.46
        OUT_R   : out sfixed(3 downto -46)  -- Q4.46
    );
end entity register_file;

architecture structure of register_file is

    --**********************************************************************************
    --* Definizione segnali interni
    --**********************************************************************************

    signal D_Ar_50 : sfixed(3 downto -46); -- D_Ar Q3.46 (IN_0 mux_R3)
    signal D_Br_50 : sfixed(3 downto -46); -- D_Br Q3.46 (IN_0 mux_R5)
    signal IN_R_50 : sfixed(3 downto -46); -- IN_R Q3.46 (IN_2 mux_R5)
    ------------------------------------------------------------------------------------
    signal D_R3 : sfixed(3 downto -46); -- ingresso REG_3 Q3.46 (uscita mux_R3)
    signal D_R5 : sfixed(3 downto -46); -- ingresso REG_5 Q3.46 (uscita mux_R5)
    signal D_R6 : sfixed(0 downto -23); -- ingresso REG_6 Q1.23 (uscita mux_R6)
    ------------------------------------------------------------------------------------
    signal Q_R1    : sfixed(0 downto -23); -- uscita REG_1 Q1.23 (IN_0 mux_2M)
    signal Q_R2    : sfixed(0 downto -23); -- uscita REG_2 Q1.23 (IN_1 mux_2M)
    signal Q_R3    : sfixed(3 downto -46); -- uscita REG_3 Q4.46 (IN_0 mux_1AS)
    signal Q_R3_24 : sfixed(0 downto -23); -- uscita REG_3 Q1.23 (IN_0 mux_1M)
    signal Q_R4    : sfixed(0 downto -23); -- uscita REG_4 Q1.23 (IN_1 mux_1M)
    signal Q_R4_50 : sfixed(3 downto -46); -- uscita REG_4 Q4.46 (IN_1 mux_1AS)
    signal Q_R5    : sfixed(3 downto -46); -- uscita REG_5 Q4.46 (out OUT_R)
    signal Q_R5_24 : sfixed(0 downto -23); -- uscita REG_5 Q1.23 (IN_2 mux_1M, out Q_Bi)
    signal Q_R6    : sfixed(0 downto -23); -- uscita REG_6 Q1.23 (IN_3 mux_1M, out Q_Br)
    ------------------------------------------------------------------------------------
    signal zeros : sfixed(3 downto -46);

    --**********************************************************************************
    --* Dichiarazione component
    --**********************************************************************************

    -- registro con reset (port-mappato a 0) ed enable
    component register_sfixed is
        generic (
            M : integer := 0; -- MSB
            N : integer := 24 -- lunghezza numero [bit]
        );
        port (
            ck  : in std_logic;
            rst : in std_logic;
            en  : in std_logic;
            d   : in sfixed(M downto (M - N + 1));
            q   : out sfixed(M downto (M - N + 1))
        );
    end component;

    -- mux a due vie
    component mux2to1 is
        generic (
            M : integer; -- MSB
            N : integer  -- lunghezza numero [bit]
        );
        port (
            s          : in std_logic;
            IN_0, IN_1 : in sfixed(M downto (M - N + 1));
            uscita     : out sfixed(M downto (M - N + 1))
        );
    end component;

    -- mux a 4 vie
    component mux4to1 is
        generic (
            M : integer; -- MSB
            N : integer  -- lunghezza numero [bit]
        );
        port (
            s                      : in std_logic_vector(1 downto 0);
            IN_0, IN_1, IN_2, IN_3 : in sfixed(M downto (M - N + 1));
            uscita                 : out sfixed(M downto (M - N + 1))
        );
    end component;

begin

    -- vettore di zeri
    zeros <= (others => '0');
    -- estensioni da Q1.23 a Q4.46
    D_Ar_50 <= D_Ar(0) & D_Ar(0) & D_Ar(0) & D_Ar & zeros(-24 downto -46);
    D_Br_50 <= D_Br(0) & D_Br(0) & D_Br(0) & D_Br & zeros(-24 downto -46);
    IN_R_50 <= IN_R(0) & IN_R(0) & IN_R(0) & IN_R & zeros(-24 downto -46);
    Q_R4_50 <= Q_R4(0) & Q_R4(0) & Q_R4(0) & Q_R4 & zeros(-24 downto -46);
    -- riduzioni da Q4.46 a Q1.23
    Q_R3_24 <= Q_R3(0 downto -23);
    Q_R5_24 <= Q_R5(0 downto -23);

    --**********************************************************************************
    --* Istanze component
    --**********************************************************************************

    mux_R3 : mux2to1
    generic map(M => 3, N => 50) -- Q4.46
    port map(
        s      => s_R3,
        IN_0   => D_Ar_50,
        IN_1   => IN_AS,
        uscita => D_R3
    );

    mux_R5 : mux4to1
    generic map(M => 3, N => 50) -- Q4.46
    port map(
        s      => s_R5,
        IN_0   => D_Br_50,
        IN_1   => IN_AS,
        IN_2   => IN_R_50,
        IN_3   => zeros,
        uscita => D_R5
    );

    mux_R6 : mux2to1
    generic map(M => 0, N => 24) -- Q1.23
    port map(
        s      => s_R6,
        IN_0   => D_Bi,
        IN_1   => IN_R,
        uscita => D_R6
    );

    REG_1 : register_sfixed
    generic map(M => 0, N => 24) -- Q1.23
    port map(
        ck  => CK,
        rst => '0',
        en  => WR_R1,
        d   => D_Wr,
        q   => Q_R1
    );

    REG_2 : register_sfixed
    generic map(M => 0, N => 24) -- Q1.23
    port map(
        ck  => CK,
        rst => '0',
        en  => WR_R2,
        d   => D_Wi,
        q   => Q_R2
    );

    REG_3 : register_sfixed
    generic map(M => 3, N => 50) -- Q4.46
    port map(
        ck  => CK,
        rst => '0',
        en  => WR_R3,
        d   => D_R3,
        q   => Q_R3
    );

    REG_4 : register_sfixed
    generic map(M => 0, N => 24) -- Q1.23
    port map(
        ck  => CK,
        rst => '0',
        en  => WR_R4,
        d   => D_Ai,
        q   => Q_R4
    );

    REG_5 : register_sfixed
    generic map(M => 3, N => 50) -- Q4.46
    port map(
        ck  => CK,
        rst => '0',
        en  => WR_R5,
        d   => D_R5,
        q   => Q_R5
    );

    REG_6 : register_sfixed
    generic map(M => 0, N => 24) -- Q1.23
    port map(
        ck  => CK,
        rst => '0',
        en  => WR_R6,
        d   => D_R6,
        q   => Q_R6
    );

    mux_1M : mux4to1
    generic map(M => 0, N => 24) -- Q1.23
    port map(
        s      => s_1M,
        IN_0   => Q_R3_24,
        IN_1   => Q_R4,
        IN_2   => Q_R5_24,
        IN_3   => Q_R6,
        uscita => OUT_1M
    );

    mux_2M : mux2to1
    generic map(M => 0, N => 24) -- Q1.23
    port map(
        s      => s_2M,
        IN_0   => Q_R1,
        IN_1   => Q_R2,
        uscita => OUT_2M
    );

    mux_1AS : mux2to1
    generic map(M => 3, N => 50) -- Q4.46
    port map(
        s      => s_1AS,
        IN_0   => Q_R3,
        IN_1   => Q_R4_50,
        uscita => OUT_1AS
    );

    Q_Br <= Q_R6;
    Q_Bi <= Q_R5_24;
    OUT_R <= Q_R5;

end architecture structure;