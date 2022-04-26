-- 将输入的 4  位二进制数转换为数码管显示的数据
-- data_in(3:0)为输入值，seg_data(7:0)为数码管编码的输出值。
library ieee;
use ieee.std_logic_1164.all;

entity data2seg is
	port(data_in: in std_logic_vector(3 downto 0);
		-- 依次为：abcdefg dp
		seg_data: out std_logic_vector(7 downto 0));
end entity;

--    a
--  f   b
--    g
--  e   c
--    d
architecture beh of data2seg is 
begin
	process(data_in)
	begin
		case data_in is
			-- 0
			when "0000" =>
				seg_data <= "00000010";
			-- 1
			when "0001" =>
				seg_data <= "10011110";
			-- 2
			when "0010" =>
				seg_data <= "00100100";
			-- 3
			when "0011" =>
				seg_data <= "00001100";
			-- 4
			when "0100" =>
				seg_data <= "10011000";
			-- 5
			when "0101" =>
				seg_data <= "01001000";
			-- 6
			when "0110" =>
				seg_data <= "01000000";
			-- 7
			when "0111" =>
				seg_data <= "00011110";
			-- 8
			when "1000" =>
				seg_data <= "11111110";
			-- 9
			when "1001" =>
				seg_data <= "00001000";
			-- a
			when "1010" =>
				seg_data <= "00010000";
			-- b
			when "1011" =>
				seg_data <= "11000000";
			-- c
			when "1100" =>
				seg_data <= "01100010";
			-- d
			when "1101" =>
				seg_data <= "10000100";
			-- e
			when "1110" =>
				seg_data <= "01100000";
			-- f
			when "1111" =>
				seg_data <= "01110000";
			when others => 
			-- 其他：全全灭
				seg_data <= (others => '1');
		end case;
	end process;

end beh;
