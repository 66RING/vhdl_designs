----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2022 03:09:50 PM
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
	signal clk, rst: std_logic := '0';
	-- wr, rd都是0使能
	signal wr, rd: std_logic := '1';
	signal datain : std_logic_vector(7 downto 0);
	signal dataout : std_logic_vector(7 downto 0);
	signal empty : std_logic;
	signal full : std_logic;


	constant T : time := 50 ns;
	constant R : time := T * 4;
begin

	U: entity work.fifo_ring port map(clk, rst, wr, rd, datain, dataout, full, empty);

	TIMER: process
	begin
		clk <= '1';
		wait for T/2;
		clk <= '0';
		wait for T/2;
	end process;

	tb: process
	begin
		-- rst低电平重置，高电屏工作
		-- 1. 读 空
		rst <= '1';
		rd <= '0';
		wait for T;
		rd <= '1';
		wait for R;

		-- 2. 写33 55 AA
		datain <= "00110011";
		wr <= '0';
		wait for T;
		wr <= '1';
		wait for T;

		datain <= "01010101";
		wr <= '0';
		wait for T;
		wr <= '1';
		wait for T;

		datain <= "10101010";
		wr <= '0';
		wait for T;
		wr <= '1';
		wait for T;

		-- depth=2, cap=3, 满
		datain <= "10111011";
		wr <= '0';
		wait for T;
		wr <= '1';
		wait for T;

		-- 3. 连续读
		rd <= '0';
		wait for T;
		rd <= '1';
		wait for R;
		rd <= '0';
		wait for T;
		rd <= '1';
		wait for R;
		rd <= '0';
		wait for T;
		rd <= '1';
		wait for R;

		-- 4. 新一轮读写测试
		-- 连续写入55 44
		datain <= "01010101";
		wr <= '0';
		wait for T;
		wr <= '1';

		wait for T;
		datain <= "01000100";
		wr <= '0';
		wait for T;
		wr <= '1';

		-- 连续读
		wait for T;
		rd <= '0';
		wait for T;
		rd <= '1';
		wait for T;
		rd <= '0';
		wait for T;
		rd <= '1';
		
		wait;
	end process;

end Behavioral;
