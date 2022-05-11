----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2022 06:48:06 PM
-- Design Name: 
-- Module Name: tb - Behavioral
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

entity tb is
--  Port ( );
end tb;

architecture Behavioral of tb is
	signal clk_LED: std_logic;
	signal seg_sel : std_logic_vector(15 downto 0);
	signal seg_data : std_logic_vector(7 downto 0);


	signal clk: std_logic;
	signal nreset: std_logic;

	constant T: time := 20 ns;
begin

	U: entity work.cpu port map(clk, seg_sel, seg_data,clk, nreset);

	process
	begin
		clk <= '1';
		wait for T/2;
		clk <= '0';
		wait for T/2;
	end process;

	tb: process
	begin
		nreset <= '0';
		wait for T;
		nreset <= '1';
		wait;
	end process;


end Behavioral;
