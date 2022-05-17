library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clk_gen is
	port(
		clk, reset: in std_logic;
		clk1, nclk1: out std_logic := '0';
		clk2, nclk2: out std_logic := '0';
		w0, w1, w2, w3: out std_logic := '0');
end clk_gen;

-- 一个节拍包含两个时钟周期
architecture beh of clk_gen is
	signal t_clk2: std_logic := '0';

	type state is (s0, s1, s2, s3);
	signal next_state: state := s0;
begin
	clk1 <= clk;
	nclk1 <= not clk;
	nclk2 <= not t_clk2 when reset = '1' else
			'0';
	clk2 <= t_clk2 when reset = '1' else
			'0';

	C2: process(clk, reset)
	begin
		if reset = '0' then
			t_clk2 <= '0';
		-- 上升沿触发
		elsif clk'event and clk = '1' then
			t_clk2 <= not t_clk2;
		end if;
	end process;

	W: process(t_clk2, reset)
	begin
		if reset = '0' then
			w0 <= '0';
			w1 <= '0';
			w2 <= '0';
			w3 <= '0';
			next_state <= s0;
		elsif t_clk2'event and t_clk2 = '1' then
			case next_state is
				when s0 =>
					w3 <= '0';
					w0 <= '1';
					next_state <= s1;
				when s1 =>
					w0 <= '0';
					w1 <= '1';
					next_state <= s2;
				when s2 =>
					w1 <= '0';
					w2 <= '1';
					next_state <= s3;
				when s3 =>
					w2 <= '0';
					w3 <= '1';
					next_state <= s0;
				when others =>
					null;
			end case;
		end if;
	end process;
end beh;


