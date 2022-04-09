library ieee;
use ieee.std_logic_1164.all;

entity multi_shift1 is 
	port(
		clk: in std_logic;
		start: in std_logic;
		x: in std_logic_vector(7 downto 0);
		y: in std_logic_vector(7 downto 0);
		result: out std_logic_vector(15 downto 0);
		done: out std_logic := '0'
	);
end multi_shift1;

architecture behav of multi_shift1 is
	-- TODO component的is需不要加
	-- 1位乘法器 8bit x 1bit
	-- 结果输出到 dout
	component andarith
		port(
			abin : in std_logic;
			din : in std_logic_vector(7 downto 0);
			dout : out std_logic_vector(7 downto 0)
		);
	end component;

	-- 移位寄存器
	-- load = 1 装载数据
	-- load = 0 每次上升沿右移1位
	-- 输出最低位
	component sreg8b is
		port(
			clk : in std_logic;
			load : in std_logic;
			din : in std_logic_vector(7 downto 0);
			qb : out std_logic
		);
	end component;

	-- 16位锁存器， 输出高9位锁存d,
	-- 每次clk上升沿向低位移动1bit
	component reg16b is
		port(
			clk: in std_logic;
			clr: in std_logic;
			d: in  std_logic_vector(8 downto 0);
			q: out std_logic_vector(15 downto 0)
		);
	end component;

	-- 控制器
	-- 计数判断完成，完成后不再提供clkout信号
	-- start = 1时保持0
	-- start = 0开始工作，时钟上升沿触发计数器加1
	-- 计数完成->操作完成 done输出，clkout停止驱动
	component ariclt is 
		port(
			clk, start : in std_logic;
			clkout, rstall, done: out std_logic
		);
	end component;

	-- 加法器
	-- 8bit相加，输出8bit，和进位位
	component adder8b_s is
		port(
			c_in: in std_logic;
			a: in std_logic_vector(7 downto 0);
			b: in std_logic_vector(7 downto 0);
			result: out std_logic_vector(7 downto 0);
			c_out: out std_logic
		);
	end component;

	signal clk_ctl : std_logic;
	signal rstall : std_logic;
	signal qb : std_logic;
	signal dout: std_logic_vector(7 downto 0);

	signal d: std_logic_vector(8 downto 0);
	signal q: std_logic_vector(15 downto 0);
	signal cout: std_logic;
	signal sum : std_logic_vector(7 downto 0);
begin

	-- 控制器，内部控制信号由此发出
	-- start = 1，保持0
	-- start = 0, clk上升沿计数，8位乘法需要移位8次
	-- 		未完成则clkout一致提供时钟
	u1 : ariclt port map(clk=>clk, start=>start, clkout=>clk_ctl, rstall=>rstall, done=>done);

	-- 移位寄存器，开始时load存入数据，后续只使用其移位功能
	-- 需要内部时钟驱动
	-- rstall <= start, start = 1时，装载
	-- 输出乘数的最低位，用于做1位乘法
	u2 : sreg8b port map(clk=>clk, load=>start, din=>y, qb=>qb);

	-- 乘法器
	-- 使用移位寄存器的输出做乘法
	-- 1bit qb 与 被乘数 x 相乘, 输出乘法结果
	u3: andarith port map(abin=>qb, din=>x, dout=>dout);


	-- 16位锁存器
	-- 保存结果
	-- 			0000
	-- 		   1010
	-- 		  1010
	-- 加法器结果作为输入d(9bit，因为加法溢出)
	-- 锁存的结果将会作为新一轮加法的依据
	u4: reg16b port map(clk=>clk_ctl, clr=>rstall, d=>d, q=>q);


	-- 加法，结果相加输入到锁存器
	-- 8位相加，9位输出防止移除
	-- 加数a: 乘法器结果
	-- 加数b: 16位锁存器结果
	u5: adder8b_s port map(c_in=>'0', a=>dout, b=>q(15 downto 8), result=>sum, c_out=>cout);
	-- 结果传会16位寄存器
	d <= cout & sum;

	-- 结果保存在16位锁存器中
	result <= q;

end behav;



