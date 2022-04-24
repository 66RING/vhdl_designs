----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2022 04:37:38 PM
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
	signal clk, rst: std_logic;
	signal a_in, b_in: std_logic_vector(7 downto 0);
	signal sum_out: std_logic_vector(15 downto 0);

	constant T : time := 20 ns;

begin
	U: entity work.booth8b port map(clk, rst, a_in, b_in, sum_out);

	process
	begin
		clk <= '1';
		wait for T/2;
		clk <= '0';
		wait for T/2;
	end process;

	tb: process
	begin
		a_in <= "01000000";
		b_in <= "01000000";
		-- a_in <= "01010000";
		-- b_in <= "10011000";
		rst <= '1';
		wait for T;
		rst <= '0';


		wait;
	end process;


end Behavioral;
