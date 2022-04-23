----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2022 06:50:49 PM
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
use IEEE.STD_LOGIC_unsigned.ALL;

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
	signal a: std_logic_vector(7 downto 0) := "00110011";
	signal b: std_logic_vector(7 downto 0) := "00110011";
	signal cin: std_logic;
	signal s: std_logic_vector(7 downto 0);
	signal cout: std_logic;

	constant T : time := 50 ns;
begin

	U: entity work.parallel_adder_8b port map(a, b, cin, s, cout);

	process
	begin
		a <= a + 16;
		a <= a + 8;
		cin <= '0';
		wait for T * 8;

		cin <= '1';
		wait for T * 8;
	end process;

end Behavioral;
