library ieee;
use ieee.std_logic_1164.all;

entity fifo_ring is
	generic(
		N : positive := 8;
		M : positive := 2	-- 地址线宽度
	);

	port(
		clk : in std_logic;
		rst : in std_logic; 	-- 低电平重置
		wr : in std_logic;
		rd : in std_logic;
		-- fifo会自动在ram中找到相应的位置写入读出，不需要地址信息
		datain : in std_logic_vector(N - 1 downto 0);
		dataout : out std_logic_vector(N - 1 downto 0);

		-- 状态反馈
		full : out std_logic;
		empty : out std_logic
	);
end entity;

    architecture behav of fifo_ring is
	-- 读指针寄存器
	component write_pointer is
		generic( depth : positive);
		port(
			clk : in std_logic;
			rst : in std_logic;
			wq : in std_logic;	-- 读请求，cnt++
			full : in std_logic;
			wr_pt : out std_logic_vector(depth - 1 downto 0)
		);
	end component;

	-- 写指针寄存器
	component read_pointer is
		generic( depth : positive);
		port(
			clk : in std_logic;
			rst : in std_logic;
			rq : in std_logic;	-- 写请求, cnt++
			empty : in std_logic;
			rd_pt : out std_logic_vector(depth - 1 downto 0)
		);
	end component;

	-- 根据读指针和写指针判断空满状态
	component judge_status is
		generic( depth : positive);
		port(
			clk : in std_logic;
			rst : in std_logic;
			wr_pt : in std_logic_vector(depth - 1 downto 0);
			rd_pt : in std_logic_vector(depth - 1 downto 0);
			empty : out std_logic;
			full : out std_logic
		);
	end component;

	component dualram is
		generic( depth : positive; width: positive);
		port(
			-- port A is only for writing
			clka : in std_logic;
			wr : in std_logic;
			addra : in std_logic_vector(depth - 1 downto 0);
			datain : in std_logic_vector(width - 1 downto 0);
			-- port B is only for reading
			clkb : in std_logic;
			rd : in std_logic;
			addrb : in std_logic_vector(depth - 1 downto 0);
			dataout : out std_logic_vector(width - 1 downto 0)
		);
	end component;

	signal wr_pt_t : std_logic_vector(M - 1 downto 0);
	signal rd_pt_t : std_logic_vector(M - 1 downto 0);
	signal empty_t : std_logic;
	signal full_t : std_logic;
begin

	-- 根据内部计数器产生空满信号
	u1: judge_status 
		generic map(depth=>M)
		port map(clk=>clk, rst=>rst,
					wr_pt=>wr_pt_t, rd_pt=>rd_pt_t,
					empty=>empty_t, full=>full_t);
	-- 写指针寄存器保存到wr_pt_t，作为内部计数器供dualram和状态判断器使用
	u2: write_pointer 
		generic map(depth=>M)
		port map(clk=>clk, rst=>rst, wq=>wr, full=>full_t, wr_pt=>wr_pt_t);
	-- 读指针寄存器保存到rd_pt_t，作为内部计数器供dualram和状态判断器使用
	u3: read_pointer 
		generic map(depth=>M)
		port map(clk=>clk, rst=>rst,
				   rq=>rd, empty=>empty_t, rd_pt=>rd_pt_t);
	-- 根据内部读写地址做fifo
	-- A B口可以独立，但是这里使用统一时钟信号
	u4: dualram 
		generic map(depth=>M, width=>N)
		-- 满时不允许写，空时不允许读
		port map(clka=>clk, wr=>(wr or full_t), addra=>wr_pt_t, datain=>datain,
				clkb=>clk, rd=>(rd or empty_t), addrb=>rd_pt_t, dataout=>dataout);
	full <= full_t;
	empty <= empty_t;

end behav;

