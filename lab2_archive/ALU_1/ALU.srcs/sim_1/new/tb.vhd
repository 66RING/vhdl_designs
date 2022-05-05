----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2022 09:33:28 AM
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
use IEEE.STD_LOGIC_unsigned.ALL;

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
	signal clk_LED : std_logic ;
	signal seg_sel : std_logic_vector(15 downto 0);
	signal seg_data : std_logic_vector(7 downto 0);


	signal clk_ALU: std_logic;
	signal nreset: std_logic;
	signal M_A, M_B: std_logic;
	signal M_F: std_logic;
	signal nALU_EN: std_logic;
	signal nPSW_EN: std_logic;
	signal C0: std_logic;
	signal S: std_logic_vector(4 downto 0);
	signal F_in: std_logic_vector(1 downto 0);
	signal datain: std_logic_vector(7 downto 0);
	signal AC: std_logic;
	signal CY: std_logic;
	signal ZN: std_logic;
	signal OV: std_logic;

	constant T: time := 20 ns;
begin

	U: entity work.alu port map(clk_LED, seg_sel, seg_data,clk_ALU, nreset, M_A, M_B,
					M_F, nALU_EN, nPSW_EN, C0, S, F_in,
					datain, 
					AC, CY, ZN, OV);

	process
	begin
		clk_ALU <= '1';
		wait for T/2;
		clk_ALU <= '0';
		wait for T/2;
	end process;

	tb: process
	begin
		nreset <= '0';
		M_A <= '0';
		M_B <= '0';
		C0 <= '0';
		wait for T;
		nreset <= '1';

		-- regA
		wait for T;
		M_A <= '1';
		M_B <= '0';
		datain <= "11110000";
		-- regB
		wait for T;
		M_A <= '0';
		M_B <= '1';
		datain <= "00001111";
		wait for T;
		M_A <= '0';
		M_B <= '0';

		S <= "00000";

		for i in 0 to 15 loop
			wait for T;
			S <= S + 1;
		end loop;


		wait;
	end process;



end Behavioral;
