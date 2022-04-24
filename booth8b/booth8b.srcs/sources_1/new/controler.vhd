library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- rst = 1重置
entity controler is
	port(clk, rst: in std_logic;
		clkout, done: out std_logic);
end entity;

architecture beh of controler is
	signal cnt: std_logic_vector(3 downto 0);
begin
	-- 计数器模块
	process(clk, rst)
	begin
		if rst = '1' then
			cnt <= (others => '0');
		elsif clk'event and clk = '1' then
			if cnt < 8 then
				cnt <= cnt + 1;
			end if;
		end if;
	end process;

	-- 内部时钟产生模块
	process(clk, rst, cnt)
	begin
		if rst = '0' then
			-- 如果没有执行完成，继续产生时钟驱动
			if cnt < 8 then
				clkout <= clk;
				done <= '0';
			else
				done <= '1';
			end if;
		end if;
	end process;
end beh;

