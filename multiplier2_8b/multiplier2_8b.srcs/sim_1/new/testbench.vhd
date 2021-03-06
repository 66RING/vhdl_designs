----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2022 05:10:13 PM
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
	signal a: std_logic_vector(7 downto 0);
	signal b: std_logic_vector(7 downto 0);
	signal result: std_logic_vector(15 downto 0);
	signal clk : std_logic;
	signal rst : std_logic := '0';

    constant T : time := 50 ns;
	constant R : time := T * 4;

	signal ta: std_logic_vector(7 downto 0) := (others=>'1');
	signal tb: std_logic_vector(7 downto 0) := (others=>'1');
begin
UUT: entity work.multi2 port map(clk, rst, a, b, result);

process
begin
	-- continuous clock
	clk <= '0';
	wait for T/2;
	clk <= '1';
	wait for T/2;
end process;


process
begin
	a <= ta;
	b <= tb;
	rst <= '1';
	wait for T;
	rst <= '0';
	ta <= ta + 16;
	tb <= tb + 64;
	wait for T;
end process;

end Behavioral;

