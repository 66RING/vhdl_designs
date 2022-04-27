library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- 计数器 + 锁存器
-- 加一功能
-- 更新地址功能(jmp, call)
-- pc值输出到总线
entity pc is
	port(
		clk_pc: in std_logic; 		-- pc时钟信号
		nreset: in std_logic;		-- 全局复位信号, n开头表示低电平有效
		nLD_PC: in std_logic; 		-- 装载新地址
		M_PC: in std_logic; 		-- PC加一信号
		nPCH, nPCL: in std_logic;	-- PC输出总线控制信号，分两次送H表示高位
		PC: in std_logic_vector(11 downto 0);		-- PC指针, 来自IR
		ADDR: out std_logic_vector(11 downto 0);	-- ROM读地址输出
		d: inout std_logic_vector(7 downto 0) 		-- PC数值输出到数据总线
	);
end entity;

architecture beh of pc is
	signal pc_reg: std_logic_vector(11 downto 0);
begin
	process(clk_pc, nreset)
	begin
		if nreset = '0' then
			ADDR <= (others=>'0');
			pc_reg <= (others=>'0');
		else
			if clk_pc'event and clk_pc = '1' then
				if M_PC = '1' then 		-- 计数功能
					-- TODO 内部锁存
					pc_reg <= pc_reg + '1';
				elsif nLD_PC = '0' then	-- 地址更新功能
					-- 锁存计数器
					pc_reg <= PC;
				elsif nPCH = '0' then 	-- 高地址输出功能
					d <= "0000" & pc_reg(11 downto 8);
				elsif nPCL = '0' then 	-- 低地址输出功能
					d <= pc_reg(7 downto 0);
				else
					-- do nothing
				end if;
			end if;
			ADDR <= pc_reg;
		end if;
	end process;
end beh;





