--**********************************************************************************
--* Registro sensibile ai fronti di salita del clock
--**********************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_rising is
	generic (N : integer);
	port (
		clk : in std_logic;
		d   : in std_logic_vector(N - 1 downto 0);
		q   : out std_logic_vector(N - 1 downto 0)
	);
end entity reg_rising;

architecture structure of reg_rising is
begin

	CK_process : process (clk)
	begin
		if (clk'event and clk = '1') then
			q <= d;
		end if;
	end process CK_process;

end structure;