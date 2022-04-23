library ieee;
use ieee.std_logic_1164.all;

entity fau is 
	port(
		a, b, cin: in std_logic;
		s, cout: out std_logic);
end entity;

architecture S of fau is
begin
	s <= a xor b xor cin;
	cout <= (a and b) or (a and cin) or (b and cin);
end S;
