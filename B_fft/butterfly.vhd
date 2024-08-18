--**********************************************************************************
--* Processore Butterfly
--**********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;

entity butterfly is
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
end entity butterfly;

architecture structure of butterfly is

    --**********************************************************************************
    --* Definizione segnali interni
    --**********************************************************************************

    signal CTRL : std_logic_vector(28 downto 0);
    ------------------------------------------------------------------------------------
    signal WR_R1 : std_logic;
    signal WR_R2 : std_logic;
    signal WR_R3 : std_logic;
    signal WR_R4 : std_logic;
    signal WR_R5 : std_logic;
    signal WR_R6 : std_logic;
    signal s_R3  : std_logic;
    signal s_R5  : std_logic_vector(1 downto 0);
    signal s_R6  : std_logic;
    signal s_1M  : std_logic_vector(1 downto 0);
    signal s_2M  : std_logic;
    signal s_1AS : std_logic;
    ------------------------------------------------------------------------------------
    signal WR_R7 : std_logic;
    signal WR_R8 : std_logic;
    signal WR_R9 : std_logic;
    signal s_R7  : std_logic;
    signal s_R8  : std_logic_vector(1 downto 0);
    signal s_R9  : std_logic_vector(1 downto 0);
    ------------------------------------------------------------------------------------
    signal M_nS : std_logic;
    ------------------------------------------------------------------------------------
    signal s_D1A   : std_logic;                    -- selettore mux_D1A
    signal s_D1S   : std_logic_vector(1 downto 0); -- selettore mux_D1S
    signal s_DR    : std_logic;                    -- selettore mux_DR
    signal s_IN_AS : std_logic;                    -- selettore mux_IN_AS
    ------------------------------------------------------------------------------------
    signal D1_M_RF  : sfixed(0 downto -23); -- D1M da reg file Q1.23
    signal D2_M_RF  : sfixed(0 downto -23); -- D2M da reg file Q1.23
    signal D1_AS_RF : sfixed(3 downto -46); -- D1A/D1S da reg file Q4.46
    signal D_R_RF   : sfixed(3 downto -46); -- DR da reg file Q4.46 (IN_0 mux_DR)
    ------------------------------------------------------------------------------------
    signal D1_ADD : sfixed(2 downto -46); -- D1A Q3.46 (uscita mux_D1A)
    signal D1_SUB : sfixed(3 downto -46); -- D1S Q4.46 (uscita mux_D1S)
    signal D_RND  : sfixed(3 downto -46); -- DR Q4.46 (uscita mux_DR)
    ------------------------------------------------------------------------------------
    signal Q_MPY    : sfixed(0 downto -46); -- QM Q1.46
    signal Q_MPY_50 : sfixed(3 downto -46); -- QM Q4.46 (IN_0 mux_R9)
    signal Q_SFT    : sfixed(1 downto -23); -- QSH Q2.23 (IN_0 mux_R7)
    signal Q_SFT_49 : sfixed(2 downto -46); -- QSH Q3.46 (IN_0 mux_R8)
    signal Q_ADD    : sfixed(2 downto -46); -- QA Q3.46 (IN_1 mux_R8)
    signal Q_ADD_50 : sfixed(3 downto -46); -- QA Q4.46 (IN_1 mux_R9)
    signal Q_SUB    : sfixed(3 downto -46); -- QSB Q4.46 (IN_2 mux_R9)
    signal Q_RND    : sfixed(0 downto -23); -- QR Q1.23 (IN_R reg file)
    signal Q_RND_25 : sfixed(1 downto -23); -- QR Q2.23 (IN_1 mux_R7)
    signal Q_RND_49 : sfixed(2 downto -46); -- QR Q3.46 (IN_2 mux_R8)
    signal Q_AS     : sfixed(3 downto -46); -- IN_AS Q4.46 (uscita mux_AS)
    ------------------------------------------------------------------------------------
    signal D_R7 : sfixed(1 downto -23); -- ingresso REG_7 Q2.23 (uscita mux_R7)
    signal D_R8 : sfixed(2 downto -46); -- ingresso REG_8 Q3.46 (uscita mux_R8)
    signal D_R9 : sfixed(3 downto -46); -- ingresso REG_9 Q4.46 (uscita mux_R9)
    ------------------------------------------------------------------------------------
    signal Q_R7    : sfixed(1 downto -23); -- uscita REG_7 Q2.23
    signal Q_R7_50 : sfixed(3 downto -46); -- uscita REG_7 Q4.46 (IN_1 mux_D1S)
    signal Q_R8    : sfixed(2 downto -46); -- uscita REG_8 Q3.46 (IN_0 mux_D1A)
    signal Q_R8_50 : sfixed(3 downto -46); -- uscita REG_8 Q4.46 (IN_0 mux_D1S)
    signal Q_R9    : sfixed(3 downto -46); -- uscita REG_9 Q4.46 (IN_1 mux_DR, D2S)
    signal Q_R9_49 : sfixed(2 downto -46); -- uscita REG_9 Q3.46 (D2A sommatore)
    ------------------------------------------------------------------------------------
    signal zero : sfixed(3 downto -46);

    --**********************************************************************************
    --* Dichiarazione component
    --**********************************************************************************

    -- registro
    component register_sfixed is
        generic (
            M : integer := 0; -- MSB
            N : integer := 24 -- lunghezza numero [bit]
        );
        port (
            ck  : in std_logic;
            en  : in std_logic;
            d   : in sfixed(M downto (M - N + 1));
            q   : out sfixed(M downto (M - N + 1))
        );
    end component;

    -- mux a due vie
    component mux2to1_sfixed is
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

    -- mux a quattro vie
    component mux4to1_sfixed is
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

    -- sommatore
    component adder_pipe_sfixed is
        generic (
            M : integer := 2; -- MSB
            N : integer := 49 -- lunghezza numero [bit]
        );
        port (
            CK       : in std_logic;
            D1A, D2A : in sfixed(M downto (M - N + 1)); -- Q3.46
            QA       : out sfixed(M downto (M - N + 1)) -- Q3.46
        );
    end component;

    -- sottrattore
    component subtractor_pipe_sfixed is
        generic (
            M : integer := 3; -- MSB
            N : integer := 50 -- lunghezza numero [bit]
        );
        port (
            CK       : in std_logic;
            D1S, D2S : in sfixed(M downto (M - N + 1)); -- Q4.46
            QSB      : out sfixed(M downto (M - N + 1)) -- Q4.46
        );
    end component;

    -- moltiplicatore/shifter
    component mpy_shifter_pipe_sfixed is
        generic (N : integer := 24); -- lunghezza numero [bit]
        port (
            CK       : in std_logic;
            M_nS     : in std_logic;
            D1M, D2M : in sfixed(0 downto (-N + 1));      -- Q1.23
            QM       : out sfixed(0 downto (-2 * N + 2)); -- Q1.46
            QSH      : out sfixed(1 downto (-N + 1))      -- Q2.23
        );
    end component;

    -- arrotondatore
    component rounder_sfixed is
        generic (
            M : integer := 3; -- MSB
            N : integer := 50 -- lunghezza numero [bit]
        );
        port (
            DR : in sfixed(M downto (M - N + 1)); -- Q4.46
            QR : out sfixed(0 downto -23)         -- Q1.23
        );
    end component;

    -- register file
    component register_file is
        port (
            CK  : in std_logic;
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
    end component;

    -- control unit
    component CU_butterfly is
        port (
            CK    : in std_logic;
            START : in std_logic;
            RST   : in std_logic;
            CTRL  : out std_logic_vector(28 downto 0)
        );
    end component;

begin

    zero <= (others => '0');

    -- estensioni e riduzioni
    Q_MPY_50 <= Q_MPY(0) & Q_MPY(0) & Q_MPY(0) & Q_MPY;             -- da Q1.46 a Q4.46
    Q_SFT_49 <= Q_SFT(1) & Q_SFT & zero(-24 downto -46);            -- da Q2.23 a Q3.46
    Q_ADD_50 <= Q_ADD(2) & Q_ADD;                                   -- da Q3.46 a Q4.46
    Q_RND_25 <= Q_RND(0) & Q_RND;                                   -- da Q1.23 a Q2.23
    Q_RND_49 <= Q_RND(0) & Q_RND(0) & Q_RND & zero(-24 downto -46); -- da Q1.23 a Q3.46
    Q_R7_50  <= Q_R7(1) & Q_R7(1) & Q_R7 & zero(-24 downto -46);    -- da Q2.23 a Q4.46
    Q_R8_50  <= Q_R8(2) & Q_R8;                                     -- da Q3.46 a Q4.46 
    Q_R9_49  <= Q_R9(2 downto -46);                                 -- da Q4.46 a Q3.46

    -- segnali di controllo
    WR_R1   <= CTRL(28);
    WR_R2   <= CTRL(27);
    WR_R3   <= CTRL(26);
    WR_R4   <= CTRL(25);
    WR_R5   <= CTRL(24);
    WR_R6   <= CTRL(23);
    s_R3    <= CTRL(22);
    s_R5    <= CTRL(21 downto 20);
    s_R6    <= CTRL(19);
    s_1M    <= CTRL(18 downto 17);
    s_2M    <= CTRL(16);
    s_1AS   <= CTRL(15);
    WR_R7   <= CTRL(14);
    WR_R8   <= CTRL(13);
    WR_R9   <= CTRL(12);
    s_R7    <= CTRL(11);
    s_R8    <= CTRL(10 downto 9);
    s_R9    <= CTRL(8 downto 7);
    M_nS    <= CTRL(6);
    s_D1A   <= CTRL(5);
    s_D1S   <= CTRL(4 downto 3);
    s_DR    <= CTRL(2);
    s_IN_AS <= CTRL(1);
    DONE    <= CTRL(0);

    Ar_primo <= Q_R7(0 downto -23); -- Q1.23
    Ai_primo <= Q_R8(0 downto -23); -- Q1.23

    --**********************************************************************************
    --* Istanze component
    --**********************************************************************************

    REG_FILE : register_file
    port map(
        CK      => CK,
        WR_R1   => WR_R1,
        WR_R2   => WR_R2,
        WR_R3   => WR_R3,
        WR_R4   => WR_R4,
        WR_R5   => WR_R5,
        WR_R6   => WR_R6,
        s_R3    => s_R3,
        s_R5    => s_R5,
        s_R6    => s_R6,
        s_1M    => s_1M,
        s_2M    => s_2M,
        s_1AS   => s_1AS,
        D_Wr    => Wr,       -- Q1.23
        D_Wi    => Wi,       -- Q1.23
        D_Ar    => Ar,       -- Q1.23
        D_Ai    => Ai,       -- Q1.23
        D_Br    => Br,       -- Q1.23
        D_Bi    => Bi,       -- Q1.23
        IN_AS   => Q_AS,     -- Q4.46
        IN_R    => Q_RND,    -- Q1.23
        Q_Br    => Br_primo, -- Q1.23
        Q_Bi    => Bi_primo, -- Q1.23
        OUT_1M  => D1_M_RF,  -- Q1.23
        OUT_2M  => D2_M_RF,  -- Q1.23
        OUT_1AS => D1_AS_RF, -- Q4.46
        OUT_R   => D_R_RF    -- Q4.46
    );

    MPY_SHIFTER : mpy_shifter_pipe_sfixed
    generic map(N => 24)
    port map(
        CK   => CK,
        M_nS => M_nS,
        D1M  => D1_M_RF, -- Q1.23
        D2M  => D2_M_RF, -- Q1.23
        QM   => Q_MPY,   -- Q1.46
        QSH  => Q_SFT    -- Q2.23
    );

    ADDER : adder_pipe_sfixed
    generic map(M => 2, N => 49)
    port map(
        CK  => CK,
        D1A => D1_ADD,  -- Q3.46
        D2A => Q_R9_49, -- Q3.46
        QA  => Q_ADD    -- Q3.46
    );

    SUBTRACTOR : subtractor_pipe_sfixed
    generic map(M => 3, N => 50)
    port map(
        CK  => CK,
        D1S => D1_SUB, -- Q4.46
        D2S => Q_R9,   -- Q4.46
        QSB => Q_SUB   -- Q4.46
    );

    ROUNDER_SCALER : rounder_sfixed
    generic map(M => 3, N => 50)
    port map(
        DR => D_RND, -- Q4.46
        QR => Q_RND  -- Q1.23
    );

    mux_D1A : mux2to1_sfixed
    generic map(M => 2, N => 49)
    port map(
        s      => s_D1A,
        IN_0   => Q_R8,                   -- Q3.46
        IN_1   => D1_AS_RF(2 downto -46), -- Q3.46
        uscita => D1_ADD                  -- Q3.46
    );

    mux_D1S : mux4to1_sfixed
    generic map(M => 3, N => 50)
    port map(
        s      => s_D1S,
        IN_0   => Q_R8_50,  -- Q4.46
        IN_1   => Q_R7_50,  -- Q4.46
        IN_2   => D1_AS_RF, -- Q4.46
        IN_3   => zero,
        uscita => D1_SUB -- Q4.46
    );

    mux_DR : mux2to1_sfixed
    generic map(M => 3, N => 50)
    port map(
        s      => s_DR,
        IN_0   => D_R_RF, -- Q4.46
        IN_1   => Q_R9,   -- Q4.46
        uscita => D_RND   -- Q4.46
    );

    mux_R7 : mux2to1_sfixed
    generic map(M => 1, N => 25)
    port map(
        s      => s_R7,
        IN_0   => Q_SFT,    -- Q2.23
        IN_1   => Q_RND_25, -- Q2.23
        uscita => D_R7      -- Q2.23
    );

    mux_R8 : mux4to1_sfixed
    generic map(M => 2, N => 49)
    port map(
        s      => s_R8,
        IN_0   => Q_SFT_49, -- Q3.46
        IN_1   => Q_ADD,    -- Q3.46
        IN_2   => Q_RND_49, -- Q3.46
        IN_3   => zero(2 downto -46),
        uscita => D_R8 -- Q3.46
    );

    mux_R9 : mux4to1_sfixed
    generic map(M => 3, N => 50)
    port map(
        s      => s_R9,
        IN_0   => Q_MPY_50, -- Q4.46
        IN_1   => Q_ADD_50, -- Q4.46
        IN_2   => Q_SUB,    -- Q4.46
        IN_3   => zero,
        uscita => D_R9 -- Q4.46
    );

    REG_7 : register_sfixed
    generic map(M => 1, N => 25)
    port map(
        ck  => CK,
        en  => WR_R7,
        d   => D_R7,
        q   => Q_R7
    );

    REG_8 : register_sfixed
    generic map(M => 2, N => 49)
    port map(
        ck  => CK,
        en  => WR_R8,
        d   => D_R8,
        q   => Q_R8
    );

    REG_9 : register_sfixed
    generic map(M => 3, N => 50)
    port map(
        ck  => CK,
        en  => WR_R9,
        d   => D_R9,
        q   => Q_R9
    );

    mux_AS : mux2to1_sfixed
    generic map(M => 3, N => 50)
    port map(
        s      => s_IN_AS,
        IN_0   => Q_ADD_50, -- Q4.46
        IN_1   => Q_SUB,    -- Q4.46
        uscita => Q_AS      -- Q4.46
    );

    CONTROL_UNIT : CU_butterfly
    port map(
        CK    => CK,
        RST   => RST,
        START => START,
        CTRL  => CTRL
    );

end architecture structure;