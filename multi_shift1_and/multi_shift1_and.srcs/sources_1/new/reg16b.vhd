-- 16位锁存器

library ieee;

use ieee.std_logic_1164.all;

entity reg16b is
	port(
		clk: in std_logic;
		clr: in std_logic;
		d: in  std_logic_vector(8 downto 0);
		q: out std_logic_vector(15 downto 0)
	);
end reg16b;

architecture behav of reg16b is 
	signal r16s : std_logic_vector(15 downto 0);
begin
	process(clk, clr)
	begin
		if clr = '1' then
			r16s <= (others => '0'); 	-- 清零
		elsif clk'event and clk = '1' then
			r16s(6 downto 0) <= r16s(7 downto 1);  	-- 右移至低位
			r16s(15 downto 7) <= d;  				-- 锁存高9位
		end if;
	end process;
	q <= r16s;
end behav;



