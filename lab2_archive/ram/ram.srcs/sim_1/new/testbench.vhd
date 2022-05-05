----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2022 02:43:39 PM
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
	signal clk_RAM: std_logic;
	signal nreset: std_logic;
	signal RAM_CS: std_logic;
	signal nRAM_EN: std_logic;		-- 输出使能
	signal wr_nRD: std_logic;		-- 读写信号1读，0写
	signal AR: std_logic_vector(6 downto 0);	-- 地址信号
	signal data: std_logic_vector(7 downto 0);

	signal clk_LED: std_logic;
	signal seg_sel : std_logic_vector(15 downto 0);
	signal seg_data : std_logic_vector(7 downto 0);

	constant T : time := 20 ns;
begin
	U: entity work.ram port map(clk_LED, clk_RAM, nreset, RAM_CS, nRAM_EN, wr_nRD, AR, data, seg_sel, seg_data);

	clk_LED <= clk_RAM;

	process
	begin
		clk_RAM <= '1';
		wait for T/2;
		clk_RAM <= '0';
		wait for T/2;
	end process;

	process
	begin
		nreset <= '0';
		wait for T;

		nreset <= '1';
		-- 写入测试
		RAM_CS <= '1';
		wr_nRD <= '1';
		AR <= "0001111";
		data <= "01010101";
		wait for T;
		RAM_CS <= '1';
		wr_nRD <= '1';
		AR <= "1111000";
		data <= "10101010";
		wait for T;
		data <= (others=>'Z');
		RAM_CS <= '0';
		wr_nRD <= '0';
		wait for T;

		-- 读出测试1
		RAM_CS <= '0';
		nRAM_EN <= '0';
		wr_nRD <= '0';
		wait for T;
		RAM_CS <= '0';
		wait for T;

		-- 读出测试2
		RAM_CS <= '1';
		nRAM_EN <= '1';
		wr_nRD <= '0';
		wait for T;
		RAM_CS <= '0';
		wr_nRD <= '0';
		wait for T;

		-- 读出测试3
		AR <= "0001111";
		RAM_CS <= '1';
		nRAM_EN <= '0';
		wr_nRD <= '0';
		wait for T;
		AR <= "1111000";
		RAM_CS <= '1';
		nRAM_EN <= '0';
		wr_nRD <= '0';
		wait for T;
		RAM_CS <= '0';
		wait for T;

		wait;
	end process;



end Behavioral;
