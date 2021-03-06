-- 数据存储，数据操作
-- mov ri, direct
-- mov direc, ri

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- TODO clk_RAM = nclk1 & W1
entity ram is
	port(
		clk_LED: in std_logic;
		clk_RAM: in std_logic;
		nreset: in std_logic;
		RAM_CS: in std_logic;
		nRAM_EN: in std_logic;		-- 输出使能
		wr_nRD: in std_logic;		-- 读写信号1读，0写
		AR: in std_logic_vector(6 downto 0);	-- 地址信号
		data: inout std_logic_vector(7 downto 0);

		seg_sel : out std_logic_vector(15 downto 0);
		seg_data : out std_logic_vector(7 downto 0));
end entity;


-- clk_RAM上升沿有效
-- 读：RAM_CS=1, wr_nRD=0,nRAM_EN=0  data <= [AR]
-- 写：RAM_CS=1, wr_nRD=1 [AR] <= data

-- 容量=2**7 B

architecture beh of ram is
	component seg_dis is
		generic( 

				-- TODO
				-- clk_MHz: integer:=50;
				-- t_REF_uS: integer:=1000		-- 8K the same purpose

				clk_MHz: integer:=1;
				t_REF_uS: integer:=1		-- 8K the same purpose
				);
		port(
			clk,rst : in std_logic ;
			data_in_A,data_in_B,data_in_C,data_in_D : in std_logic_vector(15 downto 0);
			seg_sel : out std_logic_vector(15 downto 0);
			seg_data : out std_logic_vector(7 downto 0)
			);
	end component;

	type ram_t is array(2**7 - 1 downto 0) of std_logic_vector(7 downto 0);
	signal ram: ram_t;
begin
	LED: seg_dis port map(clk_LED, not nreset, "00000000"&data, (others=>'0'),
						 (others=>'0'), (others=>'0'), seg_sel, seg_data);


	process(clk_RAM, nreset, nRAM_EN, wr_nRD)
	begin
		if nreset = '0' then
			data <= (others=>'Z');
		elsif clk_RAM'event and clk_RAM = '1' and RAM_CS = '1' then
			if wr_nRD = '1' then
				data <= (others=>'Z');
				ram(conv_integer(AR)) <= data;
			elsif wr_nRD = '0' then
				if nRAM_EN = '0' then
					data <= ram(conv_integer(AR));
				end if;
			end if;
		end if;
		-- TODO 其他case 是否需要Z
	end process;
end beh;
