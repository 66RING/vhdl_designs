library ieee;
use ieee.std_logic_1164.all;

entity vending_machine is
	port(
		clk : in std_logic; 				-- 时钟
		button : in std_logic; 				-- 投币后按按按钮接收
		rst : in std_logic := '0'; 	-- rst 高电平表示复位
		concel: in std_logic := '0';		-- concel 1表示取消购买
		coin_val: in std_logic_vector(1 downto 0) := "00"; 	-- 表示投币币值，00表示0元，01表示5元，10表示10元，11表示20元

		-- ascii码显示
		charge_val: out std_logic_vector(4 downto 0);  	-- 退币币值(找零或退钱的情况), 单位5元

		-- 显示余额和找回
		total: out std_logic_vector(5 downto 0) 	-- 显示余额
	);
end vending_machine;


architecture behav of vending_machine is
	type state is (s0, s1, s2, s3, s4, s5, s6, s7, s8); 	-- s0
	signal next_state: state := s0;

	signal char : std_logic_vector(3 downto 0) := "0000";	-- 找零金额继承
	signal charge_or_back : std_logic_vector(3 downto 0); 		-- 找零或退币  0 表示找零 1 表示退币
begin

	-- 已投入的ASCII码
	disp: process(next_state)
	begin
		case next_state is
			when s0 => 
				total <= "000000";
			when s1 => 
				total <= "000101"; 	-- 5
			when s2 => 
				total <= "001010"; 	-- 10
			when s3 => 
				total <= "001111"; 	-- 15
			when s4 => 
				total <= "010100";  -- 20
			when s5 => 
				total <= "011001";  -- 25
			when s6 => 
				total <= "011110"; 	-- 30
			when s7 => 
				total <= "100011";	-- 35
			when s8 => 
				total <= "101000";	-- 40
		end case;
	end process;

	-- 显示找零的ascii码
	charge: process(charge_or_back)
	begin
		-- 因为单位5,所以乘3即可
		-- ascii码显示模块
		case charge_or_back is
			when "0000" => charge_val <= (others => '0');
			when "0001" => charge_val <= "00101";
			when "0010" => charge_val <= "01010";
			when "0011" => charge_val <= "01111";
			when "0100" => charge_val <= "10100";
			when others => null;
		end case;
	end process;

	process(button, rst, concel, clk)
	begin
		if rst = '1' then
			next_state <= s0; 				-- 复位
			charge_or_back <= (others => '0');
		elsif concel = '1' then
			case next_state is
				when s0 => charge_or_back <= "0000";	-- 退回0
				when s1 => charge_or_back <= "0001";	-- 退回5
				when s2 => charge_or_back <= "0010";	-- 退回10
				when s3 => charge_or_back <= "0011";	-- 退回15
				when s4 => charge_or_back <= "0100";	-- 退回20
				when others => null;
			end case;
			-- 回到初态
			next_state <= s0;
		elsif next_state = s5 then
			charge_or_back <= "0000";		-- 找零0
			next_state <= s0;
		elsif next_state = s6 then
			charge_or_back <= "0001"; 		-- 找零5
			next_state <= s0;
		elsif next_state = s7 then
			charge_or_back <= "0010"; 		-- 找零10
			next_state <= s0;
		elsif next_state = s8 then
			charge_or_back <= "0011"; 		-- 找零15
			next_state <= s0;
		elsif button'event and button = '1' then	-- 按钮按下瞬间触发，上升沿
			case next_state is
				when s0 =>							-- 已经投币0元
					-- 新一轮清零
					charge_or_back <= "0000";
					if coin_val = "01" then
						next_state <= s1;
					elsif coin_val = "10" then
						next_state <= s2;
					elsif coin_val = "11" then
						next_state <= s4;
					else null; 						-- 投"00"的情况
					end if;
				when s1 =>							-- 已经投币5元
					if coin_val = "01" then
						next_state <= s2;
					elsif coin_val = "10" then
						next_state <= s3;
					elsif coin_val = "11" then
						-- 再投入20元，共25充足，进入s5
						next_state <= s5;
					else null; 						-- 投"00"的情况
					end if;
				when s2 => 							-- 已经投币10元
					if coin_val = "01" then
						next_state <= s3;
					elsif coin_val = "10" then
						next_state <= s4;
					elsif coin_val = "11" then
						-- 再投入20元，共30,进入s6
						next_state <= s6;
					else null; 						-- 投"00"的情况
					end if;
				when s3 => 							-- 已经投币15元
					if coin_val = "01" then
						next_state <= s4;
					elsif coin_val = "10" then
						-- 再投入10元，共25,进入s5
						next_state <= s5;
					elsif coin_val = "11" then
						-- -- 再投入20元，共35,进入s7
						next_state <= s7;
					else null; 						-- 投"00"的情况
					end if;
				when s4 => 							-- 已经投币20元
					if coin_val = "01" then
						-- 再投入5,共25,进入s5
						next_state <= s5;
					elsif coin_val = "10" then
						-- 再投入10,共30,进入s6
						next_state <= s6;
					elsif coin_val = "11" then
						-- 再投入20,共40,进入s8
						next_state <= s8;
					else null; 						-- 投"00"的情况
					end if;
				when others => null;
			end case;
		end if;
	end process;

end behav;



