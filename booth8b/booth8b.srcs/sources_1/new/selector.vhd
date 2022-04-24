-- 选择器
-- 根据op_sel向加法器输出被乘数
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity selector is
	port(din: in std_logic_vector(7 downto 0);
		op_sel: in std_logic_vector(1 downto 0);
		dout: out std_logic_vector(7 downto 0));
end entity;

architecture beh of selector is
	signal reg: std_logic_vector(7 downto 0);
begin
	process(op_sel, din)
	begin
		case op_sel is
			when "01" =>
				reg <= din;
			when "00" =>
				reg <= (others => '0');
			when "11" =>
				reg <= (others => '0');
			when "10" =>
				-- [-B]补
				-- 按位取反末位加1
				reg <= (not din) + '1';
			when others => null;
		end case;
	end process;
	dout <= reg;
end beh;


