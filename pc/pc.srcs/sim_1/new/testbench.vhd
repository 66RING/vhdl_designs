----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2022 02:30:29 PM
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

	signal clk_pc: std_logic; 		-- pc时钟信号
	signal nreset: std_logic;		-- 全局复位信号, n开头表示低电平有效
	signal nLD_PC: std_logic; 		-- 装载新地址
	signal M_PC: std_logic; 		-- PC加一信号
	signal nPCH, nPCL: std_logic;	-- PC输出总线控制信号，分两次送H表示高位
	signal PC: std_logic_vector(11 downto 0);		-- PC指针, 来自IR
	signal ADDR: std_logic_vector(11 downto 0);	-- ROM读地址输出
	signal d: std_logic_vector(7 downto 0); 		-- PC数值输出到数据总线

	constant T : time := 20 ns;
begin
	U: entity work.pc port map(clk_pc, nreset, nLD_PC, M_PC, nPCH, nPCL, PC, ADDR, d);

	process
	begin
		clk_pc <= '1';
		wait for T/2;
		clk_pc <= '0';
		wait for T/2;
	end process;

	tb: process
	begin
		-- 初始化: 全部无效
		nreset <= '0';
		nLD_PC <= '1';
		M_PC <= '0';
		nPCH <= '1';
		nPCL <= '1';
		PC <= (others=>'0');

		wait for T; 
		nreset <= '1';

		-- 1. 地址更新测试
		nLD_PC <= '0';
		PC <= "001100001111";
		wait for T;
		nLD_PC <= '1';

		-- 2. 计数测试
		wait for T;
		M_PC <= '1';
		wait for T*4;
		M_PC <= '0';
		wait for T*2;

		-- 3. 地址输出测试
		nPCH <= '0';
		wait for T;
		nPCH <= '1';
		nPCL <= '0';
		wait for T;
		nPCL <= '1';

		-- 4. 重置信号测试
		nreset <= '0';

		wait;
	end process;



end Behavioral;
