----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2022 03:18:42 PM
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
	signal clk_SP:  std_logic;
	signal nreset:  std_logic;
	signal SP_CS:  std_logic;
	signal SP_UP:  std_logic;
	signal SP_DN:  std_logic;
	signal nSP_EN:  std_logic;
	signal AR:  std_logic_vector(6 downto 0);
	signal data:  std_logic_vector(7 downto 0);

	constant T: time := 20 ns;
begin

	U: entity work.sp port map(clk_SP, nreset, SP_CS, SP_UP, SP_DN, nSP_EN, AR, data);

	process
	begin
		clk_SP <= '1';
		wait for T/2;
		clk_SP <= '0';
		wait for T/2;
	end process;

	process
	begin
		nreset <= '0';
		SP_CS <= '0';
		SP_UP <= '0';
		SP_DN <= '0';
		nSP_EN <= '0';

		wait for T;
		nreset <= '1';
		SP_CS <= '1';

		-- 存储功能测试
		nSP_EN <= '1';
		data <= "01010101";
		wait for T;

		-- SP++
		wait for T;
		nSP_EN <= '0';
		SP_UP <= '1';
		wait for T;
		-- sp should be +3
		wait for T;
		SP_UP <= '0';
		-- SP--
		SP_DN <= '1';
		wait for T;
		wait for T;
		SP_DN <= '0';



		wait;
	end process;



end Behavioral;
