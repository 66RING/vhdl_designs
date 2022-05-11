-- mov sp, #data
-- push ri
-- pop ri

-- 存储
-- 出栈，加1
-- 入栈，减1

library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sp is
	port(
		SP_out: out std_logic_vector(7 downto 0);

		clk_SP: in std_logic;
		nreset: in std_logic;
		SP_CS: in std_logic;
		SP_UP: in std_logic;
		SP_DN: in std_logic;
		nSP_EN: in std_logic;
		AR: out std_logic_vector(6 downto 0);		-- sp输出ram地址
		-- data: inout std_logic_vector(7 downto 0));
		spin: in std_logic_vector(7 downto 0));
end entity;


-- 上升沿有效, SP_CS=1
-- 存储功能：nSP_EN=1: SP <= data
-- 加1功能：SP_UP=1, nSP_EN=0:  SP<=SP+1,AR<=SP
-- 减1功能：SP_DN=1, nSP_EN=0:  SP<=SP-1,AR<=SP

architecture beh of sp is
	-- SP容量
	type ram_t is array(2**6 - 1 downto 0) of std_logic_vector(7 downto 0);
	-- signal SP: std_logic_vector(6 downto 0);
	-- signal stack: ram_t;
begin

	process(clk_SP, nreset, SP_CS, SP_DN, SP_UP, nSP_EN)
		variable SP: std_logic_vector(6 downto 0);
	begin
		SP_out <= '0' & SP;

		if nreset = '0' then
			SP := (others=>'0');
			AR <= (others=>'0');
			-- data <= (others=>'Z');
		elsif clk_SP'event and clk_SP = '1' then
			if SP_CS = '0' then
				SP := spin(6 downto 0);
			elsif SP_CS = '1' then
				if nSP_EN = '0' then 	-- SP输出使能
					if SP_UP = '1' then
						AR <= SP;
						SP := SP + 1;
					elsif SP_DN = '1' then
						SP := SP - 1;
						AR <= SP;
					end if;
				else
					AR <= (others=>'Z');
				end if;
			else
				AR <= (others=>'Z');
			end if;
		end if;
	end process;




end beh;

