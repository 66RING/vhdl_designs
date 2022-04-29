----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2022 05:04:15 PM
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
	signal clk, rst: std_logic := '1';

	signal X: std_logic_vector(7 downto 0) := (others=>'0');
	signal Y: std_logic_vector(7 downto 0);
	signal D, A: std_logic_vector(7 downto 0);

	-- signal X: std_logic_vector(3 downto 0) := (others=>'0');
	-- signal Y: std_logic_vector(3 downto 0);
	-- signal D, A: std_logic_vector(3 downto 0);
begin
	U1: entity work.div8_behavior 
		generic map(8)
		port map(clk, rst, X, Y, D, A);

	process
	begin
		rst <= '1';
		X <= "00100000";
		Y <= "01000000";
		wait for 20 ns;
		rst <= '0';
		wait for 20 ns;


		-- rst <= '1';
		-- X <= "0010";
		-- Y <= "0100";
		-- wait for 20 ns;
		-- rst <= '0';

		wait;
	end process;


end Behavioral;
