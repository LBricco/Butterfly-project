--**********************************************************************************
--* CU processore Butterfly con tecnica della microprogrammazione
--**********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CU_butterfly is
    port (
        CK    : in std_logic;
        START : in std_logic;
        RST   : in std_logic;
        CTRL  : out std_logic_vector(28 downto 0)
    );
end entity CU_butterfly;

architecture structure of CU_butterfly is

    --**********************************************************************************
    --* Definizione segnali interni
    --**********************************************************************************

    signal CC_1       : std_logic_vector(1 downto 0);  -- condition code 1
    signal J_ADD_1    : std_logic_vector(4 downto 0);  -- jump address 1
    signal CC_2       : std_logic_vector(1 downto 0);  -- condition code 2
    signal J_ADD_2    : std_logic_vector(4 downto 0);  -- jump address 2
    signal NJ_ADD     : std_logic_vector(4 downto 0);  -- no jump address
    signal s_ADD      : std_logic_vector(1 downto 0);  -- selettore next address
    signal Q_uROM     : std_logic_vector(42 downto 0); -- uscita uROM
    signal Q_uIR      : std_logic_vector(42 downto 0); -- uscita uIR
    signal P_ADD      : std_logic_vector(4 downto 0);  -- present address
    signal N_ADD      : std_logic_vector(4 downto 0);  -- next address
    signal PS_int     : integer range 0 to 20;         -- indirizzo uROM
    signal NJ_ADD_int : integer range 1 to 20;         -- indirizzo uROM + 1

    --**********************************************************************************
    --* Dichiarazione component
    --**********************************************************************************

    -- micro rom butterfly
    component uROM_butterfly is
        port (
            ADDR : in integer range 0 to 19;
            CELL : out std_logic_vector(42 downto 0)
        );
    end component;

    -- registro che campiona sul fronte di salita del clock
    component reg_rising is
        generic (N : integer);
        port (
            clk : in std_logic;
            d   : in std_logic_vector(N - 1 downto 0);
            q   : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    -- registro che campiona sul fronte di discesa del clock
    component reg_falling is
        generic (N : integer);
        port (
            clk : in std_logic;
            rst : in std_logic;
            d   : in std_logic_vector(N - 1 downto 0);
            q   : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    -- mux a 4 vie
    component mux4to1 is
        generic (N : integer := 16);
        port (
            s                      : in std_logic_vector(1 downto 0);     -- selettore a 2 bit
            IN_0, IN_1, IN_2, IN_3 : in std_logic_vector(N - 1 downto 0); -- input a N bit
            uscita                 : out std_logic_vector(N - 1 downto 0) -- output a N bit
        );
    end component;

    -- status PLA
    component status_PLA_butterfly is
        port (
            START : in std_logic;
            CC1   : in std_logic_vector(1 downto 0); -- condition code 1
            CC2   : in std_logic_vector(1 downto 0); -- condition code 2
            s     : out std_logic_vector(1 downto 0) -- selettore mux
        );
    end component;

begin

    PS_int     <= to_integer(unsigned(P_ADD));
    NJ_ADD_int <= PS_int + 1;
    NJ_ADD     <= std_logic_vector(to_unsigned(NJ_ADD_int, 5));

    CTRL    <= Q_uIR(42 downto 14);
    J_ADD_1 <= Q_uIR(13 downto 9);
    CC_1    <= Q_uIR(8 downto 7);
    J_ADD_2 <= Q_uIR(6 downto 2);
    CC_2    <= Q_uIR(1 downto 0);

    --**********************************************************************************
    --* Istanze component
    --**********************************************************************************

    uROM : uROM_butterfly
    port map(
        ADDR => PS_int,
        CELL => Q_uROM
    );

    uIR : reg_rising
    generic map(N => 43)
    port map(
        clk => CK,
        d   => Q_uROM,
        q   => Q_uIR
    );

    mux_uAR : mux4to1
    generic map(N => 5)
    port map(
        s      => s_ADD,
        IN_0   => NJ_ADD,  -- no jump
        IN_1   => J_ADD_1, -- jump 1
        IN_2   => J_ADD_2, -- jump 2
        IN_3   => "00000",
        uscita => N_ADD
    );

    uAR : reg_falling
    generic map(N => 5)
    port map(
        clk => CK,
        rst => RST,
        d   => N_ADD,
        q   => P_ADD
    );

    PLA : status_PLA_butterfly
    port map(
        START => START,
        CC1   => CC_1,
        CC2   => CC_2,
        s     => s_ADD
    );

end architecture structure;