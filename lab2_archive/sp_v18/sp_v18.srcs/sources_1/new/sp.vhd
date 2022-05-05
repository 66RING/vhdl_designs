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
		clk_SP: in std_logic;
		nreset: in std_logic;
		SP_CS: in std_logic;
		SP_UP: in std_logic;
		SP_DN: in std_logic;
		nSP_EN: in std_logic;
		AR: out std_logic_vector(6 downto 0);		-- sp输出ram地址
		data: in std_logic_vector(7 downto 0));
end entity;


-- 上升沿有�?, SP_CS=1
-- 存储功能：nSP_EN=1: SP <= data
-- �?1功能：SP_UP=1, nSP_EN=0:  SP<=SP+1,AR<=SP
-- �?1功能：SP_DN=1, nSP_EN=0:  SP<=SP-1,AR<=SP

architecture beh of sp is
	-- SP容量
	type ram_t is array(2**6 - 1 downto 0) of std_logic_vector(7 downto 0);
	signal SP: std_logic_vector(6 downto 0);
	-- signal stack: ram_t;
begin

	process(clk_SP, nreset, SP_CS, SP_DN, SP_UP, nSP_EN)
	begin
		if nreset = '0' then
			SP <= (others=>'0');
			AR <= (others=>'0');
			-- data <= (others=>'Z');
		else
			if SP_CS = '1' then
				if clk_SP'event and clk_SP = '1' then
					-- 存储功能：置sp
					-- TODO 应该是和ram交互�?
					if nSP_EN = '1' then
						--data <= (others=>'Z');
						-- TODO
						SP <= data(6 downto 0);
					elsif nSP_EN='0' then
					-- TODO in case of stack overflow
						if SP_UP = '1' then
							SP <= SP + 1;
							AR <= SP;
						elsif SP_DN = '1' then
							SP <= SP - 1;
							AR <= SP;
						end if;
					end if;

				end if;
			end if;

		end if;
	end process;




end beh;

