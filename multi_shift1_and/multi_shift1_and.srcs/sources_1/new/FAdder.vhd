-- 串行进位加法器
-- 加法器模块

library IEEE;
use IEEE.std_logic_1164.all;

entity FAdder1 is 
	port(
		p: in std_logic;
		q: in std_logic;
		c_in: in std_logic;
		s: out std_logic;
		c_out: out std_logic
	);
end FAdder1;

architecture behav of FAdder1 is
begin
	s <= (p xor q) xor c_in;
	c_out <= (p and q) or (c_in and p) or (c_in and q);
end behav;
