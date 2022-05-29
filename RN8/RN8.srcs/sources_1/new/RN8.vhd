library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



entity rn8 is
	port(
		clk,rst,RN_CS,WRRN,RDRN: in std_logic;
		RS: in std_logic_vector(2 downto 0);
		RD: in std_logic_vector(2 downto 0);
		data: inout std_logic_vector(7 downto 0)
		);
end entity;

architecture beh of rn8 is
	type reg_t is array(0 to 7) of std_logic_vector(7 downto 0);
	signal reg: reg_t := (others=>(others=>'0'));
begin
	process(clk, rst)
	begin
		if rst = '1' then
			for i in 0 to 7 loop
				reg(i) <= (others=>'0');
			end loop;
			data <= (others=>'Z');
		elsif clk'event and clk = '1' then
			if RN_CS = '1' then
				if WRRN = '1' then
					reg(conv_integer(RD)) <= data;
					data <= (others=>'Z');
				elsif RDRN = '1' then
					data <= reg(conv_integer(RS));
				end if;
			else
				data <= (others=>'Z');
			end if;
		end if;

	end process;	



end beh;



