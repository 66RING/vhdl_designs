library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;


-- 输入为二进制的原码形式（8 位，含 1 位符号位），输出为乘积的原码形式16 位，含1位符号位）
-- 除法运算前，应满足条件：X<Y,且 Y≠0,否则，按溢出或非法除数处理；

entity div8_behavior is
	generic ( width : positive := 9);
	-- X / Y = D mod A
	port(
		clk, rst: in std_logic;
		X: in std_logic_vector(width-1 downto 0);
		Y: in std_logic_vector(width-1 downto 0);
		D, A: out std_logic_vector(width-1 downto 0));
end entity;

-- 1 7  7
-- 0|0001111|0001000
-- 15


architecture beh of div8_behavior is
	signal ay, any: std_logic_vector(width-1 downto 0) := (others => '0');
begin
	process(rst)
		variable DA: std_logic_vector(width*2-2 downto 0) := (others => '0');

		variable absY: std_logic_vector(width-1 downto 0) := (others => '0');
		variable absNY: std_logic_vector(width-1 downto 0) := (others => '0');

		variable R: std_logic;
		variable sign: std_logic;
	begin

		if rst = '0' then
			sign := X(width-1) xor Y(width-1);

			-- 低位补0
			DA := (others => '0');
			-- 符号位不参与运算
			DA(width*2-2 downto width-1) := '0' & X(width-2 downto 0);
			absY := '0' & Y(width-2 downto 0);
			absNY := not ('0' & Y(width-2 downto 0)) + '1';

			ay <= absY;
			any <= absNY;

			R := '0';
			-- 左移
			-- 加法
			-- 进商
			for i in 0 to width-2 loop

				-- 左移
				DA(width*2-2 downto 0) := DA(width*2-3 downto 0) & '0';

				-- 加法
				if R = '0' then
					DA(width*2-2 downto width-1) := DA(width*2-2 downto width-1) + absNY;
				else
					DA(width*2-2 downto width-1) := DA(width*2-2 downto width-1) + absY;
				end if;

				-- 进商
				if DA(width*2-2) = '0' then
					R := '0';
				else
					R := '1';
				end if;
				DA(0) := not R;
			end loop;
		end if;

		-- 符号位单独计算
		D <= sign & DA(width*2-3 downto width-1);
		A <= sign & DA(width-2 downto 0);
	end process;

end beh;







