----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2022 04:47:28 PM
-- Design Name: 
-- Module Name: testbench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench is
--  Port ( );
end testbench;

architecture Behavioral of testbench is
		signal clk : std_logic; 				-- 时钟
		signal button : std_logic; 				-- 投币后按按按钮接收
		signal rst : std_logic := '0'; 	-- rst 高电平表示复位
		signal concel: std_logic := '0';		-- concel 1表示取消购买
		signal coin_val: std_logic_vector(1 downto 0) := "00"; 	-- 表示投币币值，00表示0元，01表示5元，10表示10元，11表示20元

		-- ascii码显示
		signal charge_val: std_logic_vector(4 downto 0);  	-- 退币币值(找零或退钱的情况), 单位5元

		-- 显示余额和找回
		signal total: std_logic_vector(5 downto 0); 	-- 显示余额

		constant T : time := 50 ns;

		constant thinking : time := T * 3;
begin
	u1: entity work.vending_machine port map(clk, button, rst, concel, coin_val,charge_val, total);

	timer: process 
	begin
		clk <= '1';
		wait for T/2;
		clk <= '0';
		wait for T/2;
	end process;

	tb: process
	begin
		rst <= '1';
		wait for T;
		rst <= '0';
		wait for T;

		-- 第一轮投币测试
		coin_val <= "01";
		button <= '1';
		wait for T/2;
		button <= '0';
		wait for T/2;

		coin_val <= "01";
		button <= '1';
		wait for T/2;
		button <= '0';
		wait for T/2;

		coin_val <= "01";
		button <= '1';
		wait for T/2;
		button <= '0';
		wait for T/2;

		coin_val <= "11";
		button <= '1';
		wait for T/2;
		button <= '0';
		wait for T/2;

		concel <= '1';
		wait for T/2;
		concel <= '0';
		wait for T/2;

		-- 第二轮投币测试: 中途取消
		coin_val <= "11";
		button <= '1';
		wait for T/2;
		button <= '0';
		wait for T/2;

		concel <= '1';
		wait for T/2;
		concel <= '0';
		wait for T/2;

		coin_val <= "11";
		button <= '1';
		wait for T/2;
		button <= '0';
		wait for T/2;
		coin_val <= "11";
		button <= '1';
		wait for T/2;
		button <= '0';
		wait for T/2;



		wait;
	end process;


end Behavioral;
