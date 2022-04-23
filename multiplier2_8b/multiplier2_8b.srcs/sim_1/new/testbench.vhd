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
	a <= "00000001";
	b <= "00001111";
	rst <= '1';
	wait for T;
	rst <= '0';
	wait for R;
	a <= "00000010";
	b <= "10001111";
	rst <= '1';
	wait for T;
	rst <= '0';
	wait for R;
	a <= "00000011";
	b <= "00001111";
	rst <= '1';
	wait for T;
	rst <= '0';
	wait for R;
	a <= "00000100";
	b <= "00001111";
	rst <= '1';
	wait for T;
	rst <= '0';
	wait for R;
	a <= "00000101";
	b <= "00001111";
	rst <= '1';
	wait for T;
	rst <= '0';
	wait for R;
	a <= "00000110";
	b <= "00001111";
	rst <= '1';
	wait for T;
	rst <= '0';
	wait for R;
	wait;
end process;

end Behavioral;

