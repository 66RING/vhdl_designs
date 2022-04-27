----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2022 08:40:01 PM
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
	signal clk_IR: std_logic;						-- IR时钟信号
	signal nreset: std_logic;						-- 复位
	signal LD_IR1, LD_IR2, LD_IR3: std_logic;		-- 存储控制信号
	signal nARen: std_logic; 						-- AR使能
	signal data:  std_logic_vector(7 downto 0);		-- 数据总线
	signal IR:  std_logic_vector(7 downto 0);		-- IR地址编码
	signal PC:  std_logic_vector(11 downto 0);		-- PC新地址
	signal AR:  std_logic_vector(6 downto 0); 		-- RAM读写地址  6bit(低2bit做寄存器)
	signal RS:  std_logic; 							-- 源寄存器		1bit
	signal RD:  std_logic; 							-- 目的寄存器 	1bit

	constant T : time := 20 ns;
begin
	U: entity work.ir port map(clk_IR, nreset, LD_IR1, LD_IR2, LD_IR3,
							  nARen, data, IR, PC, AR, RS, RD);

	process
	begin
		clk_IR <= '1';
		wait for T/2;
		clk_IR <= '0';
		wait for T/2;
	end process;

	tb: process
	begin
		-- 初始化
		nreset <= '0';
		LD_IR1 <= '0'; 		-- 更新IR，微程序控制器(data to IR)
		LD_IR2 <= '0';		-- 更新PC高
		LD_IR3 <= '0';		-- 更新PC低或传AR
		data <= (others=>'0');
		nARen <= '1';
		wait for T;
		nreset <= '1';

		-- 测试1,更新IR
		-- ir <= data
		data <= "01010101";
		LD_IR1 <= '1';
		wait for T;
		LD_IR1 <= '0';
		wait for T;

		-- 测试2, 更新PC
		-- pc <= data
		data <= "00001111";
		LD_IR2 <= '1';
		wait for T;
		LD_IR2 <= '0';
		wait for T;

		-- 测试3, 更新AR
		data <= "11110000";
		LD_IR3 <= '1';
		nARen <= '0';
		wait for T;
		LD_IR3 <= '0';
		nARen <= '1';
		wait for T;

		wait;
	end process;



end Behavioral;
