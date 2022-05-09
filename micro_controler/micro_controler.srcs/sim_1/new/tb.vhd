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


	signal clk_MC: std_logic;
	signal nreset: std_logic;
	signal IR: std_logic_vector(7 downto 2); -- IR操作码信息
	signal M_uA: std_logic;		-- 微程地址控制信号
	signal CMROM_CS: std_logic; -- 控制存储器(uROM)选通信号
	signal CM: std_logic_vector(47 downto 0);

	signal reg: std_logic_vector(5 downto 0) := (others=>'0');
	constant T : time := 20 ns;
begin

	-- U: entity work.uMC_ROM port map(clk_MC, M_ROM, ROM_EN, addr, data);
	U: entity work.micro_controler port map(clk_MC, nreset, IR, M_uA,
										   CMROM_CS, CM);

-- 1. fetch: 
-- 	ROM enable, addr <- PC,
-- 	LDR1: IR <- ROM[addr] 
-- 	LDPC: PC <- PC + 1

-- 2. 

	process
	begin
		clk_MC <= '0';
		wait for T/2;
		clk_MC <= '1';
		wait for T/2;
	end process;

	process
	begin
		nreset <= '0';
		M_uA <= '0';
		wait for T;
		nreset <= '1';
		CMROM_CS <= '1';

		--
		M_uA <= '1';
		IR <= "001001";	 	-- CM -> LDR1
		wait for T;
		M_uA <= '0';
		wait for T * 3;


		--
		M_uA <= '1';
		IR <= "011011";
		wait for T;
		M_uA <= '0';
		wait for T * 3;


		wait;
	end process;



end Behavioral;

