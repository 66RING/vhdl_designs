-- 移位寄存器

library ieee;
use ieee.std_logic_1164.all;

entity sreg8b is 
	port(
		clk : in std_logic;
		load : in std_logic;
		din : in std_logic_vector(7 downto 0);
		qb : out std_logic
	);
end sreg8b;

architecture behav of sreg8b is
	signal reg8 : std_logic_vector(7 downto 0) := "00000000";
begin
	process(clk, load)
	begin
		if clk'event and clk = '1' then
			if load = '1' then  		-- 锁存装载
				reg8 <= din;
			else
				reg8(6 downto 0) <= reg8(7 downto 1);  	-- 右移
			end if;
		end if;
	end process;

	qb <= reg8(0); 		-- 输出最低位

end behav;




