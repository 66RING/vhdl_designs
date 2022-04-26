----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2022 11:47:49 AM
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
	signal key_in: std_logic_vector(15 downto 0);
	signal seg_sel: std_logic_vector(15 downto 0);
	signal seg_data: std_logic_vector(7 downto 0);

	constant T : time := 20 ns;
begin
	U: entity work.disp_16key_32led port map(clk, rst, key_in, seg_sel, seg_data);

	process
	begin
		clk <= '1';
		wait for T/2;
		clk <= '0';
		wait for T/2;
	end process;

	tb: process
	begin
		rst <= '0';
		key_in <= (others=>'0');
		key_in(3 downto 0) <= "0111";
		wait for T;
		rst <= '1';
		wait for T*4;
		rst <= '0';
		wait for T;
		rst <= '1';
		wait for T*8;


		key_in <= (others=>'0');
		key_in(7 downto 4) <= "0111";
		rst <= '0';
		wait for T;
		rst <= '1';
		wait;
	end process;


end Behavioral;
