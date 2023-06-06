----------------------------------------------------------------------------------
-- Driver VGA
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Driver_VGA is
	generic(
		count_h : integer := 800;
		count_v : integer := 525
	);

	port(
		clk : in std_logic; --25MHz
		HSync, VSync : out std_logic;
		Red, Green : out std_logic_vector(2 downto 0);
		Blue : out std_logic_vector (2 downto 1)
	);
end Driver_VGA;

architecture Behavioral of Driver_VGA is
	signal columna :  integer range 0 to count_h-1;
	signal linea :  integer range 0 to count_v-1;
begin
	process (clk)
	begin
		if (rising_edge(clk)) then
			--HSync signal
			if (columna>=96) then
				HSync <= '1';
			else
				HSync <= '0';
			end if;
			--VSync signal
			if (linea>=2) then
				VSync <= '1';
			else
				VSync <= '0';
			end if;
			--Frame H(0 - 799) V(0-524)
			if (columna = 799) then
				columna <= 0;
				linea <= linea+1;
				if (linea=524) then
					linea <= 0;
				end if;
			else
				columna <= columna +1;
			end if;
			--Imagen (parte visible del frame)  -160x120 c/recuadro
			--11B-100R --
			--Morado claro
			if (linea >= 35) and (linea <= 154) and (columna >= 144) and (columna <= 304) then
				Blue <= "11";
				Green <= (others => '0');
				Red <= "111";
			--Morado
			elsif (linea >= 35) and (linea <= 154) and (columna >= 305) and (columna <= 464) then
				Blue <= "11";
				Green <= (others => '0');
				Red <= "011";
			elsif (linea >= 155) and (linea <= 274) and (columna >= 144) and (columna <= 304) then
				Blue <= "11";
				Green <= (others => '0');
				Red <= "011";
			--Azul
			elsif (linea >= 35) and (linea <= 154) and (columna >= 465) and (columna <= 624) then
				Blue <= "11";
				Green <= (others => '0');
				Red <= (others => '0');
			elsif (linea >= 155) and (linea <= 274) and (columna >= 305) and (columna <= 464) then
				Blue <= "11";
				Green <= (others => '0');
				Red <= (others => '0');
			elsif (linea >= 275) and (linea <= 394) and (columna >= 144) and (columna <= 304) then
				Blue <= "11";
				Green <= (others => '0');
				Red <= (others => '0');
			--Lima
			elsif (linea >= 35) and (linea <= 154) and (columna >= 625) and (columna <= 784) then
				Blue <= (others => '0');
				Green <= "111";
				Red <= (others => '0');
			elsif (linea >= 155) and (linea <= 274) and (columna >= 465) and (columna <= 624) then
				Blue <= (others => '0');
				Green <= "111";
				Red <= (others => '0');
			elsif (linea >= 275) and (linea <= 394) and (columna >= 305) and (columna <= 464) then
				Blue <= (others => '0');
				Green <= "111";
				Red <= (others => '0');
			elsif (linea >= 395) and (linea <= 514) and (columna >= 144) and (columna <= 304) then
				Blue <= (others => '0');
				Green <= "111";
				Red <= (others => '0');
			--Amarillo
			elsif (linea >= 155) and (linea <= 274) and (columna >= 625) and (columna <= 784) then
				Blue <= (others => '0');
				Green <= "111";
				Red <= "111";
			elsif (linea >= 275) and (linea <= 394) and (columna >= 465) and (columna <= 624) then
				Blue <= (others => '0');
				Green <= "111";
				Red <= "111";
			elsif (linea >= 395) and (linea <= 514) and (columna >= 305) and (columna <= 464) then
				Blue <= (others => '0');
				Green <= "111";
				Red <= "111";
			--Naranja
			elsif (linea >= 275) and (linea <= 394) and (columna >= 625) and (columna <= 784) then
				Blue <= (others => '0');
				Green <= "011";
				Red <= "111";
			elsif (linea >= 395) and (linea <= 514) and (columna >= 465) and (columna <= 624) then
				Blue <= (others => '0');
				Green <= "011";
				Red <= "111";
			--Rojo
			elsif (linea >= 395) and (linea <= 514) and (columna >= 625) and (columna <= 784) then
				Blue <= (others => '0');
				Green <= (others => '0');
				Red <= "111";
			--Negro
			else
				Blue <= (others => '0');
				Green <= (others => '0');
				Red <= (others => '0');				
			end if;
			
		end if;
	end process;

end Behavioral;


