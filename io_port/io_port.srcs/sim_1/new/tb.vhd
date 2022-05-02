----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2022 03:55:00 PM
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
	signal clk_P0: std_logic;
	signal nreset: std_logic;
	signal P0_CS: std_logic;
	signal nP0_IEN: std_logic;
	signal nP0_OEN: std_logic;
	signal P0_IN: std_logic_vector(7 downto 0);
	signal P0_OUT: std_logic_vector(7 downto 0);
	signal data: std_logic_vector(7 downto 0);

	constant T: time:= 20 ns;
begin
	U: entity work.io_port port map(clk_P0, nreset, P0_CS, nP0_IEN, nP0_OEN, P0_IN, P0_OUT, data);

	process
	begin
		clk_P0 <= '0';
		wait for T/2;
		clk_P0 <= '1';
		wait for T/2;
	end process;

	process
	begin
		nreset <= '0';
		P0_CS <= '0';
		nP0_IEN <= '1';
		nP0_OEN <= '1';
		wait for T;
		P0_CS <= '1';
		nreset <= '1';


		wait for T;
		nP0_IEN <= '0';
		P0_IN <= "00000011";
		data <= (others=>'Z');
		wait for T;
		nP0_IEN <= '1';

		wait for T;
		data <= "11000000";
		nP0_OEN <= '0';
		wait for T;
		nP0_OEN <= '1';

		wait; 
	end process;




end Behavioral;
