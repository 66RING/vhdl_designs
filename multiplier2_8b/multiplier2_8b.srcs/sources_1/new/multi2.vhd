-- 2位乘法器，位宽8bit
-- X * Y = result

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity multi2 is
	port(
		clk	: in std_logic;
		rst	: in std_logic;		-- 下降沿触发

		x, y: in std_logic_vector(7 downto 0);

		-- 输出
		result : out std_logic_vector(15 downto 0) := (others=>'0')
	);
end multi2;

architecture behav of multi2 is
begin
	process(rst, clk)		-- rst 负脉冲 开始
		-- 变量pa, pb保存中间值
		variable DA: std_logic_vector(17 downto 0);		-- 000.0000000 & A
		variable abs_x: std_logic_vector(9 downto 0); 	-- |X|: 000.0000000
		variable abs_2x: std_logic_vector(9 downto 0); 	-- 2|X|
		variable min_abs_x: std_logic_vector(9 downto 0); -- -|X|
		variable tmp: std_logic_vector(10 downto 0);
		variable o1: std_logic_vector(10 downto 0);
		variable o2: std_logic_vector(10 downto 0);
		variable d: std_logic_vector(2 downto 0);  -- 判断加减x
		variable c_in: std_logic;

	begin
		if rst'event and rst = '0' then  		-- rst 负脉冲表示开始
			c_in := '0';
			DA := "0000000000" & '0' & y(6 downto 0);
			abs_x := "000" & x(6 downto 0);
			abs_2x := "00" & x(6 downto 0) & '0';
			min_abs_x := ("111" & not x(6 downto 0)) + '1';
			for i in 0 to 3 loop
				d := DA(1 downto 0) & c_in;
				case d is
					-- when 条件表达式 =>  顺序执行语句;
					-- when others => 顺序执行语句; 结束
					-- 1. 相加
					-- 2. 右移
					-- 3. C更新
					when "000" => 
						c_in := '0';
					when "001" => 
						DA := (DA(17 downto 8) + abs_x) & DA(7 downto 0);
						c_in := '0';
					when "010" => 
						DA := (DA(17 downto 8) + abs_x) & DA(7 downto 0);
						c_in := '0';
					when "011" => 
						DA := (DA(17 downto 8) + abs_2x) & DA(7 downto 0);
						c_in := '0';
					when "100" => 
						DA := (DA(17 downto 8) + abs_2x) & DA(7 downto 0);
						c_in := '0';
					when "101" => 
						DA := (DA(17 downto 8) + min_abs_x) & DA(7 downto 0);
						c_in := '1';
					when "110" => 
						DA := (DA(17 downto 8) + min_abs_x) & DA(7 downto 0);
						c_in := '1';
					when "111" => 
						c_in := '1';
					when others => NULL;
				end case;
				-- 右移
				DA := DA(17) & DA(17) & DA(17 downto 2);
			end loop;
			result <= (x(7) xor y(7)) & DA(14 downto 0);
		end if;
	end process;
end behav;

