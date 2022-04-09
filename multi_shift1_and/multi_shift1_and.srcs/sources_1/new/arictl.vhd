-- 控制器

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ariclt is 
	port(
		clk, start : in std_logic;
		clkout, rstall, done: out std_logic
	);
end ariclt;

architecture behav of ariclt is 
	signal cnt4b: std_logic_vector(3 downto 0) := "0000";
begin
	-- 计数器模块: 计数执行了几次操作，判断完成

	-- start高电平表示重置中，计数值保持0
	-- 否则，每次时钟上升沿计数值加1
	process(clk, start)
	begin
		rstall <= start;
		if start = '1' then
			cnt4b <= "0000";
		elsif clk'event and clk = '1' then
			if cnt4b < 8 then
				cnt4b <= cnt4b + '1';
			end if;
		end if;
	end process;

	-- 输出端口控制信号
	process(clk, cnt4b, start)
	begin
		if start = '0' then
			if cnt4b < 8 then
				-- 如果没有完成，仍然驱动时钟
				-- 控制时钟的作用
				clkout <= clk;
				done <= '0';
			else
				clkout <= '0';
				done <= '1';
			end if;
		end if;
	end process;
end behav;

