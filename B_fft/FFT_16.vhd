--**********************************************************************************
--* Calcolatore FFT 16x16
--**********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;

entity FFT_16 is
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
end entity FFT_16;

architecture structure of FFT_16 is

    --**********************************************************************************
    --* Definizione segnali interni
    --**********************************************************************************

    signal Wr_0, Wi_0 : sfixed(0 downto -23); -- W_0
    signal Wr_1, Wi_1 : sfixed(0 downto -23); -- W_1
    signal Wr_2, Wi_2 : sfixed(0 downto -23); -- W_2
    signal Wr_3, Wi_3 : sfixed(0 downto -23); -- W_3
    signal Wr_4, Wi_4 : sfixed(0 downto -23); -- W_4
    signal Wr_5, Wi_5 : sfixed(0 downto -23); -- W_5
    signal Wr_6, Wi_6 : sfixed(0 downto -23); -- W_6
    signal Wr_7, Wi_7 : sfixed(0 downto -23); -- W_7
    ------------------------------------------------------------------------------------
    signal DL1_SL2 : std_logic; -- DONE livello 1, START livello 2
    signal DL2_SL3 : std_logic; -- DONE livello 2, START livello 3
    signal DL3_SL4 : std_logic; -- DONE livello 3, START livello 4
    ------------------------------------------------------------------------------------
    signal ArO00_ArI08, AiO00_AiI08 : sfixed(0 downto -23); -- A' bfy 00, A bfy 08
    signal BrO00_ArI12, BiO00_AiI12 : sfixed(0 downto -23); -- B' bfy 00, A bfy 12
    signal ArO01_ArI09, AiO01_AiI09 : sfixed(0 downto -23); -- A' bfy 01, A bfy 09
    signal BrO01_ArI13, BiO01_AiI13 : sfixed(0 downto -23); -- B' bfy 01, A bfy 13
    signal ArO02_ArI10, AiO02_AiI10 : sfixed(0 downto -23); -- A' bfy 02, A bfy 10
    signal BrO02_ArI14, BiO02_AiI14 : sfixed(0 downto -23); -- B' bfy 02, A bfy 14
    signal ArO03_ArI11, AiO03_AiI11 : sfixed(0 downto -23); -- A' bfy 03, A bfy 11
    signal BrO03_ArI15, BiO03_AiI15 : sfixed(0 downto -23); -- B' bfy 03, A bfy 15
    signal ArO04_BrI08, AiO04_BiI08 : sfixed(0 downto -23); -- A' bfy 04, B bfy 08
    signal BrO04_BrI12, BiO04_BiI12 : sfixed(0 downto -23); -- B' bfy 04, B bfy 12
    signal ArO05_BrI09, AiO05_BiI09 : sfixed(0 downto -23); -- A' bfy 05, B bfy 09
    signal BrO05_BrI13, BiO05_BiI13 : sfixed(0 downto -23); -- B' bfy 05, B bfy 13
    signal ArO06_BrI10, AiO06_BiI10 : sfixed(0 downto -23); -- A' bfy 06, B bfy 10
    signal BrO06_BrI14, BiO06_BiI14 : sfixed(0 downto -23); -- B' bfy 06, B bfy 14
    signal ArO07_BrI11, AiO07_BiI11 : sfixed(0 downto -23); -- A' bfy 07, B bfy 11
    signal BrO07_BrI15, BiO07_BiI15 : sfixed(0 downto -23); -- B' bfy 07, B bfy 15
    ------------------------------------------------------------------------------------
    signal ArO08_ArI16, AiO08_AiI16 : sfixed(0 downto -23); -- A' bfy 08, A bfy 16
    signal BrO08_ArI18, BiO08_AiI18 : sfixed(0 downto -23); -- B' bfy 08, A bfy 18
    signal ArO09_ArI17, AiO09_AiI17 : sfixed(0 downto -23); -- A' bfy 09, A bfy 17 
    signal BrO09_ArI19, BiO09_AiI19 : sfixed(0 downto -23); -- B' bfy 09, A bfy 19 
    signal ArO10_BrI16, AiO10_BiI16 : sfixed(0 downto -23); -- A' bfy 10, B bfy 16 
    signal BrO10_BrI18, BiO10_BiI18 : sfixed(0 downto -23); -- B' bfy 10, B bfy 18 
    signal ArO11_BrI17, AiO11_BiI17 : sfixed(0 downto -23); -- A' bfy 11, B bfy 17 
    signal BrO11_BrI19, BiO11_BiI19 : sfixed(0 downto -23); -- B' bfy 11, B bfy 19 
    signal ArO12_ArI20, AiO12_AiI20 : sfixed(0 downto -23); -- A' bfy 12, A bfy 20
    signal BrO12_ArI22, BiO12_AiI22 : sfixed(0 downto -23); -- B' bfy 12, A bfy 22
    signal ArO13_ArI21, AiO13_AiI21 : sfixed(0 downto -23); -- A' bfy 13, A bfy 21
    signal BrO13_ArI23, BiO13_AiI23 : sfixed(0 downto -23); -- B' bfy 13, A bfy 23
    signal ArO14_BrI20, AiO14_BiI20 : sfixed(0 downto -23); -- A' bfy 14, B bfy 20
    signal BrO14_BrI22, BiO14_BiI22 : sfixed(0 downto -23); -- B' bfy 14, B bfy 22
    signal ArO15_BrI21, AiO15_BiI21 : sfixed(0 downto -23); -- A' bfy 15, B bfy 21
    signal BrO15_BrI23, BiO15_BiI23 : sfixed(0 downto -23); -- B' bfy 15, B bfy 23
    ------------------------------------------------------------------------------------
    signal ArO16_AiI24, AiO16_AiI24 : sfixed(0 downto -23); -- A' bfy 1 A bfy 24
    signal BrO16_AiI25, BiO16_AiI25 : sfixed(0 downto -23); -- B' bfy 1 A bfy 25
    signal ArO17_BiI24, AiO17_BiI24 : sfixed(0 downto -23); -- A' bfy 1 B bfy 24
    signal BrO17_BiI25, BiO17_BiI25 : sfixed(0 downto -23); -- B' bfy 1 B bfy 25
    signal ArO18_AiI26, AiO18_AiI26 : sfixed(0 downto -23); -- A' bfy 1 A bfy 26
    signal BrO18_AiI27, BiO18_AiI27 : sfixed(0 downto -23); -- B' bfy 1 A bfy 27
    signal ArO19_BiI26, AiO19_BiI26 : sfixed(0 downto -23); -- A' bfy 1 B bfy 26
    signal BrO19_BiI27, BiO19_BiI27 : sfixed(0 downto -23); -- B' bfy 1 B bfy 27
    signal ArO20_AiI28, AiO20_AiI28 : sfixed(0 downto -23); -- A' bfy 2 A bfy 28
    signal BrO20_AiI29, BiO20_AiI29 : sfixed(0 downto -23); -- B' bfy 2 A bfy 29
    signal ArO21_BiI28, AiO21_BiI28 : sfixed(0 downto -23); -- A' bfy 2 B bfy 28 
    signal BrO21_BiI29, BiO21_BiI29 : sfixed(0 downto -23); -- B' bfy 2 B bfy 29 
    signal ArO22_AiI30, AiO22_AiI30 : sfixed(0 downto -23); -- A' bfy 2 A bfy 30
    signal BrO22_AiI31, BiO22_AiI31 : sfixed(0 downto -23); -- B' bfy 2 A bfy 31
    signal ArO23_BiI30, AiO23_BiI30 : sfixed(0 downto -23); -- A' bfy 2 B bfy 30
    signal BrO23_BiI31, BiO23_BiI31 : sfixed(0 downto -23); -- B' bfy 2 B bfy 31

    --**********************************************************************************
    --* Dichiarazione component
    --**********************************************************************************

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

    Wr_0 <= "011111111111111111111111";
    Wr_1 <= "011101100100000110101111";
    Wr_2 <= "010110101000001001111001";
    Wr_3 <= "001100001111101111000101";
    Wr_4 <= "000000000000000000000000";
    Wr_5 <= "110011110000010000111010";
    Wr_6 <= "101001010111110110000110";
    Wr_7 <= "100010011011111001010000";

    Wi_0 <= "000000000000000000000000";
    Wi_1 <= "110011110000010000111010";
    Wi_2 <= "101001010111110110000110";
    Wi_3 <= "100010011011111001010000";
    Wi_4 <= "100000000000000000000000";
    Wi_5 <= "100010011011111001010000";
    Wi_6 <= "101001010111110110000110";
    Wi_7 <= "110011110000010000111010";

    --**********************************************************************************
    --* Istanze component
    --**********************************************************************************

    --* LIVELLO 1 **********************************************************************
    BUTTERFLY_00 : butterfly
    port map(
        CK => CK, RST => RST, START => START, DONE => DL1_SL2,
        -- porte di ingresso
        Ar => Xr_0, Ai => Xi_0, Br => Xr_8, Bi => Xi_8,
        Wr => Wr_0, Wi => Wi_0,
        -- porte di uscita
        Ar_primo => ArO00_ArI08, Ai_primo => AiO00_AiI08,
        Br_primo => BrO00_ArI12, Bi_primo => BiO00_AiI12
    );

    BUTTERFLY_01 : butterfly
    port map(
        CK => CK, RST => RST, START => START, DONE => DL1_SL2,
        -- porte di ingresso
        Ar => Xr_1, Ai => Xi_1, Br => Xr_9, Bi => Xi_9,
        Wr => Wr_0, Wi => Wi_0,
        -- porte di uscita
        Ar_primo => ArO01_ArI09, Ai_primo => AiO01_AiI09,
        Br_primo => BrO01_ArI13, Bi_primo => BiO01_AiI13
    );

    BUTTERFLY_02 : butterfly
    port map(
        CK => CK, RST => RST, START => START, DONE => DL1_SL2,
        -- porte di ingresso
        Ar => Xr_2, Ai => Xi_2, Br => Xr_10, Bi => Xi_10,
        Wr => Wr_0, Wi => Wi_0,
        -- porte di uscita
        Ar_primo => ArO02_ArI10, Ai_primo => AiO02_AiI10,
        Br_primo => BrO02_ArI14, Bi_primo => BiO02_AiI14
    );

    BUTTERFLY_03 : butterfly
    port map(
        CK => CK, RST => RST, START => START, DONE => DL1_SL2,
        -- porte di ingresso
        Ar => Xr_3, Ai => Xi_3, Br => Xr_11, Bi => Xi_11,
        Wr => Wr_0, Wi => Wi_0,
        -- porte di uscita
        Ar_primo => ArO03_ArI11, Ai_primo => AiO03_AiI11,
        Br_primo => BrO03_ArI15, Bi_primo => BiO03_AiI15
    );

    BUTTERFLY_04 : butterfly
    port map(
        CK => CK, RST => RST, START => START, DONE => DL1_SL2,
        -- porte di ingresso
        Ar => Xr_4, Ai => Xi_4, Br => Xr_12, Bi => Xi_12,
        Wr => Wr_0, Wi => Wi_0,
        -- porte di uscita
        Ar_primo => ArO04_BrI08, Ai_primo => AiO04_BiI08,
        Br_primo => BrO04_BrI12, Bi_primo => BiO04_BiI12
    );

    BUTTERFLY_05 : butterfly
    port map(
        CK => CK, RST => RST, START => START, DONE => DL1_SL2,
        -- porte di ingresso
        Ar => Xr_5, Ai => Xi_5, Br => Xr_13, Bi => Xi_13,
        Wr => Wr_0, Wi => Wi_0,
        -- porte di uscita
        Ar_primo => ArO05_BrI09, Ai_primo => AiO05_BiI09,
        Br_primo => BrO05_BrI13, Bi_primo => BiO05_BiI13
    );

    BUTTERFLY_06 : butterfly
    port map(
        CK => CK, RST => RST, START => START, DONE => DL1_SL2,
        -- porte di ingresso
        Ar => Xr_6, Ai => Xi_6, Br => Xr_14, Bi => Xi_14,
        Wr => Wr_0, Wi => Wi_0,
        -- porte di uscita
        Ar_primo => ArO06_BrI10, Ai_primo => AiO06_BiI10,
        Br_primo => BrO06_BrI14, Bi_primo => BiO06_BiI14
    );

    BUTTERFLY_07 : butterfly
    port map(
        CK => CK, RST => RST, START => START, DONE => DL1_SL2,
        -- porte di ingresso 
        Ar => Xr_7, Ai => Xi_7, Br => Xr_15, Bi => Xi_15,
        Wr => Wr_0, Wi => Wi_0,
        -- porte di uscita
        Ar_primo => ArO07_BrI11, Ai_primo => AiO07_BiI11,
        Br_primo => BrO07_BrI15, Bi_primo => BiO07_BiI15
    );

    --* LIVELLO 2 **********************************************************************
    BUTTERFLY_08 : butterfly
    port map(
        CK => CK, RST => RST, START => DL1_SL2, DONE => DL2_SL3,
        -- porte di ingresso
        Ar => ArO00_ArI08, Ai => AiO00_AiI08, Br => ArO04_BrI08, Bi => AiO04_BiI08,
        Wr => Wr_0, Wi => Wi_0,
        -- porte di uscita
        Ar_primo => ArO08_ArI16, Ai_primo => AiO08_AiI16,
        Br_primo => BrO08_ArI18, Bi_primo => BiO08_AiI18
    );

    BUTTERFLY_09 : butterfly
    port map(
        CK => CK, RST => RST, START => DL1_SL2, DONE => DL2_SL3,
        -- porte di ingresso
        Ar => ArO01_ArI09, Ai => AiO01_AiI09, Br => ArO05_BrI09, Bi => AiO05_BiI09,
        Wr => Wr_0, Wi => Wi_0,
        -- porte di uscita
        Ar_primo => ArO09_ArI17, Ai_primo => AiO09_AiI17,
        Br_primo => BrO09_ArI19, Bi_primo => BiO09_AiI19
    );

    BUTTERFLY_10 : butterfly
    port map(
        CK => CK, RST => RST, START => DL1_SL2, DONE => DL2_SL3,
        -- porte di ingresso
        Ar => ArO02_ArI10, Ai => AiO02_AiI10, Br => ArO06_BrI10, Bi => AiO06_BiI10,
        Wr => Wr_0, Wi => Wi_0,
        -- porte di uscita
        Ar_primo => ArO10_BrI16, Ai_primo => AiO10_BiI16,
        Br_primo => BrO10_BrI18, Bi_primo => BiO10_BiI18
    );

    BUTTERFLY_11 : butterfly
    port map(
        CK => CK, RST => RST, START => DL1_SL2, DONE => DL2_SL3,
        -- porte di ingresso
        Ar => ArO03_ArI11, Ai => AiO03_AiI11, Br => ArO07_BrI11, Bi => AiO07_BiI11,
        Wr => Wr_0, Wi => Wi_0,
        -- porte di uscita
        Ar_primo => ArO11_BrI17, Ai_primo => AiO11_BiI17,
        Br_primo => BrO11_BrI19, Bi_primo => BiO11_BiI19
    );

    BUTTERFLY_12 : butterfly
    port map(
        CK => CK, RST => RST, START => DL1_SL2, DONE => DL2_SL3,
        -- porte di ingresso
        Ar => BrO00_ArI12, Ai => BiO00_AiI12, Br => BrO04_BrI12, Bi => BiO04_BiI12,
        Wr => Wr_4, Wi => Wi_4,
        -- porte di uscita
        Ar_primo => ArO12_ArI20, Ai_primo => AiO12_AiI20,
        Br_primo => BrO12_ArI22, Bi_primo => BiO12_AiI22
    );

    BUTTERFLY_13 : butterfly
    port map(
        CK => CK, RST => RST, START => DL1_SL2, DONE => DL2_SL3,
        -- porte di ingresso
        Ar => BrO01_ArI13, Ai => BiO01_AiI13, Br => BrO05_BrI13, Bi => BiO05_BiI13,
        Wr => Wr_4, Wi => Wi_4,
        -- porte di uscita
        Ar_primo => ArO13_ArI21, Ai_primo => AiO13_AiI21,
        Br_primo => BrO13_ArI23, Bi_primo => BiO13_AiI23
    );

    BUTTERFLY_14 : butterfly
    port map(
        CK => CK, RST => RST, START => DL1_SL2, DONE => DL2_SL3,
        -- porte di ingresso
        Ar => BrO02_ArI14, Ai => BiO02_AiI14, Br => BrO06_BrI14, Bi => BiO06_BiI14,
        Wr => Wr_4, Wi => Wi_4,
        -- porte di uscita
        Ar_primo => ArO14_BrI20, Ai_primo => AiO14_BiI20,
        Br_primo => BrO14_BrI22, Bi_primo => BiO14_BiI22
    );

    BUTTERFLY_15 : butterfly
    port map(
        CK => CK, RST => RST, START => DL1_SL2, DONE => DL2_SL3,
        -- porte di ingresso
        Ar => BrO03_ArI15, Ai => BiO03_AiI15, Br => BrO07_BrI15, Bi => BiO07_BiI15,
        Wr => Wr_4, Wi => Wi_4,
        -- porte di uscita
        Ar_primo => ArO15_BrI21, Ai_primo => AiO15_BiI21,
        Br_primo => BrO15_BrI23, Bi_primo => BiO15_BiI23
    );

    --* LIVELLO 3 **********************************************************************
    BUTTERFLY_16 : butterfly
    port map(
        CK => CK, RST => RST, START => DL2_SL3, DONE => DL3_SL4,
        -- porte di ingresso
        Ar => ArO08_ArI16, Ai => AiO08_AiI16, Br => ArO10_BrI16, Bi => AiO10_BiI16,
        Wr => Wr_0, Wi => Wi_0,
        -- porte di uscita
        Ar_primo => ArO16_AiI24, Ai_primo => AiO16_AiI24,
        Br_primo => BrO16_AiI25, Bi_primo => BiO16_AiI25
    );

    BUTTERFLY_17 : butterfly
    port map(
        CK => CK, RST => RST, START => DL2_SL3, DONE => DL3_SL4,
        -- porte di ingresso
        Ar => ArO09_ArI17, Ai => AiO09_AiI17, Br => ArO11_BrI17, Bi => AiO11_BiI17,
        Wr => Wr_0, Wi => Wi_0,
        -- porte di uscita
        Ar_primo => ArO17_BiI24, Ai_primo => AiO17_BiI24,
        Br_primo => BrO17_BiI25, Bi_primo => BiO17_BiI25
    );

    BUTTERFLY_18 : butterfly
    port map(
        CK => CK, RST => RST, START => DL2_SL3, DONE => DL3_SL4,
        -- porte di ingresso
        Ar => BrO08_ArI18, Ai => BiO08_AiI18, Br => BrO10_BrI18, Bi => BiO10_BiI18,
        Wr => Wr_4, Wi => Wi_4,
        -- porte di uscita
        Ar_primo => ArO18_AiI26, Ai_primo => AiO18_AiI26,
        Br_primo => BrO18_AiI27, Bi_primo => BiO18_AiI27
    );

    BUTTERFLY_19 : butterfly
    port map(
        CK => CK, RST => RST, START => DL2_SL3, DONE => DL3_SL4,
        -- porte di ingresso
        Ar => BrO09_ArI19, Ai => BiO09_AiI19, Br => BrO11_BrI19, Bi => BiO11_BiI19,
        Wr => Wr_4, Wi => Wi_4,
        -- porte di uscita
        Ar_primo => ArO19_BiI26, Ai_primo => AiO19_BiI26,
        Br_primo => BrO19_BiI27, Bi_primo => BiO19_BiI27
    );

    BUTTERFLY_20 : butterfly
    port map(
        CK => CK, RST => RST, START => DL2_SL3, DONE => DL3_SL4,
        -- porte di ingresso
        Ar => ArO12_ArI20, Ai => AiO12_AiI20, Br => ArO14_BrI20, Bi => AiO14_BiI20,
        Wr => Wr_2, Wi => Wi_2,
        -- porte di uscita
        Ar_primo => ArO20_AiI28, Ai_primo => AiO20_AiI28,
        Br_primo => BrO20_AiI29, Bi_primo => BiO20_AiI29
    );

    BUTTERFLY_21 : butterfly
    port map(
        CK => CK, RST => RST, START => DL2_SL3, DONE => DL3_SL4,
        -- porte di ingresso
        Ar => ArO13_ArI21, Ai => AiO13_AiI21, Br => ArO15_BrI21, Bi => AiO15_BiI21,
        Wr => Wr_2, Wi => Wi_2,
        -- porte di uscita
        Ar_primo => ArO21_BiI28, Ai_primo => AiO21_BiI28,
        Br_primo => BrO21_BiI29, Bi_primo => BiO21_BiI29
    );

    BUTTERFLY_22 : butterfly
    port map(
        CK => CK, RST => RST, START => DL2_SL3, DONE => DL3_SL4,
        -- porte di ingresso
        Ar => BrO12_ArI22, Ai => BiO12_AiI22, Br => BrO14_BrI22, Bi => BiO14_BiI22,
        Wr => Wr_6, Wi => Wi_6,
        -- porte di uscita
        Ar_primo => ArO22_AiI30, Ai_primo => AiO22_AiI30,
        Br_primo => BrO22_AiI31, Bi_primo => BiO22_AiI31
    );

    BUTTERFLY_23 : butterfly
    port map(
        CK => CK, RST => RST, START => DL2_SL3, DONE => DL3_SL4,
        -- porte di ingresso
        Ar => BrO13_ArI23, Ai => BiO13_AiI23, Br => BrO15_BrI23, Bi => BiO15_BiI23,
        Wr => Wr_6, Wi => Wi_6,
        -- porte di uscita
        Ar_primo => ArO23_BiI30, Ai_primo => AiO23_BiI30,
        Br_primo => BrO23_BiI31, Bi_primo => BiO23_BiI31
    );

    --* LIVELLO 4 **********************************************************************
    BUTTERFLY_24 : butterfly
    port map(
        CK => CK, RST => RST, START => DL3_SL4, DONE => DONE,
        -- porte di ingresso
        Ar => ArO16_AiI24, Ai => AiO16_AiI24, Br => ArO17_BiI24, Bi => AiO17_BiI24,
        Wr => Wr_0, Wi => Wi_0,
        -- porte di uscita
        Ar_primo => Yr_0, Ai_primo => Yi_0,
        Br_primo => Yr_8, Bi_primo => Yi_8
    );

    BUTTERFLY_25 : butterfly
    port map(
        CK => CK, RST => RST, START => DL3_SL4, DONE => DONE,
        -- porte di ingresso
        Ar => BrO16_AiI25, Ai => BiO16_AiI25, Br => BrO17_BiI25, Bi => BiO17_BiI25,
        Wr => Wr_4, Wi => Wi_4,
        -- porte di uscita
        Ar_primo => Yr_4, Ai_primo => Yi_4,
        Br_primo => Yr_12, Bi_primo => Yi_12
    );

    BUTTERFLY_26 : butterfly
    port map(
        CK => CK, RST => RST, START => DL3_SL4, DONE => DONE,
        -- porte di ingresso
        Ar => ArO18_AiI26, Ai => AiO18_AiI26, Br => ArO19_BiI26, Bi => AiO19_BiI26,
        Wr => Wr_2, Wi => Wi_2,
        -- porte di uscita
        Ar_primo => Yr_2, Ai_primo => Yi_2,
        Br_primo => Yr_10, Bi_primo => Yi_10
    );

    BUTTERFLY_27 : butterfly
    port map(
        CK => CK, RST => RST, START => DL3_SL4, DONE => DONE,
        -- porte di ingresso
        Ar => BrO18_AiI27, Ai => BiO18_AiI27, Br => BrO19_BiI27, Bi => BiO19_BiI27,
        Wr => Wr_6, Wi => Wi_6,
        -- porte di uscita
        Ar_primo => Yr_6, Ai_primo => Yi_6,
        Br_primo => Yr_14, Bi_primo => Yi_14
    );

    BUTTERFLY_28 : butterfly
    port map(
        CK => CK, RST => RST, START => DL3_SL4, DONE => DONE,
        -- porte di ingresso
        Ar => ArO20_AiI28, Ai => AiO20_AiI28, Br => ArO21_BiI28, Bi => AiO21_BiI28,
        Wr => Wr_1, Wi => Wi_1,
        -- porte di uscita
        Ar_primo => Yr_1, Ai_primo => Yi_1,
        Br_primo => Yr_9, Bi_primo => Yi_9
    );

    BUTTERFLY_29 : butterfly
    port map(
        CK => CK, RST => RST, START => DL3_SL4, DONE => DONE,
        -- porte di ingresso
        Ar => BrO20_AiI29, Ai => BiO20_AiI29, Br => BrO21_BiI29, Bi => BiO21_BiI29,
        Wr => Wr_5, Wi => Wi_5,
        -- porte di uscita
        Ar_primo => Yr_5, Ai_primo => Yi_5,
        Br_primo => Yr_13, Bi_primo => Yi_13
    );

    BUTTERFLY_30 : butterfly
    port map(
        CK => CK, RST => RST, START => DL3_SL4, DONE => DONE,
        -- porte di ingresso
        Ar => ArO22_AiI30, Ai => AiO22_AiI30, Br => ArO23_BiI30, Bi => AiO23_BiI30,
        Wr => Wr_3, Wi => Wi_3,
        -- porte di uscita
        Ar_primo => Yr_3, Ai_primo => Yi_3,
        Br_primo => Yr_11, Bi_primo => Yi_11
    );

    BUTTERFLY_31 : butterfly
    port map(
        CK => CK, RST => RST, START => DL3_SL4, DONE => DONE,
        -- porte di ingresso
        Ar => BrO22_AiI31, Ai => BiO22_AiI31, Br => BrO23_BiI31, Bi => BiO23_BiI31,
        Wr => Wr_7, Wi => Wi_7,
        -- porte di uscita
        Ar_primo => Yr_7, Ai_primo => Yi_7,
        Br_primo => Yr_15, Bi_primo => Yi_15
    );

end architecture structure;