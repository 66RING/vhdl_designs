-- 双端口ram
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity dualram is
	generic(
		width : positive;
		depth : positive	-- 地址线宽度
	);

	port(
		-- port A is only for writing
		clka : in std_logic;
		wr : in std_logic;
		addra : in std_logic_vector(depth - 1 downto 0);
		datain : in std_logic_vector(width - 1 downto 0);
		-- port B is only for reading
		clkb : in std_logic;
		rd : in std_logic;
		addrb : in std_logic_vector(depth - 1 downto 0);
		dataout : out std_logic_vector(width - 1 downto 0)
	);

end entity dualram;

architecture behav of dualram is
	-- 容量为2^depth个单元
	type ram is array(2 ** depth - 1 downto 0) of std_logic_vector(width - 1 downto 0);
	signal dualram : ram;
begin

	process(clka)
	begin
		if clka'event and clka = '1' then
			if wr = '0' then
				-- 根据地址索引，写道对应数组中
				-- 地址由pointer计数器控制
				dualram(conv_integer(addra)) <= datain;
			end if;
		end if;
	end process;

	process(clkb)
	begin
		if clkb'event and clkb = '1' then
			-- 需要注意数组，unsigned和signed
			if rd = '0' then
				dataout <= dualram(conv_integer(addrb));
			end if;
		end if;
	end process;
end behav;
