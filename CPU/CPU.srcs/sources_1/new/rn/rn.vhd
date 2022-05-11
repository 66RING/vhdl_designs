-- 寄存器RN

-- 锁存功能
-- 读写功能
-- !!!!!!!!!!!
-- https://its201.com/article/qq_42600433/102719179

-- 双向口注意使用高阻态防止"倒流"

library ieee;
use ieee.std_logic_1164.all;

-- TODO clk_RN = nclk2

entity RN is
	port(
		R0_out: out std_logic_vector(7 downto 0);
		R1_out: out std_logic_vector(7 downto 0);
		

		clk_RN: in std_logic;						-- RN时钟信号
		nreset: in std_logic;						-- 复位
		Rn_CS: in std_logic;						-- RD RS disorder
		nRi_EN: in std_logic; 						-- RN寄存器使能 (低电平有效)
		RDRi, WRRi: in std_logic;					-- RN读写信号
		RS: in	std_logic;							-- 源寄存器地址(0,1中选一个)
		RD: in	std_logic; 							-- 目的寄存器地址
		-- data: inout std_logic_vector(7 downto 0));	-- 数据总线
		rnin: in std_logic_vector(7 downto 0);	-- 数据总线
		rnout: out std_logic_vector(7 downto 0));	-- 数据总线
end entity;

architecture beh of RN is
	signal R0: std_logic_vector(7 downto 0);
	signal R1: std_logic_vector(7 downto 0);
begin
	R0_out <= R0;
	R1_out <= R1;

	process(clk_RN, nRi_EN)
	begin
		if nreset = '0' then
			-- 复位
			R0 <= (others=>'0');
			R1 <= (others=>'0');
			-- !!!!!!!!!!
			-- data <= (others=>'Z');
		else
			if clk_RN'event and clk_RN = '1' then
				if nRi_EN = '0' then -- 如果RN寄存器使能
					if RDRi = '1' then
						-- !!!!ZZZZZZZZ”的目的是“为输出端置为高阻态
						if Rn_CS = '1' then
							if RS = '0' then	-- 源寄存器选择R0, 从R0读
								rnout <= R0;
							elsif RS = '1' then -- 源寄存器选择R1，从R1读
								rnout <= R1;
							end if;
						elsif Rn_CS = '0' then 	-- 根据RD选
							if RD = '0' then
								rnout <= R0;
							elsif RD = '1' then
								rnout <= R1;
							end if;
						end if;
					elsif WRRi = '1' then
						if RD = '0' then
							R0 <= rnin;
						elsif RD = '1' then
							R1 <= rnin;
						end if;
					end if;
				else
					-- data <= (others=>'Z');
				end if;
			end if;
		end if;
	end process;
end beh;


