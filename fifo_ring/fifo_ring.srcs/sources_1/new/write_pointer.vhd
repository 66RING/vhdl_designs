-- 写地址计数器
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity write_pointer is 
	generic(
		depth : positive
	);
	port(
		clk, rst, wq : in std_logic;
		full : in std_logic;
		wr_pt : out std_logic_vector(depth - 1 downto 0)
	);
end entity;

architecture behav of write_pointer is
	-- 写地址计数 寄存器
	signal wr_pt_t : std_logic_vector(depth - 1 downto 0);
begin
	process(rst, clk)
	begin
		if rst = '0' then
			wr_pt_t <= (others => '0');
		elsif clk'event and clk = '1' then
			-- 读请求时，非满才有效，计数才会加
			if wq = '0' and full = '0' then
				wr_pt_t <= wr_pt_t + 1;
			end if;
		end if;
	end process;
	wr_pt <= wr_pt_t;
end behav;


