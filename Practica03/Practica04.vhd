----------------------------------------------------------------------------------
--		Práctica04-E6_02
--		Jose Daniel Campos Pol   					201700386
--		Jose Rodolfo Zuñiga Barillas  			201709079 
--		Cristian Sebastian Martínez Arévalo 	201700466 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Practica04 is
	port(
		clk_12 : in std_logic; --25MHz
		HSync, VSync : out std_logic;
		Red, Green : out std_logic_vector(2 downto 0);
		Blue : out std_logic_vector (2 downto 1)
	);
end Practica04;

architecture Behavioral of Practica04 is
signal clk_25 : std_logic;
begin

VGA_sync_1 : entity work.Driver_VGA
	port map(
		clk => clk_25,
		HSync => HSync,
		VSync => VSync,
		Red => Red,
		Green => Green,
		Blue => Blue
	);
	
clock_25_1 :  entity work.clock_25
	port map(
		CLKIN_IN => clk_12,
		CLKFX_OUT => clk_25
	);

end Behavioral;

