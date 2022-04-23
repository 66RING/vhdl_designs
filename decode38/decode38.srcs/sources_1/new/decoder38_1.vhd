library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity decoder38_1 is
	port(
		-- EN 低电平有效
		EN : in std_logic;
		A, B, C: in std_logic;
		Y: out std_logic_vector(7 downto 0));
end decoder38_1;

architecture Behavioral of decoder38_1 is
begin

	process(A,B,C,EN)
		variable input: std_logic_vector(2 downto 0);
	begin
		if EN = '0' then
			input := C & B & A;
			if input="000" then
				Y <= "00000001";
			elsif input="001" then
				Y <= "00000010";
			elsif input="010" then
				Y <= "00000100";
			elsif input="011" then
				Y <= "00001000";
			elsif input="100" then
				Y <= "00010000";
			elsif input="101" then
				Y <= "00100000";
			elsif input="110" then
				Y <= "01000000";
			elsif input="111" then
				Y <= "10000000";
			end if;
		else
			Y <= (others => '0');
		end if;
	end process;

end Behavioral;

