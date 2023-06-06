----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Contador1 is
	port(
		clk, cambio : 		in std_logic;
		enable :		out std_logic_vector(2 downto 0);
		display : 	out std_logic_vector(7 downto 0)
	);
end Contador1;

architecture Behavioral of Contador1 is
constant cero : 			std_logic_vector(7 downto 0) := "11000000";
	signal contador_u :		integer range 0 to 9 := 0;
	signal contador_d :		integer range 0 to 9 := 0;
	signal contador_c :		integer;
	
	signal estado_enable : 	std_logic_vector(2 downto 0);
	signal estado_display:	integer range 0 to 9;
	signal delay_mux : 		integer range 0 to 11999 := 0; 
	signal delay_cambio : 	integer range 0 to 2999999 := 0; --(15MHz*1/4s)-1 => 2999999-0.25s
	
begin

	enable <= estado_enable;
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(delay_cambio = 2999999) then									
				delay_cambio <= 0;
				if(contador_u <= 8) then
					contador_u <= contador_u + 1;
				else
					contador_u <= 0;
					if(contador_d <= 8)then
						contador_d <= contador_d + 1;
					else
						contador_d <= 0;
					end if;
				end if;
			else
				delay_cambio <= delay_cambio + 1;
			end if;
			
			
			if(delay_mux = 11999) then
				delay_mux <= 0;
				if (estado_enable = "110") then
					estado_enable <= "101";
					estado_display <= contador_d;
				elsif(estado_enable = "101") then
					estado_enable <= "011";
					estado_display <= contador_c;
				elsif(estado_enable = "011") then
					estado_enable <= "110";
					estado_display <= contador_u;
				else
					estado_enable <= "110";		
				end if;
			else
				delay_mux <= delay_mux + 1;
			end if;
			
			
			if (cambio = '1') then
				contador_c <= 0;
				case estado_display is
					when 0 => display <= cero;
					when 1 => display <= "11111001";
					when 2 => display <= "10100100";
					when 3 => display <= "10110000";
					when 4 => display <= "10011001";
					when 5 => display <= "10010010";
					when 6 => display <= "10000010";
					when 7 => display <= "11111000";
					when 8 => display <= "10000000";
					when 9 => display <= "10011000";
					when others => display <="11111111";
				end case;					
			else
				contador_c <= 9;
				case estado_display is
					when 9 => display <= cero;
					when 8 => display <= "11111001";
					when 7 => display <= "10100100";
					when 6 => display <= "10110000";
					when 5 => display <= "10011001";
					when 4 => display <= "10010010";
					when 3 => display <= "10000010";
					when 2 => display <= "11111000";
					when 1 => display <= "10000000";
					when 0 => display <= "10011000";
					when others => display <="11111111";
				end case;		
			end if;
			
		end if;	
	end process;
end Behavioral;

