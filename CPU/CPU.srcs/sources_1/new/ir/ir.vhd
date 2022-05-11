library ieee;
use ieee.std_logic_1164.all;


-- 接收指令编码，送到微程序控制器
-- 生成PC的新地址
-- 生成RAM的读写地址
-- IR不译码，仅暂存数据

-- TODO clk_IR = nclk2

entity IR is
	port(
		clk_IR: in std_logic;						-- IR时钟信号
		nreset: in std_logic;						-- 复位
		LD_IR1, LD_IR2, LD_IR3: in std_logic;		-- 存储控制信号
		nARen: in std_logic; 						-- AR使能
		-- 为什么data是inout时出问题是UU呢？？
		-- data: inout std_logic_vector(7 downto 0);	-- 数据总线
		irin: in std_logic_vector(7 downto 0);	-- 数据总线
		IR: out std_logic_vector(7 downto 2);		-- IR地址编码
		PC: out std_logic_vector(11 downto 0);		-- PC新地址
		AR: out std_logic_vector(6 downto 0); 		-- RAM读写地址  6bit(低2bit做寄存器)
		RS: out std_logic; 							-- 源寄存器		1bit
		RD: out std_logic); 						-- 目的寄存器 	1bit
end entity;

architecture beh of IR is
begin
	process(clk_IR, nreset)
	begin
		if nreset = '0' then 	-- 重置
			IR <= (others=>'0');
			PC <= (others=>'0');
			AR <= (others=>'0');
			RS <= '0';
			RD <= '0';
		else
			if clk_IR'event and clk_IR = '1' then
				-- LD_IR1,2,3不能同时有效
				if LD_IR1 = '1' then	-- 传送指令到微程序控制器
					-- 从ROM获取到的数据
					IR <= irin(7 downto 2);
					RD <= irin(1);
					RS <= irin(0);
				elsif LD_IR2 = '1' then
					-- 分两次传送PC新地址LD_IR2, 3
					PC(11 downto 8) <= irin(3 downto 0);
				elsif LD_IR3 = '1' then
					-- 第二次传输低8位
					PC(7 downto 0) <= irin;
					-- 区分RAM操作，只有是RAM操作才会给AR输出
					if nARen = '0' then
						AR(6 downto 0) <= irin(6 downto 0);
					end if;
				else
					AR <= (others=>'Z');
				end if;

			end if;
		end if;
	end process;

end beh;





