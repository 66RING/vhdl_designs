library ieee;
use ieee.std_logic_1164.all;

entity adder8b_s is
	port(
		c_in: in std_logic;
		a: in std_logic_vector(7 downto 0);
		b: in std_logic_vector(7 downto 0);
		result: out std_logic_vector(7 downto 0);
		c_out: out std_logic
	);
end adder8b_s;

architecture behav of adder8b_s is
	component FAdder1 is
		port(
			p: in std_logic; 	-- op1
			q: in std_logic; 	-- op2
			c_in: in std_logic;
			s: out std_logic;
			c_out: out std_logic
		);
	end component;

	signal c: std_logic_vector(7 downto 0);
	signal s: std_logic_vector(7 downto 0);
begin
	u1: FAdder1 port map(a(0), b(0), c_in, s(0), c(0));
	u2: FAdder1 port map(a(1), b(1), c(0), s(1), c(1));
	u3: FAdder1 port map(a(2), b(2), c(1), s(2), c(2));
	u4: FAdder1 port map(a(3), b(3), c(2), s(3), c(3));
	u5: FAdder1 port map(a(4), b(4), c(3), s(4), c(4));
	u6: FAdder1 port map(a(5), b(5), c(4), s(5), c(5));
	u7: FAdder1 port map(a(6), b(6), c(5), s(6), c(6));
	u8: FAdder1 port map(a(7), b(7), c(6), s(7), c_out);
	result <= s;
end behav;


