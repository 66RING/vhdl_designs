-- 锁存移位模块
-- 保存
library ieee;
use ieee.std_logic_1164.all;

entity reg16b is
	port(
		clk, rst: in std_logic;
		-- 加法结果和它的进位位
		din: in std_logic_vector(7 downto 0);
		-- 多记录一位移出位
		dout: out std_logic_vector(16 downto 0));
end entity;

architecture beh of reg16b is
	signal reg: std_logic_vector(16 downto 0);
begin
	process(clk, rst)
	begin
		if rst = '1' then
			reg <= (others => '0');
		elsif clk'event and clk = '1' then
			-- 右移和锁存
			reg(7 downto 0) <= reg(8 downto 1);
			reg(15 downto 8) <= din;
			-- 符号位扩展
			reg(16) <= din(7);
		end if;
	end process;

	dout <= reg;

end beh;

