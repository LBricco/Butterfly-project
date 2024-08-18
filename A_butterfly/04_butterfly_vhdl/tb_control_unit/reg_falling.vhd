--**********************************************************************************
--* Registro sensibile ai fronti di discesa del clock
--**********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_falling is
	generic (N : integer);
	port (
		clk : in std_logic;
		rst : in std_logic;
		d   : in std_logic_vector(N - 1 downto 0);
		q   : out std_logic_vector(N - 1 downto 0)
	);
end entity reg_falling;

architecture structure of reg_falling is
begin

	CK_process : process (clk, rst)
	begin
		if (rst = '1') then
			q <= (others => '0');
		elsif (clk'event and clk = '0') then
			q <= d;
		end if;
	end process CK_process;

end structure;