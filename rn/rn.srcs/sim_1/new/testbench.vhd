----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2022 09:11:20 PM
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
	signal clk_RN: std_logic;						-- RN时钟信号
	signal nreset: std_logic;						-- 复位
	signal nRi_EN: std_logic; 						-- RN寄存器使能 (低电平有效) 
	signal RDRi, WRRi: std_logic;					-- RN读写信号
	signal RS: std_logic;							-- 源寄存器地址(0,1中选一个)
	signal RD: std_logic; 							-- 目的寄存器地址
	signal data: std_logic_vector(7 downto 0);	-- 数据总线

	constant T: time := 20 ns;
begin
	U: entity work.RN port map(clk_RN, nreset, nRi_EN, RDRi, WRRi, RS, RD, data);

	process
	begin
		clk_RN <= '1';
		wait for T/2;
		clk_RN <= '0';
		wait for T/2;
	end process;

	process
	begin
		-- 初始化
		nreset <= '0';
		nRi_EN <= '0'; 
		RDRi <= '0';
		WRRi <= '0';
		RS <= '0';
		RD <= '0';
		wait for T;
		nreset <= '1';
		nRi_EN <= '0'; 

		-- 测试1，写入R0, R1寄存器
		WRRi <= '1';

		RD <= '0';
		data <= "11110000";
		wait for T;
		RD <= '1';
		data <= "00001111";
		wait for T;

		WRRi <= '0';


		-- !!!!!!!!!!!!!这在现实硬件中要怎么防啊
		-- ??????
		data <= (others=>'Z');

		-- 测试2, 不选中RN读
		nRi_EN <= '1'; 
		RDRi <= '1';
		RS <= '0';
		wait for T;
		RS <= '1';
		wait for T;

		-- 测试3, 选中RN读，锁存功能
		nRi_EN <= '0'; 
		RDRi <= '1';
		RS <= '0';
		wait for T;
		RS <= '1';
		wait for T;

		wait;
	end process;




end Behavioral;
