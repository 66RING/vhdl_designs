-- 数据存储，数据操�?
-- mov ri, direct
-- mov direc, ri

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- TODO clk_RAM = nclk1 & W1
entity ram is
	port(
	
		clk_RAM: in std_logic;
		nreset: in std_logic;
		RAM_CS: in std_logic;
		nRAM_EN: in std_logic;		-- 输出使能
		wr_nRD: in std_logic;		-- 读写信号1读，0�?
		AR: in std_logic_vector(6 downto 0);	-- 地址信号
		datain: in std_logic_vector(7 downto 0);
		dataout: out std_logic_vector(7 downto 0));

		--seg_sel : out std_logic_vector(15 downto 0);
		--seg_data : out std_logic_vector(7 downto 0));
end entity;


-- clk_RAM上升沿有�?
-- 读：RAM_CS=1, wr_nRD=0,nRAM_EN=0  data <= [AR]
-- 写：RAM_CS=1, wr_nRD=1 [AR] <= data

-- 容量=2**7 B

architecture beh of ram is

	type ram_t is array(2**7 - 1 downto 0) of std_logic_vector(7 downto 0);
    signal dataout_t:  std_logic_vector(7 downto 0);
	signal ram: ram_t;
begin
	-- LED: seg_dis port map(clk_LED, nreset, "00000000"&dataout_t, "000000000"&AR,
	--					  "00000000"&datain,  "000000000"&AR, seg_sel, seg_data);

    dataout <= dataout_t;
	process(clk_RAM, nreset, nRAM_EN, wr_nRD)
	begin
		if nreset = '0' then
			dataout <= (others=>'0');
		elsif clk_RAM'event and clk_RAM = '1' and RAM_CS = '1' then
			if wr_nRD = '1' then
				--dataout <= (others=>'Z');
				ram(conv_integer(AR)) <= datain;
			elsif wr_nRD = '0' then
				if nRAM_EN = '0' then
					dataout <= ram(conv_integer(AR));
				end if;
			end if;
		end if;
		-- TODO 其他case 是否�?要Z
	end process;
end beh;
