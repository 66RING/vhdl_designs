library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- 读取文件
use ieee.std_logic_textio.all;
use std.textio.all;


-- TODO clk_ROM = clk2 & nclk1
entity uMC_ROM is

	generic (WORDLENGTH : integer := 48;
			ADDRLENGTH : integer := 8);
	-- port(
	-- 	clk_ROM: in std_logic; 						-- uMC_ROM时钟信号
	-- 	M_ROM: in std_logic;						-- uMC_ROM片选信号
	-- 	ROM_EN: in std_logic; 						-- uMC_ROM使能信号
	-- 	addr: in std_logic_vector(11 downto 0); 	-- uMC_ROM地址信号
	-- 	data: inout std_logic_vector(WORDLENGTH-1 downto 0)	-- 数据总线
	-- );

	port(
		addr: in std_logic_vector(ADDRLENGTH-1 downto 0);
		oe: in std_logic;
		dout: out std_logic_vector(WORDLENGTH-1 downto 0));
end entity;

architecture beh of uMC_ROM is
	-- TODO ??? 学习语法range<>自动计算?
	type matrix is array (integer range<>) of std_logic_vector(WORDLENGTH-1 downto 0);
	signal uROM: matrix(0 to 2**ADDRLENGTH-1);

	-- TODO 学习procedure
	procedure load_rom(signal data_word: out matrix) is
		file uMC_ROM_FILE: text open read_mode is "./uROM.mem";
		variable lbuf: line;
		variable i: integer := 0; 		-- 循环变量
		variable fdata: std_logic_vector(47 downto 0);
		variable good: boolean;   -- Status of the read operations
	begin
		-- 读数据直到文件末尾
		-- while not endfile(uMC_ROM_FILE) loop
		while i < 255 loop
			readline(uMC_ROM_FILE, lbuf);

			hread(lbuf,fdata,good);     -- Read the A argument as hex value
            assert good
                report "Text I/O read error"
                severity ERROR;

			data_word(i) <= fdata;

			i := i+1;
		end loop;


		while endfile(uMC_ROM_FILE) loop  -- Check EOF
			assert false
				report "End of file encountered; exiting."
				severity NOTE;
			exit;
		end loop;

	end procedure;
begin
	load_rom(uROM);

	dout <= uROM(conv_integer(addr)) when oe = '1'
		else x"003119F37900";

	-- process(clk_ROM, M_ROM, ROM_EN)
	-- begin
	-- 	if M_ROM = '1' and ROM_EN = '1' then 		-- 如果片选选中，且使能
	-- 		if clk_ROM'event and clk_ROM = '1' then
	-- 			data <= uROM(conv_integer(addr));
	-- 		end if;
	-- 	else 
	-- 		data <= (others=>'Z');
	-- 	end if;
	-- end process;

end beh;



