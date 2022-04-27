----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2022 03:19:05 PM
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



	signal clk: std_logic;
	signal M_ROM: std_logic := '1';
	signal ROM_EN: std_logic := '1';
	signal addr: std_logic_vector(11 downto 0);
	signal data: std_logic_vector(7 downto 0) := (others=>'0');

	signal reg: std_logic_vector(11 downto 0) := (others=>'0');
	constant T : time := 20 ns;
begin

	U: entity work.rom port map(clk, M_ROM, ROM_EN, addr, data);

	process
	begin
		clk <= '0';
		wait for T/2;
		clk <= '1';
		wait for T/2;
	end process;

	process(clk)
	begin
		-- if not reg = "000000001000" then
			if clk'event and clk = '1' then
				reg <= reg + '1';
			end if;
		-- else
		-- 	M_ROM <= not M_ROM;
		-- 	ROM_EN <= not ROM_EN;
		-- 	reg <= (others=>'0');
		-- end if;
	end process;


	addr <= reg;

end Behavioral;
