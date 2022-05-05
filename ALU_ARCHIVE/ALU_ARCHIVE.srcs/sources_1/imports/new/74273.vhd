library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity octal_dff is 
	port(
		clk, nclr: in std_logic;
		D: in std_logic_vector(7 downto 0);
		Q: out std_logic_vector(7 downto 0));
end entity;

architecture beh of octal_dff is
	signal reg: std_logic_vector(7 downto 0) := (others=>'0');
begin
	Q <= reg;
	process(clk, nclr)
	begin
		if nclr = '0' then
			reg <= (others=>'0');
		elsif clk'event and clk = '1' then
			reg <= D;
		end if;
	end process;
end beh;
