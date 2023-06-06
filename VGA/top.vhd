
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
	port(
		clk_12 : in std_logic; --25MHz
		HSync, VSync : out std_logic;
		Red, Green : out std_logic_vector(2 downto 0);
		Blue : out std_logic_vector (2 downto 1)
	);
end top;

architecture Behavioral of top is
	signal clk_25 : std_logic;
begin

VGA_sync_1 : entity work.VGA_sync
	port map(
		--port_modulo (copia) => señales_top
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

