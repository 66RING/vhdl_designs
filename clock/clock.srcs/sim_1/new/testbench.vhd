----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2022 03:30:10 PM
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
	signal clk, reset: std_logic;
	signal clk1, nclk1: std_logic := '0';
	signal clk2, nclk2: std_logic := '0';
	signal w0, w1, w2, w3: std_logic := '0';

	constant T: time := 20 ns;

begin
	U: entity work.clk_gen port map(clk, reset, clk1,nclk1,clk2,nclk2,w0,w1,w2,w3);

	process
	begin
		clk <= '0';
		wait for T/2;
		clk <= '1';
		wait for T/2;
	end process;

	tb: process
	begin
		reset <= '0';
		wait for T;
		reset <= '1';
		wait for T;

		wait;
	end process;


end Behavioral;
