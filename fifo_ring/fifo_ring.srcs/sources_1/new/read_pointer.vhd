-- 读地址计数器
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity read_pointer is 
	generic(
		depth : positive
	);
	port(
		clk, rst, rq : in std_logic;
		empty : in std_logic;
		rd_pt : out std_logic_vector(depth - 1 downto 0)
	);
end entity;

architecture behav of read_pointer is
	-- 读地址计数 寄存器
	signal rd_pt_t : std_logic_vector(depth - 1 downto 0);
begin
	process(rst, clk)
	begin
		if rst = '0' then
			rd_pt_t <= (others => '0');
		elsif clk'event and clk = '1' then
			-- 只有非空才会读
			if rq = '0' and empty = '0' then
				rd_pt_t <= rd_pt_t + 1;
			end if;
		end if;
	end process;
	rd_pt <= rd_pt_t;
end behav;


