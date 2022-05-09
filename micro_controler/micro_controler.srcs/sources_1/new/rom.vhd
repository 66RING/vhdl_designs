library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- 读取文件
use ieee.std_logic_textio.all;
use std.textio.all;


-- TODO clk_ROM = clk2 & nclk1
entity rom is

	generic (WORDLENGTH : integer := 8;
			ADDRLENGTH : integer := 8);
	port(
		clk_ROM: in std_logic; 						-- ROM时钟信号
		M_ROM: in std_logic;						-- ROM片选信号
		ROM_EN: in std_logic; 						-- ROM使能信号
		addr: in std_logic_vector(11 downto 0); 	-- ROM地址信号
		data: inout std_logic_vector(7 downto 0)	-- 数据总线
	);

	-- port(
	-- 	addr: in std_logic_vector(ADDRLENGTH-1 downto 0);
	-- 	oe: in std_logic;
	-- 	dout: out std_logic_vector(WORDLENGTH-1 downto 0));
end entity;

architecture beh of rom is
	-- TODO ??? 学习语法range<>自动计算?
	type matrix is array (integer range<>) of std_logic_vector(WORDLENGTH-1 downto 0);
	signal rom: matrix(0 to 2**ADDRLENGTH-1);

	-- TODO 学习procedure
	procedure load_rom(signal data_word: out matrix) is
		file romfile: text open read_mode is "romfile.dat";
		variable lbuf: line;
		variable i: integer := 0; 		-- 循环变量
		variable fdata: std_logic_vector(7 downto 0);
	begin
		-- 读数据直到文件末尾
		-- while not endfile(romfile) loop
		while i < 9 loop
			readline(romfile, lbuf);
			read(lbuf, fdata);
			data_word(i) <= fdata;
			i := i+1;
		end loop;
	end procedure;
begin
	load_rom(rom);
	-- dout <= rom(conv_integer(addr)) when oe = '0'
	-- 	else (others=>'Z');

	process(clk_ROM, M_ROM, ROM_EN)
	begin
		if M_ROM = '1' and ROM_EN = '1' then 		-- 如果片选选中，且使能
			if clk_ROM'event and clk_ROM = '1' then
				data <= rom(conv_integer(addr));
			end if;
		else 
			data <= (others=>'Z');
		end if;
	end process;

end beh;



