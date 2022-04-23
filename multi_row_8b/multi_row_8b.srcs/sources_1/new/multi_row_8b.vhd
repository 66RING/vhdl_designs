library ieee;
use ieee.std_logic_1164.all;

entity multi_row_8b is
	port(a, b: in std_logic_vector(7 downto 0);
		prod: out std_logic_vector(15 downto 0));
end entity;

architecture S of multi_row_8b is
	component top_row is
		port(
			a: in std_logic;
			b: in std_logic_vector(7 downto 0);
			sout, cout: out std_logic_vector(6 downto 0);
			p: out std_logic);
	end component;

	component mid_row is
		port(
			a: in std_logic;
			b: in std_logic_vector(7 downto 0);
			sin, cin: in std_logic_vector(6 downto 0);
			sout, cout: out std_logic_vector(6 downto 0);
			p: out std_logic);
	end component;

	component low_row is
		port(
			sin, cin: in std_logic_vector(6 downto 0);
			p: out std_logic_vector(7 downto 0));
	end component;

	type matrix is array(0 to 7) of std_logic_vector(6 downto 0);
	signal s, c : matrix;
begin
	u1: top_row port map(a(0), b, s(0), c(0), prod(0));
	u2: mid_row port map(a(1), b, s(0), c(0), s(1), c(1), prod(1));
	u3: mid_row port map(a(2), b, s(1), c(1), s(2), c(2), prod(2));
	u4: mid_row port map(a(3), b, s(2), c(2), s(3), c(3), prod(3));
	u5: mid_row port map(a(4), b, s(3), c(3), s(4), c(4), prod(4));
	u6: mid_row port map(a(5), b, s(4), c(4), s(5), c(5), prod(5));
	u7: mid_row port map(a(6), b, s(5), c(5), s(6), c(6), prod(6));
	u8: mid_row port map(a(7), b, s(6), c(6), s(7), c(7), prod(7));
	u9: low_row port map(s(7), c(7), prod(15 downto 8));
end S;

