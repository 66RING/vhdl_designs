-- 实现由扩展板上的拨码开关输入显示数值，在**16**个数码管的扫描显示功能
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity disp_16key_32led is
	-- port(
	-- 	clk, rst: in std_logic;
	-- 	key_in: in std_logic_vector(15 downto 0));
	port(clk, rst: std_logic;
		key_in: in std_logic_vector(15 downto 0);
		seg_sel: out std_logic_vector(15 downto 0);
		seg_data: out std_logic_vector(7 downto 0));
end entity;

architecture beh of disp_16key_32led is
	-- component seg_dis is
	-- 	-- ABCD四组管，每4bit 一个 led
	-- 	port(clk, rst: in std_logic;
	-- 		data_in_A, data_in_B: in std_logic_vector(15 downto 0);
	-- 		data_in_C, data_in_D: in std_logic_vector(15 downto 0);
	-- 		seg_sel: out std_logic_vector(3 downto 0);
	-- 		seg_data: out std_logic_vector(7 downto 0));
	-- end component;

	-- binary to LED code
	component data2seg is
		port(data_in: in std_logic_vector(3 downto 0);
			-- 依次为：abcdef g
			seg_data: out std_logic_vector(7 downto 0));
	end component;

	type state is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15);
	signal next_state: state := s0;

	signal reg: std_logic_vector(15 downto 0);
	signal data_in: std_logic_vector(3 downto 0);
begin

	u1: data2seg port map(data_in, seg_data);

	process(clk, rst)
	begin
		if rst = '0' then
			reg <= key_in;
			data_in <= (others => '0');
			next_state <= s15;
		elsif clk'event and clk = '1' then
			case next_state is
				-- A0
				when s15 =>
					next_state <= s0;
					data_in <= reg(15 downto 12);
					seg_sel <= (others=>'0');
					seg_sel(0) <= '1';
				-- A1
				when s0 =>
					next_state <= s1;
					data_in <= reg(11 downto 8);
					seg_sel <= (others=>'0');
					seg_sel(1) <= '1';
				-- A2
				when s1 =>
					next_state <= s2;
					data_in <= reg(7 downto 4);
					seg_sel <= (others=>'0');
					seg_sel(2) <= '1';
				-- A3
				when s2 =>
					next_state <= s3;
					data_in <= reg(3 downto 0);
					seg_sel <= (others=>'0');
					seg_sel(3) <= '1';
					reg <= key_in + 1;
				when s3 =>
					next_state <= s4;
					data_in <= reg(15 downto 12);
					seg_sel <= (others=>'0');
					seg_sel(4) <= '1';
				when s4 =>
					next_state <= s5;
					data_in <= reg(11 downto 8);
					seg_sel <= (others=>'0');
					seg_sel(5) <= '1';
				when s5 =>
					next_state <= s6;
					data_in <= reg(7 downto 4);
					seg_sel <= (others=>'0');
					seg_sel(6) <= '1';
				when s6 =>
					next_state <= s7;
					data_in <= reg(3 downto 0);
					seg_sel <= (others=>'0');
					seg_sel(7) <= '1';
					reg <= key_in + 2;
				when s7 =>
					data_in <= reg(15 downto 12);
					next_state <= s8;
					seg_sel <= (others=>'0');
					seg_sel(8) <= '1';
				when s8 =>
					data_in <= reg(11 downto 8);
					next_state <= s9;
					seg_sel <= (others=>'0');
					seg_sel(9) <= '1';
				when s9 =>
					data_in <= reg(7 downto 4);
					next_state <= s10;
					seg_sel <= (others=>'0');
					seg_sel(10) <= '1';
				when s10 =>
					data_in <= reg(3 downto 0);
					seg_sel <= (others=>'0');
					seg_sel(11) <= '1';
					next_state <= s11;
					reg <= key_in + 3;
				when s11 =>
					data_in <= reg(15 downto 12);
					seg_sel <= (others=>'0');
					seg_sel(12) <= '1';
					next_state <= s12;
				when s12 =>
					seg_sel <= (others=>'0');
					seg_sel(13) <= '1';
					data_in <= reg(11 downto 8);
					next_state <= s13;
				when s13 =>
					seg_sel <= (others=>'0');
					seg_sel(14) <= '1';
					data_in <= reg(7 downto 4);
					next_state <= s14;
				when s14 =>
					seg_sel <= (others=>'0');
					seg_sel(15) <= '1';
					data_in <= reg(3 downto 0);
					next_state <= s15;
					reg <= key_in;
			end case;
		end if;
	end process;

end beh;
