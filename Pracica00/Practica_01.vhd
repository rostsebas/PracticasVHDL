library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity BCD is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
				Enable0: out STD_LOGIC;
           Display : out  STD_LOGIC_VECTOR (6 downto 0));
end BCD;

architecture Behavioral of BCD is

begin
Enable0 <='0';
	process(A)
	begin
	case A is
		when "0000"=>
			Display <= "0000001";
		when "0001"=>
			Display <= "1001111";
		when "0010"=>
			Display <= "0010010";
		when "0011"=>
			Display <= "0000110";
		when "0100"=>
			Display <= "1001101";
		when "0101"=>
			Display <= "0100100";
		when "0110"=>
			Display <= "0100000";
		when "0111"=>
			Display <= "0001111";
		when "1000"=>
			Display <= "0000000";
		when "1001"=>
			Display <= "0001100";
		when "1010"=>
			Display <= "1110010";
		when "1011"=>
			Display <= "1100110";
		when "1100"=>
			Display <= "1011100";
		when "1101"=>
			Display <= "0110100";
		when "1110"=>
			Display <= "1110000";
		when "1111"=>
			Display <= "1111111";
		when others=>
			Display <= "0000000";
	end case;	
end process;
end Behavioral;



