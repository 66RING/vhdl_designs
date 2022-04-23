library ieee;
use ieee.std_logic_1164.all;

entity top_row is
	port(
		a: in std_logic;
		b: in std_logic_vector(7 downto 0);
		sout, cout: out std_logic_vector(6 downto 0);
		p: out std_logic);
end entity;

architecture behav of top_row is
begin
	sout(0) <= a and b(1);
	sout(1) <= a and b(2);
	sout(2) <= a and b(3);
	sout(3) <= a and b(4);
	sout(4) <= a and b(5);
	sout(5) <= a and b(6);
	sout(6) <= a and b(7);
	p <= a and b(0);

	cout <= (others => '0');
end behav;

