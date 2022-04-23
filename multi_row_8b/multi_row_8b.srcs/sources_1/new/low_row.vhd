library ieee;
use ieee.std_logic_1164.all;

entity low_row is
	port(
		-- 仅低7位加法，因为错位了
		sin, cin: in std_logic_vector(6 downto 0);
		p: out std_logic_vector(7 downto 0));
end entity;

-- 结果相加
architecture behav of low_row is
	signal local: std_logic_vector(6 downto 0);

	component fau is
		port(
			a, b, cin: in std_logic;
			s, cout: out std_logic);
	end component;
begin
	local(0) <= '0';

	-- a + b + cin = s , cout
	-- 串联加法器
	u1: fau port map(sin(0), cin(0), local(0), p(0), local(1));
	u2: fau port map(sin(1), cin(1), local(1), p(1), local(2));
	u3: fau port map(sin(2), cin(2), local(2), p(2), local(3));
	u4: fau port map(sin(3), cin(3), local(3), p(3), local(4));
	u5: fau port map(sin(4), cin(4), local(4), p(4), local(5));
	u6: fau port map(sin(5), cin(5), local(5), p(5), local(6));

	u7: fau port map(sin(6), cin(6), local(6), p(6), p(7));

end behav;



