-- 1位乘法器

library ieee;
use ieee.std_logic_1164.all;

entity andarith is
	port(
		abin : in std_logic;
		din : in std_logic_vector(7 downto 0);
		dout : out std_logic_vector(7 downto 0)
	);
end andarith;

architecture behav of andarith is
begin
	process(abin, din)
	begin
		for i in 0 to 7 loop 			-- 8bit x 1bit 结果从dout输出
			dout(i) <= din(i) and abin;
		end loop;
	end process;
end behav;





