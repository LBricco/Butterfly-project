library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_CU is
end tb_CU;

architecture behavioral of tb_CU is

    -- definizione segnali interni
    signal clock           : std_logic := '0';
    signal reset           : std_logic := '0';
    signal start_butterfly : std_logic := '0';
    signal controlli       : std_logic_vector(28 downto 0);

    -- dichiarazione UUT
    component CU_butterfly is
        port (
            CK    : in std_logic;
            START : in std_logic;
            RST   : in std_logic;
            CTRL  : out std_logic_vector(28 downto 0)
        );
    end component;

begin

    -- istanza UUT
    control_unit : CU_butterfly
    port map(
        CK    => clock,
        START => start_butterfly,
        RST   => reset,
        CTRL  => controlli
    );

    -- clock
    clk_process : process
    begin
        wait for 50 ns;
        clock <= not clock;
    end process clk_process;

    -- process per test blocchetto
    reg_test_process : process
    begin

        -- modalità di esecuzione singola
        wait for 100 ns;
        start_butterfly <= '1';
        wait for 100 ns;
        start_butterfly <= '0';
        wait for 1500 ns;

        -- modalità di esecuzione continua
        start_butterfly <= '1';
        wait for 100 ns;
        start_butterfly <= '0';
        wait for 400 ns;
        start_butterfly <= '1';
        wait for 100 ns;
        start_butterfly <= '0';
        wait for 1000 ns;

    end process reg_test_process;

end behavioral;