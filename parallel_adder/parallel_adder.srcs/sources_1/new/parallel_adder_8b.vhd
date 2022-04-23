library ieee;
use ieee.std_logic_1164.all;

entity parallel_adder_8b is
	port(
		a: in std_logic_vector(7 downto 0);
		b: in std_logic_vector(7 downto 0);
		cin: in std_logic;
		s: out std_logic_vector(7 downto 0);
		cout: out std_logic;
	);
end entity;

architecture behav of parallel_adder_8b is
	signal c : std_logic_vector(7 downto 0);
	signal p, g: std_logic_vector(7 downto 0);
begin
	-- 绝对进位 (11)
	g(0) <= a(0) and b(0);
	g(1) <= a(1) and b(1);
	g(2) <= a(2) and b(2);
	g(3) <= a(3) and b(3);

	g(4) <= a(4) and b(4);
	g(5) <= a(5) and b(5);
	g(6) <= a(6) and b(6);
	g(7) <= a(7) and b(7);

	-- 进位传递 (10 / 01)
	p(0) <= a(0) xor b(0);
	p(1) <= a(1) xor b(1);
	p(2) <= a(2) xor b(2);
	p(3) <= a(3) xor b(3);

	p(4) <= a(4) xor b(4);
	p(5) <= a(5) xor b(5);
	p(6) <= a(6) xor b(6);
	p(7) <= a(7) xor b(7);


	-- 产生并行进位
	c(1) <= g(0) or (p(0) and cin);
	c(2) <= g(1) or (p(1) and g(0)) or (p(1) and p(0) and cin);
	c(3) <= g(2) or (p(2) and g(1)) or (p(2) and p(1) and g(0)) or (p(2) and p(1) and p(0) and cin);

	--      g(3) or (p(3) and c(3))
	c(4) <= g(3) or (p(3) and (g(2) or (p(2) and g(1)) or (p(2) and p(1) and g(0)) or (p(2) and p(1) and p(0) and cin)));

	--      g(4) or (p(3) and c(4))
	c(5) <= g(4) or (p(4) and (g(3) or (p(3) and (g(2) or (p(2) and g(1)) or (p(2) and p(1) and g(0)) or (p(2) and p(1) and p(0) and cin)))));

	--      g(5) or (p(5) and c(5))
	c(6) <= g(5) or (p(5) and (g(4) or (p(4) and (g(3) or (p(3) and (g(2) or (p(2) and g(1)) or (p(2) and p(1) and g(0)) or (p(2) and p(1) and p(0) and cin)))))));

	--      g(6) or (p(6) and c(5))
	c(7) <= g(6) or (p(6) and (g(5) or (p(5) and (g(4) or (p(4) and (g(3) or (p(3) and (g(2) or (p(2) and g(1)) or (p(2) and p(1) and g(0)) or (p(2) and p(1) and p(0) and cin)))))))));

	--      g(7) or (p(7) and c(7))
	cout <= g(7) or (p(7) and (g(6) or (p(6) and (g(5) or (p(5) and (g(4) or (p(4) and (g(3) or (p(3) and (g(2) or (p(2) and g(1)) or (p(2) and p(1) and g(0)) or (p(2) and p(1) and p(0) and cin)))))))))));

	-- 和输出
	s(0) <= p(0) xor cin;
	s(1) <= p(1) xor c(1);
	s(2) <= p(2) xor c(2);
	s(3) <= p(3) xor c(3);

	s(4) <= p(4) xor c(4);
	s(5) <= p(5) xor c(5);
	s(6) <= p(6) xor c(6);
	s(7) <= p(7) xor c(7);


end behav;


