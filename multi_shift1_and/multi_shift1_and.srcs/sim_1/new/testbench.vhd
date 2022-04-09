----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2022 03:52:11 PM
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
	signal clk, start, done: std_logic := '0';
	signal x, y: std_logic_vector(7 downto 0);
	signal result: std_logic_vector(15 downto 0);

	constant T : time := 50 ns;
	constant R : time := T * 16;

begin

	U: entity work.multi_shift1 port map(clk, start, x, y, result, done);

	process
	begin
		clk <= '0';
		wait for T/2;
		clk <= '1';
		wait for T/2;
	end process;

	tb: process
	begin
		start <= '1';
		x <= "00000111";
		y <= "00000011";
		wait for T;
		start <= '0';
		wait for R;

		start <= '1';
		x <= "00011111";
		y <= "00000011";
		wait for T;
		start <= '0';
		wait for R;

	end process tb;

end Behavioral;
