library ieee;
use ieee.std_logic_1164.all;

entity mid_row is
	port(
		a: in std_logic;
		b: in std_logic_vector(7 downto 0);
		-- 上一层加法结果sin 和 进位结果cin
		sin, cin: in std_logic_vector(6 downto 0);
		sout, cout: out std_logic_vector(6 downto 0);
		p: out std_logic);
end entity;

-- 加乘单元
architecture behav of mid_row is
	-- 高7位and，结果，低1bit 给p
	signal and_out: std_logic_vector(6 downto 0);

	component fau is
		port(
			a, b, cin: in std_logic;
			s, cout: out std_logic);
	end component;
begin
	-- 乘法单元
	-- 一位y/(a)与x各位相乘
	-- 结果送到加法器

	-- 第7位and结果用于做加法
	and_out(0) <= a and b(0);
	and_out(1) <= a and b(1);
	and_out(2) <= a and b(2);
	and_out(3) <= a and b(3);
	and_out(4) <= a and b(4);
	and_out(5) <= a and b(5);
	and_out(6) <= a and b(6);
	-- 第8位and结果用于做下一层的加数
	sout(6) <= a and b(7);

	-- 加法单元
	-- 仅第7位需要做加法，因为移位了
	-- a + b + cin = s , cout
	au1: fau port map(sin(0), cin(0), and_out(0), p, cout(0));

	au2: fau port map(sin(1), cin(1), and_out(1), sout(0), cout(1));
	au3: fau port map(sin(2), cin(2), and_out(2), sout(1), cout(2));
	au4: fau port map(sin(3), cin(3), and_out(3), sout(2), cout(3));
	au5: fau port map(sin(4), cin(4), and_out(4), sout(3), cout(4));
	au6: fau port map(sin(5), cin(5), and_out(5), sout(4), cout(5));
	au7: fau port map(sin(6), cin(6), and_out(6), sout(5), cout(6));


end behav;


