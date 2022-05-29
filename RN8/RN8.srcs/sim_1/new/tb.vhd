----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/29/2022 10:46:58 PM
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
	signal clk,rst,RN_CS,WRRN,RDRN: std_logic;
	signal RS: std_logic_vector(2 downto 0);
	signal RD: std_logic_vector(2 downto 0);
	signal data: std_logic_vector(7 downto 0);

	constant T: time := 20 ns;
begin
	U1: entity work.rn8 port map(clk, rst, RN_CS, WRRN, RDRN, RS, RD, data);

	process
	begin
		clk <= '1';
		wait for T/2;
		clk <= '0';
		wait for T/2;
	end process;

	process
	begin
		rst <= '1';
		wait for T;
		rst <= '0';
		RN_CS <= '1';

		WRRN <= '1';
		RDRN <= '0';
		data <= "00001111";
		RD <= "111";
		wait for T;
		data <= "11110000";
		RD <= "101";
		wait for T;


		WRRN <= '0';
		RDRN <= '1';
		data <= "ZZZZZZZZ";
		RS <= "111";
		wait for T;
		data <= "ZZZZZZZZ";
		RS <= "101";
		wait for T;
		data <= "ZZZZZZZZ";
		RS <= "001";
		wait for T;


		wait;
	end process;



end Behavioral;
