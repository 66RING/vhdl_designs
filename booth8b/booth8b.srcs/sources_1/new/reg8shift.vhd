-- 锁存乘数Y的补码
-- 选择器信号产生模块
library ieee;
use ieee.std_logic_1164.all;

entity reg8shift is
	port(clk, load : in std_logic;
		din: in std_logic_vector(7 downto 0);
		-- 01: +B
		-- 00: +0
		-- 11: +0
		-- 10: -B
		op_sel: out std_logic_vector(1 downto 0));
end entity;

architecture beh of reg8shift is
	-- 多一位A(-1)
	signal reg: std_logic_vector(8 downto 0);
begin
	process(clk, load)
	begin
		if load = '1' then
			reg <= din & '0';
		elsif clk'event and clk = '1' then
			reg(7 downto 0) <= reg(8 downto 1);
		end if;
	end process;
	op_sel <= reg(1 downto 0);
end beh;
