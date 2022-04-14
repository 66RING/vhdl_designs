-- 空满状态产生器
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity judge_status is
	generic(
		depth : positive
   	);
	port(
		clk : in std_logic;
		rst : in std_logic;
		wr_pt : in std_logic_vector(depth - 1 downto 0);
		rd_pt : in std_logic_vector(depth - 1 downto 0);
		empty : out std_logic;
		full : out std_logic
	);
end entity;

architecture behav of judge_status is
begin
	process(rst, clk)
	begin
		if rst = '0' then
			empty <= '1';
		elsif clk'event and clk = '1' then
			if wr_pt = rd_pt then	-- 环形buffer，头尾相碰，空
				empty <= '1';
			else
				empty <= '0';
			end if;
		end if;
	end process;

	process(rst, clk)
	begin
		if rst = '0' then
			full <= '0';
		elsif clk'event and clk = '1' then
			-- 循环的，分别判断两种满的情况
			-- if wr_pt > rd_pt then
			-- 	if (rd_pt + depth) = wr_pt then
			-- 		full <= '1';
			-- 	else
			-- 		full <= '0';
			-- 	end if;
			-- else
				-- 如果下一B的写指针，说明已满
				if (wr_pt + 1) = rd_pt then
					full <= '1';
				else
					full <= '0';
				end if;
			-- end if;
		end if;
	end process;
end behav;
