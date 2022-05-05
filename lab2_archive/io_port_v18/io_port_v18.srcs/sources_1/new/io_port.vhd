-- mov P0, ri
-- mov ri, P0
-- 
-- 输入锁存
-- 输出锁存
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


-- TODO clk_P0 = nclk2
entity io_port is
	port(
	    clk_LED: in std_logic;
		data_in_A,data_in_B,data_in_C,data_in_D : in std_logic_vector(15 downto 0);
		seg_sel : out std_logic_vector(15 downto 0);
		seg_data : out std_logic_vector(7 downto 0);
	
		clk_P0: in std_logic;
		nreset: in std_logic;
		P0_CS: in std_logic;
		nP0_IEN: in std_logic;
		nP0_OEN: in std_logic;
		P0_IN: in std_logic_vector(7 downto 0);
		--P0_OUT: out std_logic_vector(7 downto 0);
        datain: in std_logic_vector(7 downto 0)
		--dataout: out std_logic_vector(7 downto 0)
		);
end entity;

-- 上升沿有�?, P0_CS = 1
-- 即输入输出都锁存
-- 输入锁存：nP0_IEN = 0: dataout(总线) <= (锁存) <= P0_IN
-- 输出锁存：nP0_OEN = 0: P0_OUT <= (锁存) <= datain(总线)


-- TODO redo
-- TODO redo
-- TODO redo
-- TODO redo
-- TODO redo
-- TODO redo
-- TODO redo
-- TODO redo
-- TODO redo
-- TODO redo
-- TODO redo
-- TODO redo
architecture beh of io_port is

component seg_dis is
generic( 
		clk_MHz: integer:=50;
		t_REF_uS: integer:=1000		-- 8K the same purpose
		);
	port(
		clk,rst : in std_logic ;
		data_in_A,data_in_B,data_in_C,data_in_D : in std_logic_vector(15 downto 0);
		seg_sel : out std_logic_vector(15 downto 0);
		seg_data : out std_logic_vector(7 downto 0)
		);
end component;


	signal D: std_logic_vector(7 downto 0);
	signal Din: std_logic_vector(7 downto 0);
	signal Dout: std_logic_vector(7 downto 0);
begin
    
    u: seg_dis port map(clk_LED, not nreset, "00000000"&Din,(others=>'0'),(others=>'0'), "00000000"&Dout, seg_sel, seg_data);

	process(clk_P0, nreset)
	begin
		if nreset = '0' then
			D <= (others=>'0');
			Din <= (others=>'0');
			Dout <= (others=>'0');
			--P0_OUT <= (others=>'0');
			--dataout <= (others=>'0');
		elsif P0_CS = '1' then
			-- data <- P0_IN
			-- P0_OUT <- data
			if clk_P0'event and clk_P0 = '1' then
				if nP0_IEN = '0' then
					Din <= P0_IN;
					--dataout <= Din;
				elsif nP0_OEN = '0' then
					-- data <= (others=>'Z');
					Dout <= datain;
					--P0_OUT <= Dout;
				end if;
			end if;
		end if;
	end process;

	-- P0_OUT <= Dout;
	-- dataout <= Din when (nP0_IEN = '0') else (others=>'Z');
	-- dataout <= Din;

end beh;





